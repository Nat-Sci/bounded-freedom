#!/usr/bin/env python3
"""Exercise the real entry helper with a local Codex stub, never a model call."""

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path

HELPER = Path(os.environ.get("SOL_CHIEF_HELPER", Path(__file__).resolve().parent.parent / ".agents/skills/cost-efficient-orchestration/scripts/start-sol-chief.sh"))


class StartSolChiefTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.record = self.root / "record.json"
        stub = self.root / "codex"
        stub.write_text("#!/usr/bin/env python3\nimport json, os, sys\n"
                        "from pathlib import Path\n"
                        "Path(os.environ['STUB_RECORD']).write_text(json.dumps({'argv': sys.argv[1:], 'cwd': os.getcwd(), 'stdin': sys.stdin.read()}))\n"
                        "sys.exit(int(os.environ.get('STUB_STATUS', '0')))\n")
        stub.chmod(0o755)
        self.env = dict(os.environ, PATH=str(self.root) + os.pathsep + os.environ["PATH"], STUB_RECORD=str(self.record))

    def run_helper(self, *args, stdin="", status=0):
        return subprocess.run(["sh", str(HELPER), *map(str, args)], cwd=self.root,
                              env=dict(self.env, STUB_STATUS=str(status)), input=stdin,
                              text=True, capture_output=True)

    def test_interactive_pair_cwd_and_status(self):
        result = self.run_helper(stdin="interactive input", status=17)
        self.assertEqual(17, result.returncode)
        record = json.loads(self.record.read_text())
        self.assertEqual(["--model", "gpt-6.1-sol", "-c", 'model_reasoning_effort="max"'], record["argv"])
        self.assertEqual(str(self.root.resolve()), record["cwd"])
        self.assertEqual("interactive input", record["stdin"])

    def test_handoff_modes_and_stdin(self):
        brief = self.root / "brief.txt"
        brief.write_text("private handoff\n")
        for prefix, extra in [((), []), (("--ephemeral-read-only",), ["--ephemeral", "--sandbox", "read-only", "--json"])]:
            with self.subTest(prefix=prefix):
                result = self.run_helper(*prefix, "--handoff", brief, status=7)
                self.assertEqual(7, result.returncode)
                record = json.loads(self.record.read_text())
                self.assertEqual(["exec", "--model", "gpt-6.1-sol", "-c", 'model_reasoning_effort="max"', *extra, "-"], record["argv"])
                self.assertEqual("private handoff\n", record["stdin"])
                self.assertEqual(str(self.root.resolve()), record["cwd"])
                self.assertNotIn("private handoff", result.stdout + result.stderr)

    def test_invalid_inputs_never_invoke_codex(self):
        blank, empty, large, boundary = (self.root / name for name in ("blank", "empty", "large", "boundary"))
        blank.write_text(" \n\t")
        empty.write_text("")
        large.write_text("x" * 16385)
        boundary.write_text("x" * 16384)
        cases = [("--handoff",), ("--handoff", self.root / "missing"), ("--handoff", self.root),
                 ("--handoff", blank), ("--handoff", empty), ("--handoff", large),
                 ("--ephemeral-read-only",), ("--model", "other"), ("--handoff", boundary, "extra")]
        for args in cases:
            with self.subTest(args=args):
                self.assertEqual(2, self.run_helper(*args).returncode)
                self.assertFalse(self.record.exists())
        self.assertEqual(0, self.run_helper("--handoff", boundary).returncode)
        self.assertTrue(self.record.exists())

    def test_help_never_invokes_codex(self):
        self.assertEqual(0, self.run_helper("--help").returncode)
        self.assertFalse(self.record.exists())


if __name__ == "__main__":
    unittest.main()
