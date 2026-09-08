#!/usr/bin/env python3
"""Targeted tests for the Codex task resource snapshot utility."""

from __future__ import annotations

import json
import os
import sqlite3
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(".agents/skills/cost-efficient-orchestration/scripts/codex-task-resource-snapshot.py").resolve()


def run_snapshot(
    codex_home: Path,
    thread_id: str,
    now: str,
    output_format: str = "json",
    env=None,
):
    command_env = os.environ.copy()
    if env:
        command_env.update(env)
    command_env["HOME"] = os.fspath(codex_home.parent.parent)
    cmd = [
        "python3",
        str(SCRIPT),
        "--format",
        output_format,
        "--codex-home",
        str(codex_home),
        "--thread-id",
        thread_id,
        "--now",
        now,
    ]
    proc = subprocess.run(cmd, text=True, capture_output=True, check=True, env=command_env)
    stdout = proc.stdout.strip()
    if output_format == "json":
        return json.loads(stdout)
    return stdout


def mk_home() -> Path:
    root = Path(tempfile.mkdtemp(prefix="codex-task-resource-snapshot-"))
    home = root / "codex"
    home.mkdir()
    return home


def write_rollout(path: Path, records) -> None:
    with path.open("w", encoding="utf-8") as handle:
        for item in records:
            handle.write(json.dumps(item))
            handle.write("\n")


def write_sqlite(
    db_path: Path,
    chief_id: str,
    chief_rollout: str,
    children,
) -> None:
    db_path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(db_path) as conn:
        cur = conn.cursor()
        cur.execute(
            """
            CREATE TABLE threads (
              id TEXT PRIMARY KEY,
              model TEXT,
              reasoning_effort TEXT,
              agent_role TEXT,
              rollout_path TEXT,
              created_at INTEGER
            )
            """
        )
        cur.execute(
            "CREATE TABLE thread_spawn_edges (parent_thread_id TEXT, child_thread_id TEXT, status TEXT)"
        )
        cur.execute(
            "INSERT INTO threads VALUES (?, ?, ?, ?, ?, ?)",
            (chief_id, "gpt-5.6-sol", "high", "Chief", chief_rollout, 1),
        )
        for child_id, child_rollout, model, effort, role in children:
            cur.execute(
                "INSERT INTO threads VALUES (?, ?, ?, ?, ?, ?)",
                (child_id, model, effort, role, child_rollout, 2),
            )
            cur.execute(
                "INSERT INTO thread_spawn_edges VALUES (?, ?, ?)",
                (chief_id, child_id, "open"),
            )


def session_meta(thread_id: str, timestamp: str):
    return {"timestamp": timestamp, "type": "session_meta", "payload": {"id": thread_id}}


def turn_context(timestamp: str, turn_id: str, model: str | None = None, effort: str | None = None) -> dict:
    payload = {"turn_id": turn_id}
    if model is not None:
        payload["model"] = model
    if effort is not None:
        payload["effort"] = effort
    return {
        "timestamp": timestamp,
        "type": "turn_context",
        "payload": payload,
    }


def token_count(
    timestamp: str,
    total_input: int,
    total_cached: int,
    total_output: int,
    total_reasoning: int,
    total_total: int,
    last: dict | None = None,
):
    payload = {
        "type": "token_count",
        "info": {
            "total_token_usage": {
                "input_tokens": total_input,
                "cached_input_tokens": total_cached,
                "output_tokens": total_output,
                "reasoning_output_tokens": total_reasoning,
                "total_tokens": total_total,
            },
        },
    }
    if last is not None:
        payload["info"]["last_token_usage"] = last
    return {"timestamp": timestamp, "type": "event_msg", "payload": payload}


def task_complete(timestamp: str, turn_id: str, duration_ms: int):
    return {
        "timestamp": timestamp,
        "type": "event_msg",
        "payload": {"type": "task_complete", "turn_id": turn_id, "duration_ms": duration_ms},
    }


class TaskResourceSnapshotTest(unittest.TestCase):
    def test_selects_latest_chief_turn_only(self):
        home = mk_home()
        chief_rollout = home / "rollout-chief.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-a", "2026-01-01T00:00:00Z"),
                turn_context("2026-01-01T00:00:00Z", "old-turn"),
                token_count(
                    "2026-01-01T00:01:00Z",
                    50,
                    10,
                    5,
                    3,
                    58,
                ),
                turn_context("2026-01-01T00:20:00Z", "new-turn"),
                token_count(
                    "2026-01-01T00:21:00Z",
                    70,
                    12,
                    12,
                    8,
                    90,
                ),
                token_count(
                    "2026-01-01T00:22:00Z",
                    90,
                    20,
                    14,
                    11,
                    125,
                ),
                task_complete("2026-01-01T00:22:30Z", "new-turn", 120_000),
            ],
        )
        write_sqlite(home / "state_1.sqlite", "chief-a", chief_rollout.name, [])
        output = run_snapshot(home, "chief-a", "2026-01-01T00:30:00Z")
        self.assertEqual("observed", output["status"])
        self.assertEqual("gpt-5.6-sol", output["results"][0]["model"])
        self.assertEqual("high", output["results"][0]["reasoning_effort"])
        self.assertEqual(40, output["results"][0]["input_tokens"])
        self.assertEqual(9, output["results"][0]["output_tokens"])
        self.assertEqual(8, output["results"][0]["reasoning_output_tokens"])
        self.assertEqual(67, output["results"][0]["total_tokens"])

    def test_duplicate_totals_do_not_double_count(self):
        home = mk_home()
        chief_rollout = home / "rollout-dup.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-b", "2026-01-02T00:00:00Z"),
                turn_context("2026-01-02T00:00:00Z", "dup-turn"),
                token_count("2026-01-02T00:00:01Z", 10, 0, 1, 1, 12),
                token_count("2026-01-02T00:00:02Z", 10, 0, 1, 1, 12),
                token_count("2026-01-02T00:00:03Z", 60, 5, 2, 3, 65),
                token_count("2026-01-02T00:00:04Z", 60, 5, 2, 3, 65),
                task_complete("2026-01-02T00:00:10Z", "dup-turn", 120_000),
            ],
        )
        write_sqlite(home / "state_2.sqlite", "chief-b", chief_rollout.name, [])
        output = run_snapshot(home, "chief-b", "2026-01-02T00:10:00Z")
        self.assertEqual("observed", output["status"])
        self.assertEqual(60, output["results"][0]["input_tokens"])
        self.assertEqual(5, output["results"][0]["cached_input_tokens"])
        self.assertEqual(65, output["results"][0]["total_tokens"])

    def test_repeated_turn_context_is_one_turn_with_earliest_start(self):
        home = mk_home()
        chief_rollout = home / "rollout-repeated-context.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-context", "2026-01-02T00:00:00Z"),
                turn_context("2026-01-02T00:00:00Z", "same-turn"),
                token_count("2026-01-02T00:01:00Z", 10, 0, 1, 1, 12),
                turn_context("2026-01-02T00:05:00Z", "same-turn"),
                token_count("2026-01-02T00:06:00Z", 60, 5, 2, 3, 65),
            ],
        )
        write_sqlite(home / "state_2.sqlite", "chief-context", chief_rollout.name, [])
        output = run_snapshot(home, "chief-context", "2026-01-02T00:10:00Z")
        row = output["results"][0]
        self.assertEqual(1, row["turn_count"])
        self.assertEqual(600_000, output["wall_time_ms"])
        self.assertEqual(65, row["total_tokens"])

    def test_counter_reset_uses_last_usage_for_selected_turn(self):
        home = mk_home()
        chief_rollout = home / "rollout-reset.jsonl"
        last = {
            "input_tokens": 20,
            "cached_input_tokens": 5,
            "output_tokens": 3,
            "reasoning_output_tokens": 1,
            "total_tokens": 23,
        }
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-reset", "2026-01-02T00:00:00Z"),
                turn_context("2026-01-02T00:00:00Z", "old-turn"),
                token_count("2026-01-02T00:01:00Z", 100, 30, 10, 4, 110),
                turn_context("2026-01-02T00:20:00Z", "reset-turn"),
                token_count("2026-01-02T00:21:00Z", 20, 5, 3, 1, 23, last=last),
                token_count("2026-01-02T00:22:00Z", 40, 8, 6, 2, 46),
                task_complete("2026-01-02T00:23:00Z", "reset-turn", 120_000),
            ],
        )
        write_sqlite(home / "state_2.sqlite", "chief-reset", chief_rollout.name, [])
        output = run_snapshot(home, "chief-reset", "2026-01-02T00:30:00Z")
        row = output["results"][0]
        self.assertEqual(40, row["input_tokens"])
        self.assertEqual(8, row["cached_input_tokens"])
        self.assertEqual(6, row["output_tokens"])
        self.assertEqual(2, row["reasoning_output_tokens"])
        self.assertEqual(46, row["total_tokens"])

    def test_turn_context_model_and_effort_override_thread_row(self):
        home = mk_home()
        chief_rollout = home / "rollout-model-override.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-model", "2026-01-02T00:00:00Z"),
                turn_context(
                    "2026-01-02T00:20:00Z",
                    "model-turn",
                    model="gpt-6-astra",
                    effort="medium",
                ),
                token_count("2026-01-02T00:21:00Z", 20, 5, 3, 1, 23),
                task_complete("2026-01-02T00:23:00Z", "model-turn", 120_000),
            ],
        )
        write_sqlite(home / "state_2.sqlite", "chief-model", chief_rollout.name, [])
        output = run_snapshot(home, "chief-model", "2026-01-02T00:30:00Z")
        row = output["results"][0]
        self.assertEqual("gpt-6-astra", row["model"])
        self.assertEqual("medium", row["reasoning_effort"])

    def test_cached_input_subset_not_added_to_total(self):
        home = mk_home()
        chief_rollout = home / "rollout-cache.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-c", "2026-01-03T00:00:00Z"),
                turn_context("2026-01-03T00:00:00Z", "cache-turn"),
                token_count("2026-01-03T00:00:05Z", 80, 30, 8, 4, 112),
                task_complete("2026-01-03T00:00:20Z", "cache-turn", 30_000),
            ],
        )
        write_sqlite(home / "state_3.sqlite", "chief-c", chief_rollout.name, [])
        output = run_snapshot(home, "chief-c", "2026-01-03T00:10:00Z")
        row = output["results"][0]
        self.assertEqual("observed", output["status"])
        self.assertLessEqual(row["cached_input_tokens"], row["input_tokens"])
        self.assertEqual(80, row["input_tokens"])
        self.assertEqual(112, row["total_tokens"])
        self.assertEqual(112, output["observed_tokens"]["total_tokens"])

    def test_direct_child_in_window_and_old_child_excluded(self):
        home = mk_home()
        chief_rollout = home / "rollout-chief.jsonl"
        child_in_window = home / "rollout-child-in.jsonl"
        child_old = home / "rollout-child-old.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-d", "2026-01-04T00:10:00Z"),
                turn_context("2026-01-04T00:20:00Z", "chief-turn"),
                token_count("2026-01-04T00:21:00Z", 30, 2, 1, 3, 36),
                task_complete("2026-01-04T00:21:30Z", "chief-turn", 120_000),
            ],
        )
        write_rollout(
            child_in_window,
            [
                session_meta("child-in", "2026-01-04T00:00:00Z"),
                turn_context("2026-01-04T00:25:00Z", "child-turn"),
                token_count("2026-01-04T00:26:00Z", 20, 2, 2, 1, 23),
                task_complete("2026-01-04T00:30:00Z", "child-turn", 180_000),
            ],
        )
        write_rollout(
            child_old,
            [
                session_meta("child-old", "2026-01-04T00:00:00Z"),
                turn_context("2026-01-04T00:05:00Z", "child-old-turn"),
                token_count("2026-01-04T00:06:00Z", 999, 99, 1, 1, 101),
            ],
        )
        write_sqlite(
            home / "state_4.sqlite",
            "chief-d",
            chief_rollout.name,
            [
                ("child-in", child_in_window.name, "gpt-5.6-sol", "high", "Coder"),
                ("child-old", child_old.name, "gpt-5.6-sol", "high", "Coder"),
            ],
        )
        output = run_snapshot(home, "chief-d", "2026-01-04T00:40:00Z")
        self.assertEqual("observed", output["status"])
        row = output["results"][0]
        self.assertEqual(2, row["turn_count"])
        self.assertIn("Chief", row["roles"])
        self.assertIn("Coder", row["roles"])
        self.assertEqual(50, row["input_tokens"])

    def test_child_and_chief_elapsed_sum_can_exceed_wall_time(self):
        home = mk_home()
        chief_rollout = home / "rollout-chief.jsonl"
        child_rollout = home / "rollout-child.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-e", "2026-01-05T00:00:00Z"),
                turn_context("2026-01-05T00:20:00Z", "chief-turn"),
                token_count("2026-01-05T00:21:00Z", 25, 2, 3, 1, 30),
            ],
        )
        write_rollout(
            child_rollout,
            [
                session_meta("child-overlap", "2026-01-05T00:00:00Z"),
                turn_context("2026-01-05T00:21:00Z", "child-turn"),
                token_count("2026-01-05T00:22:00Z", 40, 5, 2, 1, 48),
                task_complete("2026-01-05T00:23:00Z", "child-turn", 700_000),
            ],
        )
        write_sqlite(
            home / "state_5.sqlite",
            "chief-e",
            chief_rollout.name,
            [("child-overlap", child_rollout.name, "gpt-5.6-terra", "low", "Coder")],
        )
        output = run_snapshot(home, "chief-e", "2026-01-05T00:30:00Z")
        self.assertEqual("partial", output["status"])
        self.assertEqual(2, len(output["results"]))
        self.assertTrue(any(row["active_elapsed_ms"] > output["wall_time_ms"] for row in output["results"]))
        self.assertTrue(any(row["active_elapsed_ms"] == 700_000 for row in output["results"]))

    def test_incomplete_root_coverage_is_explicit(self):
        home = mk_home()
        chief_rollout = home / "rollout-chief.jsonl"
        child_rollout = home / "rollout-child.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-f", "2026-01-06T00:00:00Z"),
                turn_context("2026-01-06T00:20:00Z", "open"),
                token_count("2026-01-06T00:21:00Z", 120, 15, 4, 6, 130),
            ],
        )
        write_rollout(
            child_rollout,
            [
                session_meta("child", "2026-01-06T00:00:00Z"),
                turn_context("2026-01-06T00:25:00Z", "child"),
                token_count("2026-01-06T00:26:00Z", 40, 5, 2, 1, 48),
                task_complete("2026-01-06T00:28:00Z", "child", 120_000),
            ],
        )
        write_sqlite(
            home / "state_6.sqlite",
            "chief-f",
            chief_rollout.name,
            [("child", child_rollout.name, "gpt-5.3-codex-spark", "medium", "Coder")],
        )
        output = run_snapshot(home, "chief-f", "2026-01-06T00:35:00Z")
        self.assertEqual("partial", output["status"])
        self.assertEqual("pre-final-checkpoint", output["coverage"])
        self.assertEqual(2, len(output["results"]))

    def test_text_output_is_compact_and_redacted(self):
        home = mk_home()
        chief_rollout = home / "rollout-chief.jsonl"
        child_rollout = home / "rollout-child.jsonl"
        write_rollout(
            chief_rollout,
            [
                session_meta("chief-text", "2026-01-07T00:00:00Z"),
                turn_context("2026-01-07T00:00:00Z", "chief"),
                token_count("2026-01-07T00:01:00Z", 25, 5, 2, 4, 31),
                task_complete("2026-01-07T00:01:30Z", "chief", 30_000),
            ],
        )
        write_rollout(
            child_rollout,
            [
                session_meta("child-text", "2026-01-07T00:00:00Z"),
                turn_context("2026-01-07T00:02:00Z", "child"),
                token_count("2026-01-07T00:03:00Z", 50, 12, 4, 4, 66),
                task_complete("2026-01-07T00:03:30Z", "child", 120_000),
            ],
        )
        write_sqlite(
            home / "state_7.sqlite",
            "chief-text",
            chief_rollout.name,
            [("child-text", child_rollout.name, "gpt-5.3-codex-spark", "medium", "Coder")],
        )
        output = run_snapshot(home, "chief-text", "2026-01-07T00:10:00Z", output_format="text")
        lines = output.splitlines()
        self.assertLess(len(lines), 12)
        self.assertIn("TASK RESOURCE SNAPSHOT", output)
        self.assertIn("Wall time:", output)
        self.assertNotIn("thread_id", output.lower())
        self.assertNotIn("path", output.lower())
        self.assertNotIn("prompt", output.lower())

    def test_unknown_when_data_missing(self):
        home = mk_home()
        output = run_snapshot(home, "missing-thread", "2026-01-08T00:00:00Z")
        self.assertEqual("unknown", output["status"])
        self.assertTrue(any("unavailable" in reason.lower() or "missing" in reason.lower() for reason in output["reasons"]))

    def test_unknown_when_flat_schema_rejected(self):
        home = mk_home()
        chief_rollout = home / "rollout-flat.jsonl"
        write_rollout(
            chief_rollout,
            [
                {"thread_id": "chief-flat", "turn_context": {"id": "t1", "start": "2026-01-09T00:00:00Z"}},
                {"thread_id": "chief-flat", "total_token_usage": {"input_tokens": 99}},
            ],
        )
        write_sqlite(home / "state_8.sqlite", "chief-flat", chief_rollout.name, [])
        output = run_snapshot(home, "chief-flat", "2026-01-09T00:10:00Z")
        self.assertEqual("unknown", output["status"])
        self.assertEqual([], output.get("results"))

    def test_output_does_not_leak_private_identifiers(self):
        home = mk_home()
        chief_rollout = home / "rollout-secret.jsonl"
        child_rollout = home / "rollout-secret-child.jsonl"
        secret_rollout = chief_rollout
        write_rollout(
            secret_rollout,
            [
                session_meta("CHIEF-SENSITIVE", "2026-01-10T00:00:00Z"),
                turn_context("2026-01-10T00:01:00Z", "chief-turn"),
                {
                    "timestamp": "2026-01-10T00:02:00Z",
                    "type": "event_msg",
                    "payload": {
                        "type": "task_complete",
                        "turn_id": "chief-turn",
                        "duration_ms": 5000,
                    },
                },
                token_count("2026-01-10T00:03:00Z", 20, 1, 1, 1, 22),
            ],
        )
        write_rollout(
            child_rollout,
            [
                session_meta("CHILD-SENSITIVE", "2026-01-10T00:00:00Z"),
                turn_context("2026-01-10T00:04:00Z", "child-turn"),
                token_count("2026-01-10T00:05:00Z", 40, 2, 2, 2, 46),
            ],
        )
        write_sqlite(
            home / "state_9.sqlite",
            "CHIEF-SENSITIVE",
            chief_rollout.name,
            [("CHILD-SENSITIVE", child_rollout.name, "gpt-5.6-terra", "low", "Coder")],
        )
        output = run_snapshot(home, "CHIEF-SENSITIVE", "2026-01-10T00:20:00Z")
        rendered = json.dumps(output)
        self.assertNotIn("CHIEF-SENSITIVE", rendered)
        self.assertNotIn("CHILD-SENSITIVE", rendered)
        self.assertNotIn("SECRET_PROMPT", rendered)

    def test_code_home_fallback_when_codex_home_missing(self):
        with tempfile.TemporaryDirectory(prefix="codex-task-resource-home-") as root:
            fallback_root = Path(root) / ".codex"
            fallback_root.mkdir()
            home = fallback_root
            chief_rollout = home / "rollout-home.jsonl"
            write_rollout(
                chief_rollout,
                [
                    session_meta("chief-g", "2026-01-11T00:00:00Z"),
                    turn_context("2026-01-11T00:01:00Z", "home-turn"),
                    token_count("2026-01-11T00:02:00Z", 40, 2, 3, 1, 45),
                ],
            )
            write_sqlite(home / "state_11.sqlite", "chief-g", chief_rollout.name, [])
            env = os.environ.copy()
            env.pop("CODEX_HOME", None)
            env["HOME"] = str(root)
            cmd = [
                "python3",
                str(SCRIPT),
                "--format",
                "json",
                "--thread-id",
                "chief-g",
                "--now",
                "2026-01-11T00:20:00Z",
            ]
            proc = subprocess.run(
                cmd,
                env=env,
                capture_output=True,
                text=True,
                check=True,
            )
            output = json.loads(proc.stdout.strip())
            self.assertIn(output["status"], {"observed", "partial"})
            self.assertGreater(output["results"][0]["input_tokens"], 0)
            self.assertEqual("gpt-5.6-sol", output["results"][0]["model"])


if __name__ == "__main__":
    unittest.main()
