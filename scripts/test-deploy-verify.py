#!/usr/bin/env python3
"""Production-entry regression tests, isolated from personal installations."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO = Path(__file__).resolve().parent.parent
PRIVATE = "private-account-sentinel-7821"


def tree(root):
    result = {}
    for path in root.rglob("*"):
        key = str(path.relative_to(root))
        if path.is_symlink():
            result[key] = ("link", path.readlink())
        elif path.is_file():
            result[key] = ("file", hashlib.sha256(path.read_bytes()).digest(), path.stat().st_mtime_ns)
        else:
            result[key] = ("dir",)
    return result


class DeploymentTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix=PRIVATE)
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.source = self.root / "source"
        self.target = self.root / "target"
        self.source.mkdir()
        for name in (".agents/skills", ".codex/agents", "install"):
            shutil.copytree(REPO / name, self.source / name, ignore=shutil.ignore_patterns("__pycache__"))
        (self.source / "scripts").mkdir()
        for name in ("deploy-verify.py", "install-global.sh"):
            shutil.copy2(REPO / "scripts" / name, self.source / "scripts" / name)
        shutil.copy2(REPO / "VERSION", self.source / "VERSION")

    def invoke(self, *args):
        result = subprocess.run([sys.executable, str(self.source / "scripts/deploy-verify.py"),
                                 "--target-root", str(self.target), *args], capture_output=True)
        self.assertTrue(PRIVATE.encode() not in result.stdout + result.stderr, "private output leaked")
        self.assertTrue(str(self.root).encode() not in result.stdout + result.stderr, "path leaked")
        self.assertTrue(not result.stderr, "unexpected stderr")
        return result

    def command(self, *args, ok=True):
        result = self.invoke("--format", "json", *args)
        self.assertEqual(result.returncode, 0 if ok else 1)
        receipt = json.loads(result.stdout)
        self.assertEqual(receipt["live_route"], "not_run")
        return receipt

    def seed(self):
        (self.target / ".codex/agents").mkdir(parents=True)
        (self.target / ".codex/AGENTS.md").write_text(PRIVATE + " instructions\n")
        (self.target / ".codex/config.toml").write_text('model = "' + PRIVATE + '"\n')
        (self.target / ".codex/.env").write_text("HTTPS_PROXY=" + PRIVATE + "\n")
        (self.target / ".codex/agents/custom.toml").write_text(PRIVATE + "\n")

    def test_absent_is_read_only_failure(self):
        self.command(ok=False)
        self.assertFalse(self.target.exists())

    def test_apply_check_repeat_and_preservation(self):
        self.seed()
        originals = {name: (self.target / name).read_bytes() for name in
                     (".codex/AGENTS.md", ".codex/config.toml", ".codex/.env", ".codex/agents/custom.toml")}
        receipt = self.command("--apply")
        self.assertEqual(receipt["unmanaged_preservation"], "preserved")
        before = tree(self.target)
        self.command("--check")
        self.assertTrue(before == tree(self.target), "read-only check mutated target")
        self.command("--apply")
        self.command()
        for name, data in originals.items():
            actual = (self.target / name).read_bytes()
            self.assertTrue(actual.startswith(data) if name.endswith(("AGENTS.md", "config.toml")) else actual == data)

    def test_stale_source_and_repair(self):
        self.command("--apply")
        source = self.source / "install/global-agents.md"
        source.write_bytes(source.read_bytes() + b"\nChanged managed instructions\n")
        self.command(ok=False)
        self.command("--apply")
        self.command()

    def test_stale_linked_skill_fingerprint(self):
        self.command("--apply")
        source = self.source / ".agents/skills/cost-efficient-orchestration/SKILL.md"
        source.write_bytes(source.read_bytes() + b"\nUpdated linked policy\n")
        self.command(ok=False)
        self.command("--apply")

    def test_stale_managed_role_source(self):
        self.command("--apply")
        source = self.source / ".codex/agents/builder.toml"
        source.write_bytes(source.read_bytes() + b"\n# changed fixture source\n")
        self.command(ok=False)
        self.command("--apply")

    def test_modified_role_conflict(self):
        self.command("--apply")
        role = self.target / ".codex/agents/builder.toml"
        role.write_bytes(role.read_bytes() + PRIVATE.encode())
        before = tree(self.target)
        self.command("--apply", ok=False)
        self.assertTrue(before == tree(self.target), "conflict changed target")

    def test_unmanaged_config_conflict(self):
        self.seed()
        (self.target / ".codex/config.toml").write_text("[agents]\n# " + PRIVATE + "\n")
        before = tree(self.target)
        self.command("--apply", ok=False)
        self.assertTrue(before == tree(self.target), "preflight changed target")

    def test_installer_failure_is_sanitized(self):
        (self.source / "scripts/install-global.sh").write_text("echo '" + PRIVATE + "' >&2\nexit 7\n")
        self.command("--apply", ok=False)

    def test_unknown_status_is_rejected(self):
        self.command("--apply")
        installer = self.source / "scripts/install-global.sh"
        installer.write_text(installer.read_text().replace("show_status\n  exit 0", "show_status\n  echo '" + PRIVATE + "'\n  exit 0"))
        self.command(ok=False)

    def test_unknown_apply_output_is_rejected(self):
        installer = self.source / "scripts/install-global.sh"
        installer.write_text(installer.read_text().replace('echo "installation complete"',
                            "echo '" + PRIVATE + "'\n  echo \"installation complete\""))
        self.command("--apply", ok=False)

    def test_unmanaged_newline_change_is_detected(self):
        self.seed()
        (self.target / ".codex/AGENTS.md").write_text(PRIVATE)
        receipt = self.command("--apply", ok=False)
        self.assertEqual(receipt["unmanaged_preservation"], "changed")

    def test_detect_unmanaged_change(self):
        self.seed()
        installer = self.source / "scripts/install-global.sh"
        installer.write_text(installer.read_text().replace('echo "installation complete"',
                            'echo "changed" >> "$codex_proxy_env"\n  echo "installation complete"'))
        receipt = self.command("--apply", ok=False)
        self.assertEqual(receipt["unmanaged_preservation"], "changed")

    def test_host_variants(self):
        for host in ("portable", "claude", "all"):
            with self.subTest(host=host):
                self.target = self.root / host
                self.command("--host", host, "--apply")
                self.command("--host", host)

    def test_invalid_argument_is_sanitized(self):
        self.command("--host", PRIVATE, ok=False)

    def test_argument_error_format_options(self):
        cases = [
            (["--format=json", "--host", PRIVATE], "json"),
            (["--host", PRIVATE, "--format", "json"], "json"),
            (["--host", "json", "--format", "text"], "text"),
            (["--format", "text", "--host", "json"], "text"),
            (["--host", "json"], "text"),
            (["--format=json", "--format", "text", "--host", PRIVATE], "text"),
            (["--format=text", "--format", "json", "--host", PRIVATE], "json"),
            (["--format=json", "--format=" + PRIVATE], "text"),
            (["--format=" + PRIVATE, "--format=json"], "json"),
            (["--format=json", "--format"], "text"),
            (["--format", "--host", "json"], "text"),
            (["--", "--format=json"], "text"),
            (["--format=json", "--", "--format=text"], "json"),
            (["--for=json", "--host", PRIVATE], "json"),
        ]
        for index, (arguments, expected_format) in enumerate(cases):
            # Do not put planted private argument values in subtest diagnostics.
            with self.subTest(case=index):
                result = self.invoke(*arguments)
                self.assertEqual(result.returncode, 1)
                if expected_format == "json":
                    receipt = json.loads(result.stdout)
                    self.assertEqual(receipt["error"], "invalid_arguments")
                    self.assertEqual(receipt["live_route"], "not_run")
                else:
                    self.assertTrue(result.stdout.startswith(b"deploy-verify "))
                    self.assertTrue(b"error=invalid_arguments" in result.stdout)
        self.assertFalse(self.target.exists(), "argument failures mutated target")


if __name__ == "__main__":
    unittest.main()
