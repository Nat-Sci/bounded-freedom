#!/usr/bin/env python3
"""Check current routes at the policy/configuration entry points, not historical data."""

import json
import os
import subprocess
import sys
import tempfile
import tomllib
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SKILL = ROOT / ".agents/skills/cost-efficient-orchestration"
POLICY = json.loads((SKILL / "model-routing.json").read_text())
RESOLVER = Path(os.environ.get("MODEL_ROUTE_HELPER", SKILL / "scripts/resolve-model-route.py"))

LUNA = "gpt-6-luna"
TERRA = "gpt-6.1-terra"
SOL = "gpt-6.2-sol"
PREVIOUS_SOL = "gpt-6.1-sol"
ASTRA = "gpt-6.2-astra"
PREVIOUS_ASTRA = "gpt-6-astra"
DESKTOP = [f"{model}/{effort}" for model in (TERRA, SOL, ASTRA) for effort in ("low", "medium", "high")]
CLI = [*DESKTOP, f"{LUNA}/low", f"{LUNA}/medium"]


def listed_model(slug, *efforts):
    return {
        "slug": slug,
        "visibility": "list",
        "supported_reasoning_levels": [{"effort": effort} for effort in efforts],
    }


class CurrentRoutingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = (SKILL / "host-model-routing.md").read_text()

    def route(self, task, *args, surface="app-worker", available=DESKTOP, stdin=None, ok=True):
        with tempfile.TemporaryDirectory() as cwd:
            cmd = [sys.executable, str(RESOLVER), task, "--surface", surface, *args]
            if available is not None:
                cmd += ["--available", *available]
            run = subprocess.run(cmd, cwd=cwd, input=stdin, capture_output=True, text=True)
        self.assertEqual(0 if ok else 1, run.returncode, run.stderr)
        self.assertEqual("", run.stderr)
        result = json.loads(run.stdout)
        self.assertTrue(result["plan"])
        self.assertEqual(surface, result["surface"])
        self.assertEqual(task, result["task"])
        self.assertEqual(ok, result["status"] == "selected")
        return result

    def assert_route(self, result, role, lane, model, effort):
        self.assertEqual((role, lane, model, effort),
                         tuple(result[key] for key in ("role", "lane", "model", "effort")))

    def test_exact_pairs_are_bound_on_each_surface(self):
        desktop = self.route("inventory")
        self.assert_route(desktop, "Scout", "mechanical", TERRA, "low")
        self.assertEqual({"preferred_model": LUNA, "reasons": ["pair_not_advertised"]}, desktop["fallback"])
        cli = self.route("inventory", surface="cli", available=CLI)
        self.assert_route(cli, "Scout", "mechanical", LUNA, "low")
        self.assertIsNone(cli["fallback"])
        self.assert_route(self.route("inventory", available=[f"{TERRA}/medium", f"{SOL}/low"]),
                          "Scout", "mechanical", SOL, "low")

    def test_task_and_subtype_select_fit_before_availability(self):
        cases = [
            ("evidence-map", "default", "Scout", "mechanical", TERRA, "medium"),
            ("code-map", "default", "Scout", "mechanical", TERRA, "medium"),
            ("code-map", "interacting", "Scout", "balanced", SOL, "medium"),
            ("system-map", "default", "Scout", "balanced", SOL, "medium"),
            ("bounded-synthesis", "visual", "Scout", "grounded", TERRA, "medium"),
            ("bounded-synthesis", "interdependent", "Scout", "balanced", SOL, "medium"),
            ("code-edit", "default", "Coder", "grounded", TERRA, "medium"),
            ("code-edit", "fixed-transform", "Coder", "mechanical", TERRA, "low"),
            ("code-edit", "straightforward", "Coder", "mechanical", TERRA, "medium"),
            ("code-edit", "interdependent", "Coder", "balanced", SOL, "medium"),
            ("code-edit", "invariant-sensitive", "Coder", "balanced", SOL, "medium"),
            ("code-edit", "interacting-invariants", "Coder", "strong", SOL, "high"),
            ("coordinated-build", "frozen-template", "Builder", "mechanical", TERRA, "medium"),
            ("coordinated-build", "default", "Builder", "balanced", SOL, "medium"),
            ("coordinated-build", "stateful-recovery", "Builder", "strong", SOL, "high"),
        ]
        for task, subtype, *expected in cases:
            with self.subTest(task=task, subtype=subtype):
                self.assert_route(self.route(task, "--subtype", subtype), *expected)

    def test_missing_empty_and_wrong_effort_fail_closed(self):
        cases = [(None, "unknown", "missing_launch_evidence"),
                 ([], "unavailable", "empty_launch_catalog"),
                 ([f"{SOL}/low", f"{ASTRA}/medium"], "unavailable", "no_advertised_pair")]
        for catalog, status, reason in cases:
            with self.subTest(status=status, reason=reason):
                result = self.route("coordinated-build", available=catalog, ok=False)
                self.assertEqual((status, reason), (result["status"], result["reason"]))
                self.assertIsNone(result["model"])

    def test_exclusions_and_explicit_model_keep_exact_pair(self):
        eligible = [f"{LUNA}/low", f"{TERRA}/low", f"{SOL}/low"]
        result = self.route("inventory", "--exclude", f"{LUNA}/low", surface="cli", available=eligible)
        self.assertEqual(TERRA, result["model"])
        self.assertEqual(["pair_excluded"], result["fallback"]["reasons"])
        result = self.route("inventory", "--model", SOL, surface="cli", available=eligible)
        self.assertEqual(SOL, result["model"])
        self.assertEqual("explicit_model", result["reason"])
        self.assertIsNone(result["fallback"])
        result = self.route("inventory", "--model", LUNA, "--exclude", f"{LUNA}/low",
                            surface="cli", available=eligible, ok=False)
        self.assertEqual("requested_pair_excluded", result["reason"])

    def test_prior_sol_fallback_keeps_ordinary_effort(self):
        for subtype, lane, effort in (("default", "balanced", "medium"), ("stateful-recovery", "strong", "high")):
            with self.subTest(subtype=subtype):
                current, prior = f"{SOL}/{effort}", f"{PREVIOUS_SOL}/{effort}"
                result = self.route("coordinated-build", "--subtype", subtype, available=[prior])
                self.assert_route(result, "Builder", lane, PREVIOUS_SOL, effort)
                self.assertEqual(["pair_not_advertised"], result["fallback"]["reasons"])
                result = self.route("coordinated-build", "--subtype", subtype, available=[prior, current])
                self.assertEqual(SOL, result["model"])
                blocked = self.route("coordinated-build", "--subtype", subtype, "--exclude", current,
                                     available=[prior, current])
                self.assertEqual(PREVIOUS_SOL, blocked["model"])
                self.assertEqual(["pair_excluded"], blocked["fallback"]["reasons"])
                self.route("coordinated-build", "--subtype", subtype, "--model", SOL,
                           "--exclude", current, available=[prior, current], ok=False)
                self.route("coordinated-build", "--subtype", subtype,
                           available=[f"{PREVIOUS_SOL}/low", f"{TERRA}/{effort}", f"{ASTRA}/{effort}"], ok=False)

        for task, effort in (("inventory", "low"), ("bounded-synthesis", "medium")):
            with self.subTest(task=task):
                result = self.route(task, available=[f"{PREVIOUS_SOL}/{effort}", f"{TERRA}/{effort}"])
                self.assertEqual(TERRA, result["model"])
                result = self.route(task, available=[f"{PREVIOUS_SOL}/{effort}"])
                self.assertEqual(PREVIOUS_SOL, result["model"])

    def test_cli_catalog_file_and_stdin(self):
        hidden = dict(listed_model(SOL, "medium"), visibility="hide")
        inferred = dict(listed_model(SOL), default_reasoning_level="medium")
        malformed = dict(listed_model(SOL), supported_reasoning_levels=[None, "medium", {"effort": []}])
        snapshot = json.dumps({"models": [hidden, inferred, malformed, listed_model(PREVIOUS_SOL, "medium")]})
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "snapshot.json"
            path.write_text(snapshot)
            from_file = self.route("coordinated-build", "--cli-catalog", str(path), surface="cli", available=None)
        from_stdin = self.route("coordinated-build", "--cli-catalog", "-", surface="cli", available=None,
                                stdin=snapshot)
        self.assertEqual(from_file, from_stdin)
        self.assert_route(from_file, "Builder", "balanced", PREVIOUS_SOL, "medium")
        self.assertEqual("supplied_cli_catalog", from_file["evidence"])

    def test_catalog_rejects_invalid_or_unbindable_evidence(self):
        for content, reason in (('{"models": [', "invalid_cli_catalog"),
                                ('{"models": {}}', "invalid_cli_catalog"),
                                ('{"models": []}', "empty_launch_catalog"),
                                ('{"models": [{"slug": "gpt-6.2-sol", "supported_reasoning_levels": [{"effort": "medium"}]}]}',
                                 "empty_launch_catalog")):
            with self.subTest(reason=reason):
                result = self.route("coordinated-build", "--cli-catalog", "-", surface="cli", available=None,
                                    stdin=content, ok=False)
                self.assertEqual(reason, result["reason"])
                self.assertIsNone(result["model"])

        with tempfile.TemporaryDirectory() as directory:
            private = Path(directory) / "private-profile"
            result = self.route("coordinated-build", "--cli-catalog", str(private),
                                surface="cli", available=None, ok=False)
        self.assertEqual("cli_catalog_unreadable", result["reason"])
        self.assertNotIn(str(private), json.dumps(result))

    def test_catalog_is_cli_only_and_excludes_exact_pair_input(self):
        for args, expected in (
            (["--surface", "app-worker", "--cli-catalog", "-"], "--cli-catalog requires --surface cli"),
            (["--surface", "cli", "--cli-catalog", "-", "--available"], "not allowed with argument"),
        ):
            with self.subTest(args=args):
                run = subprocess.run([sys.executable, str(RESOLVER), "inventory", *args],
                                     capture_output=True, text=True)
                self.assertEqual(2, run.returncode)
                self.assertIn(expected, run.stderr)
                self.assertEqual("", run.stdout)

    def test_review_floor_and_explicit_same_family_fallback(self):
        for task in ("routine-review", "consequential-review"):
            with self.subTest(task=task):
                self.assert_route(self.route(task), "Reviewer", "review", SOL, "high")
                result = self.route(task, available=[f"{SOL}/medium", f"{PREVIOUS_SOL}/high", f"{TERRA}/high"])
                self.assert_route(result, "Reviewer", "review", PREVIOUS_SOL, "high")
                self.assertEqual(SOL, result["fallback"]["preferred_model"])
                self.route(task, available=[f"{SOL}/medium", f"{TERRA}/high"], ok=False)
                self.route(task, "--effort", "medium", "--depth-approved", ok=False)
                catalog = [f"{SOL}/high", f"{PREVIOUS_SOL}/high"]
                result = self.route(task, "--model", PREVIOUS_SOL, available=catalog)
                self.assert_route(result, "Reviewer", "review", PREVIOUS_SOL, "high")
                self.assertEqual("explicit_model", result["reason"])
                self.assertIsNone(result["fallback"])
                denied = self.route(task, "--model", PREVIOUS_SOL, "--exclude", f"{PREVIOUS_SOL}/high",
                                    available=catalog, ok=False)
                self.assertEqual("requested_pair_excluded", denied["reason"])
                result = self.route(task, "--exclude", f"{SOL}/high", available=catalog)
                self.assertEqual(["pair_excluded"], result["fallback"]["reasons"])
                self.route(task, "--effort", "max", "--depth-approved",
                           available=[f"{PREVIOUS_SOL}/max"], ok=False)

    def test_frontier_requires_admission_and_review_shortfall(self):
        catalog = [f"{ASTRA}/medium", f"{PREVIOUS_ASTRA}/medium"]
        self.route("coordinated-build", "--model", ASTRA, available=catalog, ok=False)
        self.route("coordinated-build", "--exclude", f"{SOL}/medium",
                   available=[*catalog, f"{SOL}/medium"], ok=False)
        self.assert_route(self.route("coordinated-build", "--frontier-approved", available=catalog),
                          "Builder", "frontier", ASTRA, "medium")
        fallback = self.route("coordinated-build", "--frontier-approved", available=catalog[1:])
        self.assert_route(fallback, "Builder", "frontier", PREVIOUS_ASTRA, "medium")
        self.assertEqual(ASTRA, fallback["fallback"]["preferred_model"])
        blocked = self.route("consequential-review", "--frontier-approved", ok=False)
        self.assertEqual("independent_review_shortfall_required", blocked["reason"])
        self.assert_route(self.route("consequential-review", "--frontier-approved", "--review-shortfall"),
                          "Reviewer", "frontier", ASTRA, "medium")

    def test_explicit_depth_requires_approval_and_host_support(self):
        available = [f"{TERRA}/medium", f"{TERRA}/max", f"{LUNA}/max"]
        self.route("inventory", "--effort", "max", available=available, ok=False)
        self.assert_route(self.route("inventory", "--effort", "max", "--depth-approved", available=available),
                          "Scout", "grounded", TERRA, "max")
        self.route("inventory", "--effort", "ultra", "--depth-approved", available=available, ok=False)

    def test_managed_defaults_and_role_permissions(self):
        project = tomllib.loads((ROOT / ".codex/config.toml").read_text())
        installed = tomllib.loads((ROOT / "install/agents-config.toml").read_text())
        self.assertEqual(project, installed)
        agents = project["agents"]
        self.assertEqual([TERRA, "low"], POLICY["untyped"])
        self.assertEqual(POLICY["untyped"],
                         [agents["default_subagent_model"], agents["default_subagent_reasoning_effort"]])
        self.assertEqual(4, agents["max_concurrent_threads_per_session"])
        self.assertEqual(1, agents["max_depth"])
        manifest = (ROOT / "install/codex-role-files.txt").read_text().splitlines()
        role_files = {line for line in manifest if line and not line.startswith("#")}
        expected = {
            "scout.toml": "read-only",
            "reviewer.toml": "read-only",
            "coder.toml": "workspace-write",
            "builder.toml": "workspace-write",
        }
        self.assertEqual(set(expected), role_files)
        for filename, sandbox in expected.items():
            with self.subTest(role=filename):
                role = tomllib.loads((ROOT / ".codex/agents" / filename).read_text())
                self.assertNotIn("model", role)
                self.assertNotIn("model_reasoning_effort", role)
                self.assertEqual(sandbox, role["sandbox_mode"])

    def test_balanced_sol_does_not_trigger_family_gate(self):
        gate = self.text.split("## Capability gates\n", 1)[1].split("\n## ", 1)[0]
        self.assertRegex(gate, r"Before non-review strong or frontier execution")
        self.assertNotRegex(gate, r"Before non-review (?:Sol|GPT-6\.1 Sol)")
        self.assertIn("Sol/medium is balanced", gate)

    def test_chief_desktop_and_policy_pair_are_synchronized(self):
        self.assertEqual([SOL, "max"], POLICY["chief"])
        model, effort = POLICY["chief"]
        self.assertIn(f"`model: {model}`, `thinking: {effort}`", self.text)

    def test_release_version_is_synchronized(self):
        version = (ROOT / "VERSION").read_text().strip()
        self.assertRegex(version, r"^\d+\.\d+\.\d+$")
        self.assertIn(f"Current package: **v{version} ", (ROOT / "README.md").read_text())


if __name__ == "__main__":
    unittest.main()
