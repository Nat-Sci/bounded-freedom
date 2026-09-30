#!/usr/bin/env python3
"""Check current routes at the policy/configuration entry points, not historical data."""

import re
import tomllib
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
POLICY = ROOT / ".agents/skills/cost-efficient-orchestration/host-model-routing.md"


def table_rows(text):
    """Read named policy rows independently of descriptions and Markdown spacing."""
    rows = {}
    for line in text.splitlines():
        if not line.startswith("| `"):
            continue
        cells = [cell.strip().replace("`", "") for cell in line.strip("|").split("|")]
        is_subtype = cells[0] in {"code-edit", "coordinated-build"} and cells[2] not in {"Coder", "Builder"}
        key = (cells[0], cells[1]) if is_subtype else cells[0]
        if key in rows:
            raise ValueError(f"duplicate canonical route: {key}")
        rows[key] = cells
    return rows


def pairs(cell):
    return re.findall(r"(gpt-[\w.-]+)\s*/\s*(low|medium|high)\b", cell)


class CurrentRoutingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = POLICY.read_text()
        cls.rows = table_rows(cls.text)

    def test_discovery_and_review_routes(self):
        expected = {
            "inventory": ("Scout", [("gpt-6-luna", "low")]),
            "evidence-map": ("Scout", [("gpt-6-luna", "medium")]),
            "code-map": ("Scout", [("gpt-6-luna", "medium"), ("gpt-6.1-sol", "medium")]),
            "system-map": ("Scout", [("gpt-6.1-sol", "medium")]),
            "bounded-synthesis": ("Scout", [("gpt-6.1-sol", "medium")]),
            "routine-review": ("Reviewer", [("gpt-6.1-sol", "high")]),
            "consequential-review": ("Reviewer", [("gpt-6.1-sol", "high")]),
        }
        self.assertEqual(set(expected) | {"code-edit", "coordinated-build"}, {key for key in self.rows if isinstance(key, str)})
        for kind, (contract, route) in expected.items():
            with self.subTest(kind=kind):
                self.assertEqual(contract, self.rows[kind][2])
                self.assertEqual(route, pairs(self.rows[kind][-1]))

    def test_implementation_subtypes(self):
        expected = {
            ("code-edit", "Coder fixed transform"): ("gpt-6-luna", "low"),
            ("code-edit", "Coder straightforward local implementation"): ("gpt-6-luna", "medium"),
            ("code-edit", "Coder ordinary bounded implementation"): ("gpt-6.1-sol", "medium"),
            ("code-edit", "Coder invariant-sensitive bounded edit"): ("gpt-6.1-sol", "medium"),
            ("coordinated-build", "Builder frozen template integration"): ("gpt-6-luna", "medium"),
            ("coordinated-build", "Builder ordinary coordinated integration"): ("gpt-6.1-sol", "medium"),
            ("coordinated-build", "Builder stateful recovery integration"): ("gpt-6.1-sol", "high"),
        }
        actual_subtypes = {key for key in self.rows if isinstance(key, tuple)}
        self.assertEqual(set(expected), actual_subtypes)
        for kind, route in expected.items():
            with self.subTest(kind=kind):
                self.assertEqual([route], pairs(self.rows[kind][-1]))
        invariant_route = self.rows[("code-edit", "Coder invariant-sensitive bounded edit")][-1]
        self.assertRegex(invariant_route, r"high only for justified multiple interacting invariants")

    def test_managed_defaults_and_role_permissions(self):
        project = tomllib.loads((ROOT / ".codex/config.toml").read_text())
        installed = tomllib.loads((ROOT / "install/agents-config.toml").read_text())
        self.assertEqual(project, installed)
        agents = project["agents"]
        self.assertEqual("gpt-6-luna", agents["default_subagent_model"])
        self.assertEqual("low", agents["default_subagent_reasoning_effort"])
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
        self.assertNotRegex(self.text, r"gpt-5\.6-|gpt-6-terra")

    def test_release_version_is_synchronized(self):
        version = (ROOT / "VERSION").read_text().strip()
        self.assertRegex(version, r"^\d+\.\d+\.\d+$")
        self.assertIn(f"Current package: **v{version} ", (ROOT / "README.md").read_text())


if __name__ == "__main__":
    unittest.main()
