#!/usr/bin/env python3
"""Exercise the production release CLI with local Git repositories; no network."""
import json
import fcntl
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ENTRY = Path(__file__).resolve().with_name("release.py")


class ReleaseTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.repo = self.root / "source"
        self.repo.mkdir()
        self.remote = self.root / "remote.git"
        self.env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}
        self.env["HOME"] = str(self.root / "home")
        Path(self.env["HOME"]).mkdir()
        self.git("init", "-q", "-b", "fixture")
        self.git("config", "user.name", "Fixture")
        self.git("config", "user.email", "fixture@example.invalid")
        (self.repo / "scripts").mkdir()
        shutil.copyfile(ENTRY, self.repo / "scripts/release.py")
        self.write("scripts/test-model-routing.py", "from pathlib import Path\nassert Path('artifact').read_text() == 'reviewed'\n")
        self.write("scripts/test-start-sol-chief.py", "pass\n")
        self.write("artifact", "reviewed")
        self.git("add", "scripts", "artifact")
        self.git("commit", "-qm", "baseline")
        self.call(["git", "init", "--bare", "-q", str(self.remote)])
        self.git("remote", "add", "origin", str(self.remote))
        self.git("push", "-qu", "origin", "fixture")
        self.base = self.git("rev-parse", "HEAD")
        self.write("new", "reviewed addition")
        self.git("add", "new")

    def call(self, argv, cwd=None):
        p = subprocess.run(argv, cwd=cwd or self.repo, env=self.env, capture_output=True)
        self.assertEqual(p.returncode, 0, p.stderr.decode())
        return p.stdout.decode().strip()

    def git(self, *args):
        return self.call(["git", *args])

    def write(self, relative, text):
        (self.repo / relative).write_text(text)

    def release(self, *args, ok=True):
        p = subprocess.run([sys.executable, "scripts/release.py", "--check", "routing", *args],
                           cwd=self.repo, env=self.env, capture_output=True)
        r = json.loads(p.stdout)
        self.assertEqual(p.returncode == 0, ok, r)
        # Receipts contain no local paths, raw commands, identities or ref names.
        for secret in (str(self.root), "fixture@example.invalid", "refs/heads/fixture", "git push"):
            self.assertNotIn(secret, p.stdout.decode())
        self.assertNotIn(str(Path.home()), p.stdout.decode())
        self.assertFalse(p.stderr, p.stderr)
        return r

    def remote_head(self):
        return self.git("ls-remote", "origin", "refs/heads/fixture").split()[0]

    def publish(self, **kwargs):
        return self.release("--commit", "--message", "release fixture", "--push", **kwargs)

    def deployment_sources(self):
        package = ENTRY.parent.parent
        for name in (".agents/skills", ".codex/agents", "install"):
            shutil.copytree(package / name, self.repo / name,
                            ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
        for name in ("VERSION", "scripts/deploy-verify.py", "scripts/install-global.sh"):
            shutil.copy2(package / name, self.repo / name)
        self.git("add", "--", ".agents", ".codex", "install", "VERSION",
                 "scripts/deploy-verify.py", "scripts/install-global.sh")

    def assert_preflight_blocked(self, reason, *args):
        head, remote = self.git("rev-parse", "HEAD"), self.remote_head()
        r = self.release(*args, ok=False) if args else self.publish(ok=False)
        self.assertEqual(r["status"], "REPAIR")
        self.assertEqual(r["reason"], reason)
        self.assertEqual(self.git("rev-parse", "HEAD"), head)
        self.assertEqual(self.remote_head(), remote)
        self.assertEqual(r["checks"]["routing"]["result"], "skipped")
        return r

    def test_staged_home_text_is_blocked(self):
        homes = [str(Path.home()), self.env["HOME"],
                 "/".join(("", "home", "fixture-" + self.root.name)),
                 "\\".join(("C:", "Users", "fixture-" + self.root.name))]
        for home in homes:
            with self.subTest(kind="home_variant"):
                self.write("private.md", home + "/data\n")
                self.git("add", "private.md")
                self.assert_preflight_blocked("candidate_private_home_text")

    def test_changed_home_path_is_blocked_with_git_safe_names(self):
        name = "notes\n" + "/".join(("", "Users", "fixture-" + self.root.name, "report.md"))
        path = self.repo / name
        path.parent.mkdir(parents=True)
        path.write_text("ordinary text\n")
        self.git("add", "--", name)
        self.assert_preflight_blocked("candidate_private_home_path")

    def test_staged_whitespace_is_blocked(self):
        self.write("new", "reviewed addition  \n")
        self.git("add", "new")
        self.assert_preflight_blocked("candidate_whitespace_error")

    def test_safe_staged_content_ignores_unrelated_private_work(self):
        self.write("artifact", str(Path.home()) + "/private\n")
        self.write("dirty-private.md", str(Path.home()) + "/private\n")
        self.write("new", "Cache input=120 cached=100\nexample@example.invalid\n"
                   "https://api.example.invalid/users/public-project\n"
                   "$HOME/project\n/home/<user>/project\n/home/username/project\n")
        self.git("add", "new")
        r = self.publish()
        self.assertEqual(r["commit"], self.remote_head())
        self.assertEqual((self.repo / "artifact").read_text(), str(Path.home()) + "/private\n")

    def test_old_private_content_is_not_rescanned_on_unrelated_change(self):
        self.write("historical.md", str(Path.home()) + "/old\n")
        self.git("add", "historical.md")
        self.git("commit", "-qm", "historical fixture")
        self.git("push", "-q")
        self.write("new", "ordinary reviewed update\n")
        self.git("add", "new")
        self.assertEqual(self.publish()["status"], "READY")

    def test_outgoing_committed_private_change_cannot_bypass(self):
        # The later cleanup makes a net-tree-only comparison insufficient.
        self.write("private.md", str(Path.home()) + "/private\n")
        self.git("add", "private.md")
        self.git("commit", "-qm", "unpublished private fixture")
        self.git("rm", "-q", "private.md")
        self.git("commit", "-qm", "remove private fixture")
        head, remote = self.git("rev-parse", "HEAD"), self.remote_head()
        r = self.release("--push", ok=False)
        self.assertEqual(r["reason"], "outgoing_private_home_text")
        self.assertEqual(r["push"], "skipped")
        self.assertEqual(r["remote_match"], "different")
        self.assertEqual(self.git("rev-parse", "HEAD"), head)
        self.assertEqual(self.remote_head(), remote)

    def test_outgoing_committed_whitespace_is_blocked(self):
        self.write("new", "unpublished whitespace  \n")
        self.git("add", "new")
        self.git("commit", "-qm", "unpublished whitespace fixture")
        head, remote = self.git("rev-parse", "HEAD"), self.remote_head()
        r = self.release("--push", ok=False)
        self.assertEqual(r["reason"], "outgoing_whitespace_error")
        self.assertEqual(self.git("rev-parse", "HEAD"), head)
        self.assertEqual(self.remote_head(), remote)

    def test_new_destination_keeps_historical_formatting_and_checks_the_candidate(self):
        self.write("old.md", "historical formatting  \n")
        self.git("add", "old.md")
        self.git("commit", "-qm", "history")
        target = self.root / "publication.git"
        self.call(["git", "init", "--bare", "-q", str(target)])
        self.git("remote", "set-url", "--push", "origin", str(target))
        self.write("new", "fresh change\n")
        self.git("add", "new")
        receipt = self.publish()
        self.assertEqual(receipt["preflight"]["candidate"]["whitespace"], "passed")
        self.assertEqual(receipt["preflight"]["outgoing"], {"privacy": "passed", "whitespace": "skipped"})
        self.assertEqual(self.git("ls-remote", str(target), "refs/heads/fixture").split()[0], receipt["commit"])

    def test_new_destination_checks_reverted_private_home(self):
        self.write("old.md", str(Path.home()) + "/private\n")
        self.git("add", "old.md")
        self.git("commit", "-qm", "history")
        self.git("rm", "-q", "old.md")
        self.git("commit", "-qm", "cleanup")
        target = self.root / "publication.git"
        self.call(["git", "init", "--bare", "-q", str(target)])
        self.git("remote", "set-url", "--push", "origin", str(target))
        receipt = self.release("--push", ok=False)
        self.assertEqual(receipt["reason"], "outgoing_private_home_text")
        self.assertEqual(self.git("ls-remote", str(target), "refs/heads/fixture"), "")

    def test_happy_retry_and_unstaged_boundary(self):
        self.write("artifact", "unchecked")
        self.write("untracked", "unchecked")
        tree = self.git("write-tree")
        first = self.publish()
        self.assertEqual(first["tree"], tree)
        self.assertEqual(first["commit"], self.remote_head())
        self.assertEqual(self.git("show", "HEAD:artifact"), "reviewed")
        self.assertEqual((self.repo / "artifact").read_text(), "unchecked")
        second = self.publish()
        self.assertEqual(first["commit"], second["commit"])
        self.assertEqual(second["commit_action"], "already_completed")
        self.assertEqual(second["push"], "already_completed")
        self.assertEqual(second["checks"]["routing"]["result"], "reused")
        self.assertEqual(self.git("rev-list", "--count", "HEAD"), "2")

    def test_default_verifies_only(self):
        r = self.release()
        self.assertEqual(r["commit_action"], "unrequested")
        self.assertEqual(self.git("rev-parse", "HEAD"), self.base)
        self.assertEqual(self.remote_head(), self.base)

    def test_additional_stale_malformed_and_fresh_evidence(self):
        self.release()
        r = self.release("--check", "launch")
        self.assertEqual(r["checks"]["routing"]["result"], "reused")
        self.assertEqual(r["checks"]["launch"]["result"], "executed")
        p = self.repo / ".git/release-state/evidence.json"
        cache = json.loads(p.read_text())
        cache["routing"]["key"] = "stale"
        p.write_text(json.dumps(cache))
        r = self.release("--check", "launch")
        self.assertEqual(r["checks"]["routing"]["result"], "executed")
        self.assertEqual(r["checks"]["launch"]["result"], "reused")
        p.write_text("broken")
        self.assertEqual(self.release()["checks"]["routing"]["result"], "executed")
        self.assertEqual(self.release("--fresh")["checks"]["routing"]["result"], "executed")

    def test_failure_does_not_publish(self):
        self.write("artifact", "failing")
        self.git("add", "artifact")
        r = self.publish(ok=False)
        self.assertEqual(r["status"], "REPAIR")
        self.assertEqual(self.remote_head(), self.base)
        self.assertEqual(self.git("rev-parse", "HEAD"), self.base)

    def test_scope_changes_during_validation(self):
        self.env["RELEASE_FIXTURE_SOURCE"] = str(self.repo)
        self.write("scripts/test-model-routing.py", "import os, subprocess\nfrom pathlib import Path\np=Path(os.environ['RELEASE_FIXTURE_SOURCE'])\n(p/'new').write_text('changed')\nsubprocess.run(['git','-C',str(p),'add','new'], check=True)\n")
        self.git("add", "scripts/test-model-routing.py")
        r = self.publish(ok=False)
        self.assertEqual(r["reason"], "release_scope_changed")
        self.assertEqual(self.remote_head(), self.base)

    def test_non_fast_forward_partial_state(self):
        other = self.root / "other"
        self.call(["git", "clone", "-q", "-b", "fixture", str(self.remote), str(other)])
        for key, val in (("user.name", "Fixture"), ("user.email", "fixture@example.invalid")):
            self.call(["git", "config", key, val], other)
        (other / "divergence").write_text("other")
        self.call(["git", "add", "divergence"], other)
        self.call(["git", "commit", "-qm", "diverge"], other)
        self.call(["git", "push", "-q"], other)
        before = self.remote_head()
        r = self.publish(ok=False)
        self.assertEqual(r["status"], "DECISION")
        self.assertEqual(r["commit_action"], "completed")
        self.assertEqual(r["push"], "failed")
        self.assertEqual(r["remote_match"], "different")
        self.assertEqual(self.remote_head(), before)

    def test_interrupted_operation(self):
        (self.repo / ".git/MERGE_HEAD").write_text(self.base)
        self.assertEqual(self.publish(ok=False)["reason"], "git_operation_in_progress")
        self.assertEqual(self.remote_head(), self.base)

    def test_intent_to_add(self):
        self.write("intent", "hidden")
        self.git("add", "-N", "intent")
        self.assertEqual(self.publish(ok=False)["reason"], "intent_to_add")

    def test_hook_changes_index(self):
        hook = self.repo / ".git/hooks/pre-commit"
        hook.write_text("#!/bin/sh\nprintf changed > new\ngit add new\n")
        hook.chmod(0o755)
        r = self.publish(ok=False)
        self.assertEqual(r["reason"], "commit_postcondition_changed")
        self.assertEqual(self.remote_head(), self.base)

    def test_commit_hook_failure(self):
        hook = self.repo / ".git/hooks/pre-commit"
        hook.write_text("#!/bin/sh\nexit 1\n")
        hook.chmod(0o755)
        self.assertEqual(self.publish(ok=False)["reason"], "commit_failed")
        self.assertEqual(self.remote_head(), self.base)

    def test_deployment_failure_retains_push(self):
        self.deployment_sources()
        self.write("scripts/deploy-verify.py", "import json\nprint(json.dumps({'status':'failed'}))\nraise SystemExit(1)\n")
        self.git("add", "scripts/deploy-verify.py")
        r = self.release("--commit", "--message", "release", "--push",
                         "--deploy-target", str(self.root / "target"), ok=False)
        self.assertEqual(r["deployment"], "failed")
        self.assertEqual(r["push"], "completed")
        self.assertEqual(r["commit"], self.remote_head())

    def test_single_push_url_is_authoritative(self):
        other = self.root / "push.git"
        self.call(["git", "init", "--bare", "-q", str(other)])
        self.git("remote", "set-url", "--push", "origin", str(other))
        r = self.publish()
        observed = self.git("ls-remote", str(other), "refs/heads/fixture").split()[0]
        self.assertEqual(r["commit"], observed)
        self.assertEqual(self.remote_head(), self.base)

    def test_multiple_push_urls_stop(self):
        self.git("remote", "set-url", "--add", "--push", "origin", str(self.remote))
        self.git("remote", "set-url", "--add", "--push", "origin", str(self.root / "elsewhere"))
        self.assertEqual(self.publish(ok=False)["reason"], "ambiguous_push_target")

    def test_normal_git_environment(self):
        self.env.update(GIT_TERMINAL_PROMPT="0", GIT_PAGER="cat",
                        GIT_AUTHOR_NAME="Fixture author", GIT_SSH_COMMAND="false")
        self.assertEqual(self.release()["status"], "READY")

    def test_git_redirection_stops(self):
        self.env["GIT_INDEX_FILE"] = str(self.root / "other-index")
        self.assertEqual(self.publish(ok=False)["reason"], "git_environment_override")

    def test_expected_tree(self):
        tree = self.git("write-tree")
        self.assertEqual(self.release("--expect-tree", tree)["tree"], tree)
        self.write("new", "changed since review")
        self.git("add", "new")
        r = self.release("--expect-tree", tree, "--commit", "--message", "release", "--push", ok=False)
        self.assertEqual(r["reason"], "stale_expected_tree")
        self.assertEqual(r["checks"]["routing"]["result"], "skipped")
        self.assertEqual(self.remote_head(), self.base)
        self.assertEqual(self.git("rev-parse", "HEAD"), self.base)
        self.assertEqual(self.release("--expect-tree", "HEAD", ok=False)["reason"], "invalid_expected_tree")

    def test_push_nonzero_after_acceptance(self):
        self.push_wrapper()
        r = self.publish()
        self.assertEqual(r["push"], "completed")
        self.assertEqual(r["commit"], self.remote_head())
        self.assertEqual((self.root / "push-count").read_text(), "x")
        self.assertEqual(self.publish()["push"], "already_completed")
        self.assertEqual((self.root / "push-count").read_text(), "x")

    def push_wrapper(self, unknown=False):
        real_git = shutil.which("git", path=self.env["PATH"])
        binary = self.root / "bin"
        binary.mkdir()
        wrapper = binary / "git"
        wrapper.write_text(f"#!{sys.executable}\nimport subprocess, sys\nfrom pathlib import Path\n"
                           f"record=Path({str(self.root / 'push-count')!r})\n"
                           f"if {unknown!r} and sys.argv[1]=='ls-remote' and record.exists(): sys.exit(18)\n"
                           f"p=subprocess.run([{real_git!r}, *sys.argv[1:]])\n"
                           "if sys.argv[1]=='push':\n"
                           " record.write_text((record.read_text() if record.exists() else '')+'x')\n"
                           " sys.exit(17)\n"
                           "sys.exit(p.returncode)\n")
        wrapper.chmod(0o755)
        self.env["PATH"] = str(binary) + os.pathsep + self.env["PATH"]

    def test_push_unknown_postobservation(self):
        self.push_wrapper(unknown=True)
        r = self.publish(ok=False)
        self.assertEqual(r["push"], "unknown")
        self.assertEqual(r["remote_match"], "unknown")
        self.assertEqual((self.root / "push-count").read_text(), "x")

    def test_native_deployment_refreshes_same_fake_home(self):
        self.deployment_sources()
        target = Path(self.env["HOME"])
        # Install first through the normal authority, using this durable source.
        self.call([sys.executable, "scripts/deploy-verify.py", "--apply", "--format", "json",
                   "--target-root", str(target)])
        link = target / ".agents/skills/cost-efficient-orchestration"
        expected = (self.repo / ".agents/skills/cost-efficient-orchestration").resolve()
        self.assertEqual(link.resolve(), expected)
        # A staged policy change requires refresh, while unrelated edits survive.
        policy = self.repo / ".agents/skills/cost-efficient-orchestration/SKILL.md"
        policy.write_text(policy.read_text() + "\nFirst fixture revision.\n")
        self.git("add", "--", str(policy))
        self.write("artifact", "unrelated working edit")
        self.write("untracked", "unrelated untracked file")
        self.write("install/notes.txt", "unrelated installer notes")
        args = ("--commit", "--message", "release", "--push", "--deploy-target", str(target))
        first = self.release(*args)
        self.assertEqual(first["deployment"], "completed")
        self.assertEqual(link.resolve(), expected)
        policy.write_text(policy.read_text() + "\nSecond fixture revision.\n")
        self.git("add", "--", str(policy))
        second = self.release(*args)
        self.assertNotEqual(first["commit"], second["commit"])
        self.assertEqual(second["deployment"], "completed")
        self.assertEqual(link.resolve(), expected)
        self.assertIn("Second fixture revision", (link / "SKILL.md").read_text())
        retry = self.release(*args)
        self.assertEqual(retry["deployment"], "already_completed")
        self.assertEqual(retry["commit_action"], "already_completed")
        self.assertEqual(retry["push"], "already_completed")
        self.assertEqual(retry["checks"]["routing"]["result"], "reused")
        self.assertEqual((self.repo / "artifact").read_text(), "unrelated working edit")
        self.assertEqual((self.repo / "untracked").read_text(), "unrelated untracked file")
        self.assertEqual((self.repo / "install/notes.txt").read_text(), "unrelated installer notes")

    def test_deployment_rejects_relevant_unchecked_inputs(self):
        self.deployment_sources()
        target = self.root / "target"
        args = ("--commit", "--message", "release", "--push", "--deploy-target", str(target))
        for name in ("scripts/deploy-verify.py", "scripts/install-global.sh",
                     ".agents/skills/cost-efficient-orchestration/SKILL.md"):
            path = self.repo / name
            original = path.read_bytes()
            path.write_bytes(original + b"\n# unchecked input\n")
            self.assertEqual(self.release(*args, ok=False)["reason"], "deployment_inputs_changed")
            path.write_bytes(original)
        untracked = self.repo / ".agents/skills/cost-efficient-orchestration/unreviewed.txt"
        untracked.write_text("unchecked")
        self.assertEqual(self.release(*args, ok=False)["reason"], "deployment_inputs_changed")
        self.assertFalse(target.exists())
        self.assertEqual(self.remote_head(), self.base)

    def test_check_cannot_add_deployment_inputs(self):
        self.deployment_sources()
        self.env["RELEASE_FIXTURE_SOURCE"] = str(self.repo)
        self.write("scripts/test-model-routing.py",
                   "import os\nfrom pathlib import Path\n"
                   "for root in (Path.cwd(), Path(os.environ['RELEASE_FIXTURE_SOURCE'])):\n"
                   " (root/'.agents/skills/cost-efficient-orchestration/extra.txt').write_text('unchecked')\n")
        self.git("add", "scripts/test-model-routing.py")
        r = self.release("--commit", "--message", "release", "--push", "--deploy-target",
                         str(self.root / "target"), ok=False)
        self.assertEqual(r["reason"], "check_modified_snapshot")
        self.assertEqual(self.remote_head(), self.base)
        cache = json.loads((self.repo / ".git/release-state/evidence.json").read_text())
        self.assertFalse(cache["routing"]["passed"])

    def test_unstaged_runner(self):
        with (self.repo / "scripts/release.py").open("a") as f:
            f.write("\n# unchecked\n")
        self.assertEqual(self.publish(ok=False)["reason"], "release_entry_not_staged")

    def test_concurrent_wrapper(self):
        state = self.repo / ".git/release-state"
        state.mkdir()
        with (state / "lock").open("w") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self.assertEqual(self.publish(ok=False)["reason"], "release_already_running")
        self.assertEqual(self.remote_head(), self.base)

    def test_changed_tree_invalidates_evidence(self):
        self.release()
        self.write("new", "another reviewed addition")
        self.git("add", "new")
        self.assertEqual(self.release()["checks"]["routing"]["result"], "executed")

    def test_check_changes_snapshot(self):
        self.write("scripts/test-model-routing.py", "from pathlib import Path\nPath('artifact').write_text('changed')\n")
        self.git("add", "scripts/test-model-routing.py")
        self.assertEqual(self.publish(ok=False)["reason"], "check_modified_snapshot")
        cache = json.loads((self.repo / ".git/release-state/evidence.json").read_text())
        self.assertFalse(cache["routing"]["passed"])
        self.assertEqual(self.remote_head(), self.base)

    def test_unmerged_index(self):
        blob = self.git("rev-parse", "HEAD:artifact")
        p = subprocess.run(["git", "update-index", "--index-info"], cwd=self.repo,
                           env=self.env, input=f"0 {'0'*40}\tartifact\n100644 {blob} 1\tartifact\n100644 {blob} 2\tartifact\n", capture_output=True, text=True)
        self.assertEqual(p.returncode, 0)
        self.assertEqual(self.publish(ok=False)["reason"], "unmerged_index")


if __name__ == "__main__":
    unittest.main()
