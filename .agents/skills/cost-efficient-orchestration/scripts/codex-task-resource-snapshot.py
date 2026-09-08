#!/usr/bin/env python3
"""Compute compact resource snapshots from Codex state and rollout telemetry."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import sqlite3
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple


UTC = dt.timezone.utc
TEXT_PREFIX = "TASK RESOURCE SNAPSHOT"
METADATA_SOURCE = "local-codex-event-telemetry"
COVERAGE = "pre-final-checkpoint"

TOKEN_FIELDS = (
    "input_tokens",
    "cached_input_tokens",
    "output_tokens",
    "reasoning_output_tokens",
    "total_tokens",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--format",
        choices=("json", "text"),
        default="json",
        help="Output format.",
    )
    parser.add_argument("--codex-home", dest="codex_home", default=None, help="Codex home directory.")
    parser.add_argument("--thread-id", dest="thread_id", default=None, help="Chief thread identifier.")
    parser.add_argument(
        "--now",
        default=None,
        help="ISO-8601 UTC checkpoint timestamp override for deterministic fixtures.",
    )
    return parser.parse_args()


def parse_utc_timestamp(value: Optional[object]) -> Optional[dt.datetime]:
    if value is None:
        return None
    if isinstance(value, (int, float)):
        number = float(value)
        if number > 10_000_000_000:
            number /= 1000
        return dt.datetime.fromtimestamp(number, UTC)
    if not isinstance(value, str):
        return None
    text = value.strip()
    if not text:
        return None
    if text.endswith("Z"):
        text = f"{text[:-1]}+00:00"
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}", text):
        text = f"{text}+00:00"
    try:
        parsed = dt.datetime.fromisoformat(text)
    except ValueError:
        return None
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=UTC)
    return parsed.astimezone(UTC)


def to_epoch_ms(value: dt.datetime) -> int:
    return int(value.timestamp() * 1000)


def format_ms(value: Optional[int]) -> str:
    if value is None:
        return "unknown"
    ms = int(max(0, value))
    secs = ms // 1000
    mins, sec = divmod(secs, 60)
    hours, mins = divmod(mins, 60)
    if hours:
        return f"{hours}h {mins}m {sec}s"
    if mins:
        return f"{mins}m {sec}s"
    return f"{sec}s"


def format_int(value: int) -> str:
    return f"{int(value):,}"


def aggregate_tokens(rows: Sequence[Dict[str, object]]) -> Dict[str, int]:
    return {
        field: sum(int(row.get(field) or 0) for row in rows)
        for field in TOKEN_FIELDS
    }


def add_reason(reasons: List[str], reason: str) -> None:
    if reason and reason not in reasons:
        reasons.append(reason)


def parse_int(value: object) -> Optional[int]:
    if value is None or isinstance(value, bool):
        return None
    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def resolve_codex_home(args_home: Optional[str]) -> Optional[Path]:
    explicit = args_home if args_home is not None else os.environ.get("CODEX_HOME")
    if explicit and str(explicit).strip():
        return Path(explicit)
    home_env = os.environ.get("HOME")
    if home_env:
        return Path(home_env) / ".codex"
    return None


def latest_state_file(codex_home: Path) -> Optional[Path]:
    if not codex_home.exists():
        return None
    pattern = re.compile(r"^state_(\d+)\.sqlite$")
    latest_num = -1
    latest_path = None
    for entry in codex_home.iterdir():
        if not entry.is_file():
            continue
        match = pattern.match(entry.name)
        if not match:
            continue
        candidate = int(match.group(1))
        if candidate > latest_num:
            latest_num = candidate
            latest_path = entry
    return latest_path


def read_jsonl(path: Path) -> Iterable[Dict[str, object]]:
    with path.open("r", encoding="utf-8") as handle:
        for raw in handle:
            line = raw.strip()
            if not line:
                continue
            try:
                data = json.loads(line)
            except (json.JSONDecodeError, TypeError):
                continue
            if isinstance(data, dict):
                yield data


def load_rollout_owner_and_turns(path: Path) -> Tuple[Optional[str], List[Tuple[str, int]]]:
    owner: Optional[str] = None
    turns_by_id: Dict[str, int] = {}
    for record in read_jsonl(path):
        if record.get("type") != "turn_context":
            if record.get("type") == "session_meta" and owner is None:
                payload = record.get("payload")
                if isinstance(payload, dict):
                    owner_id = payload.get("id")
                    if isinstance(owner_id, str) and owner_id.strip():
                        owner = owner_id
            continue

        payload = record.get("payload")
        if not isinstance(payload, dict):
            continue
        turn_id = payload.get("turn_id")
        if not isinstance(turn_id, str) or not turn_id:
            continue
        start_time = parse_utc_timestamp(record.get("timestamp"))
        if start_time is None:
            continue
        start_ms = to_epoch_ms(start_time)
        prior_start = turns_by_id.get(turn_id)
        if prior_start is None or start_ms < prior_start:
            turns_by_id[turn_id] = start_ms
    return owner, sorted(turns_by_id.items(), key=lambda item: item[1])


def row_to_dict(cursor: sqlite3.Cursor, row: sqlite3.Row) -> Dict[str, object]:
    return {col[0]: row[idx] for idx, col in enumerate(cursor.description or [])}


def fetch_chief_thread(cursor: sqlite3.Cursor, thread_id: str) -> Optional[Dict[str, object]]:
    cursor.execute(
        """
        SELECT id, model, reasoning_effort, agent_role, rollout_path
        FROM threads
        WHERE id = ?
        LIMIT 1
        """,
        (thread_id,),
    )
    row = cursor.fetchone()
    if row is None:
        return None
    return row_to_dict(cursor, row)


def fetch_direct_children(cursor: sqlite3.Cursor, parent_id: str) -> List[Dict[str, object]]:
    try:
        cursor.execute(
            """
            SELECT
              child.id AS child_id,
              child.rollout_path,
              child.model,
              child.reasoning_effort,
              child.agent_role
            FROM thread_spawn_edges AS edges
            JOIN threads AS child
            ON child.id = edges.child_thread_id
            WHERE edges.parent_thread_id = ?
            """,
            (parent_id,),
        )
        rows = cursor.fetchall()
    except sqlite3.OperationalError:
        return []

    return [
        {
            "id": row["child_id"],
            "rollout_path": row["rollout_path"],
            "model": row["model"],
            "reasoning_effort": row["reasoning_effort"],
            "agent_role": row["agent_role"],
        }
        for row in rows
    ]


def extract_token_totals(payload: object, key: str) -> Optional[Dict[str, Optional[int]]]:
    if not isinstance(payload, dict):
        return None
    info = payload.get("info")
    if not isinstance(info, dict):
        return None
    values = info.get(key)
    if not isinstance(values, dict):
        return None
    result: Dict[str, Optional[int]] = {}
    for field in TOKEN_FIELDS:
        result[field] = parse_int(values.get(field))
    return result


def parse_turn_id(record: Dict[str, object]) -> Optional[str]:
    payload = record.get("payload")
    if not isinstance(payload, dict):
        return None
    turn_id = payload.get("turn_id")
    if isinstance(turn_id, str) and turn_id:
        return turn_id
    return None


def parse_rollout_turns(
    path: Path,
    thread_id: str,
    model: str,
    effort: str,
    role: str,
    selected_turns: Sequence[str],
    reasons: List[str],
) -> List[Dict[str, object]]:
    selected_turns = list(dict.fromkeys(selected_turns))
    states = {
        turn_id: {
            "role": role,
            "model": model,
            "reasoning_effort": effort,
            "start_ms": None,
            "complete_ms": None,
            "added": {field: 0 for field in TOKEN_FIELDS},
        }
        for turn_id in selected_turns
    }

    owner: Optional[str] = None
    file_totals: Dict[str, Optional[int]] = {field: None for field in TOKEN_FIELDS}
    active_turn: Optional[str] = None

    for record in read_jsonl(path):
        record_type = record.get("type")
        if record_type == "session_meta":
            if owner is None and isinstance(record.get("payload"), dict):
                payload = record["payload"]
                if isinstance(payload, dict):
                    payload_id = payload.get("id")
                    if isinstance(payload_id, str) and payload_id:
                        owner = payload_id
            continue

        if record_type == "turn_context":
            ts = parse_utc_timestamp(record.get("timestamp"))
            if ts is None:
                continue
            active_turn = parse_turn_id(record)
            if active_turn in states:
                start_ms = to_epoch_ms(ts)
                prior_start = states[active_turn]["start_ms"]
                if prior_start is None or start_ms < prior_start:
                    states[active_turn]["start_ms"] = start_ms
                payload = record.get("payload")
                if isinstance(payload, dict):
                    turn_model = payload.get("model")
                    turn_effort = payload.get("effort")
                    if isinstance(turn_model, str) and turn_model.strip():
                        states[active_turn]["model"] = turn_model.strip()
                    if isinstance(turn_effort, str) and turn_effort.strip():
                        states[active_turn]["reasoning_effort"] = turn_effort.strip()
            continue

        if record_type != "event_msg" or not isinstance(record.get("payload"), dict):
            continue

        payload = record["payload"]
        event_type = payload.get("type")
        if event_type == "task_complete":
            if active_turn is not None and active_turn in states:
                target = parse_turn_id(record)
                if not target:
                    target = active_turn
                if target in states:
                    duration = parse_int(payload.get("duration_ms"))
                    if duration is not None:
                        prior = states[target]["complete_ms"]
                        if prior is None or duration > prior:
                            states[target]["complete_ms"] = duration
            elif active_turn is not None:
                # explicit per-file guardrail: only the active turn can close.
                pass
            continue

        if event_type != "token_count":
            continue

        totals = extract_token_totals(payload, "total_token_usage")
        if totals is None:
            continue
        last_usage = extract_token_totals(payload, "last_token_usage")

        for field in TOKEN_FIELDS:
            current_total = totals.get(field)
            if current_total is None:
                continue

            prior_total = file_totals.get(field)
            reset_last = None
            if isinstance(last_usage, dict):
                reset_last = last_usage.get(field)

            if prior_total is None:
                delta = reset_last if reset_last is not None else current_total
            elif current_total >= prior_total:
                delta = current_total - prior_total
            elif reset_last is not None:
                delta = reset_last
            else:
                delta = current_total

            file_totals[field] = current_total

            if active_turn is None or active_turn not in states:
                continue
            state = states[active_turn]
            if delta > 0:
                state["added"][field] += delta

    if owner is None:
        add_reason(reasons, "missing rollout owner")
        return []
    if owner != thread_id:
        add_reason(reasons, "rollout ownership mismatch")
        return []

    parsed: List[Dict[str, object]] = []
    for turn_id in selected_turns:
        state = states.get(turn_id)
        if not state:
            continue
        if state["start_ms"] is None:
            continue
        parsed.append(
            {
                "turn_id": turn_id,
                "model": state["model"],
                "reasoning_effort": state["reasoning_effort"],
                "role": role,
                "start_ms": state["start_ms"],
                "complete_ms": state["complete_ms"],
                "added": state["added"],
            }
        )
    return parsed


def snapshot(codex_home: Path, thread_id: str, now: dt.datetime) -> Tuple[str, Optional[int], list, List[str]]:
    reasons: List[str] = []
    now_ms = to_epoch_ms(now)

    state_db = latest_state_file(codex_home)
    if state_db is None:
        add_reason(reasons, "missing state database")
        return "unknown", None, [], reasons

    try:
        with sqlite3.connect(f"{state_db.resolve().as_uri()}?mode=ro", uri=True) as conn:
            conn.row_factory = sqlite3.Row
            cursor = conn.cursor()
            chief = fetch_chief_thread(cursor, thread_id)
            if chief is None:
                add_reason(reasons, "chief thread record unavailable")
                return "unknown", None, [], reasons

            children = fetch_direct_children(cursor, thread_id)
    except sqlite3.OperationalError:
        add_reason(reasons, "state database unreadable")
        return "unknown", None, [], reasons

    chief_rollout_value = chief.get("rollout_path")
    if not isinstance(chief_rollout_value, str) or not chief_rollout_value.strip():
        add_reason(reasons, "chief rollout path missing")
        return "unknown", None, [], reasons

    chief_rollout = Path(chief_rollout_value)
    if not chief_rollout.is_absolute():
        chief_rollout = codex_home / chief_rollout
    if not chief_rollout.is_file():
        add_reason(reasons, "chief rollout file missing")
        return "unknown", None, [], reasons

    owner_id, chief_turn_contexts = load_rollout_owner_and_turns(chief_rollout)
    if owner_id is None:
        add_reason(reasons, "chief rollout ownership unreadable")
        return "unknown", None, [], reasons
    if owner_id != thread_id:
        add_reason(reasons, "chief rollout ownership mismatch")
        return "unknown", None, [], reasons

    if not chief_turn_contexts:
        add_reason(reasons, "no readable Chief turn context")
        return "unknown", None, [], reasons

    latest_turn_id, latest_turn_start_ms = max(chief_turn_contexts, key=lambda item: item[1])
    if now_ms < latest_turn_start_ms:
        add_reason(reasons, "checkpoint earlier than latest Chief turn")
        return "unknown", None, [], reasons

    selected_turns: List[Dict[str, object]] = []

    selected_turns.extend(
        parse_rollout_turns(
            path=chief_rollout,
            thread_id=thread_id,
            model=str(chief.get("model") or "unknown"),
            effort=str(chief.get("reasoning_effort") or "unknown"),
            role=str(chief.get("agent_role") or "Chief"),
            selected_turns=[latest_turn_id],
            reasons=reasons,
        )
    )

    for child in children:
        child_id = child.get("id")
        rollout_value = child.get("rollout_path")
        if not isinstance(child_id, str) or not isinstance(rollout_value, str):
            continue
        child_rollout = Path(rollout_value)
        if not child_rollout.is_absolute():
            child_rollout = codex_home / child_rollout
        if not child_rollout.is_file():
            continue

        child_owner, child_turn_contexts = load_rollout_owner_and_turns(child_rollout)
        if child_owner != child_id:
            continue
        eligible: List[str] = [
            turn_id
            for turn_id, turn_start_ms in child_turn_contexts
            if latest_turn_start_ms <= turn_start_ms <= now_ms
        ]
        if not eligible:
            continue
        selected_turns.extend(
            parse_rollout_turns(
                path=child_rollout,
                thread_id=child_id,
                model=str(child.get("model") or "unknown"),
                effort=str(child.get("reasoning_effort") or "unknown"),
                role=str(child.get("agent_role") or "Worker"),
                selected_turns=eligible,
                reasons=reasons,
            )
        )

    if not selected_turns:
        add_reason(reasons, "no selected turns in checkpoint window")
        return "unknown", now_ms - latest_turn_start_ms, [], reasons

    groups: Dict[Tuple[str, str], Dict[str, object]] = {}
    incomplete = False

    for turn in selected_turns:
        model = str(turn.get("model") or "unknown")
        effort = str(turn.get("reasoning_effort") or "unknown")
        role = str(turn.get("role") or "Unknown")
        key = (model, effort)
        group = groups.setdefault(
            key,
            {
                "model": model,
                "reasoning_effort": effort,
                "roles": set(),
                "turn_count": 0,
                "observed_token_turn_count": 0,
                "active_elapsed_ms": 0,
                "input_tokens": 0,
                "cached_input_tokens": 0,
                "output_tokens": 0,
                "reasoning_output_tokens": 0,
                "total_tokens": 0,
                "elapsed_complete": True,
            },
        )

        added = turn["added"]
        start_ms = turn.get("start_ms")
        complete_ms = turn.get("complete_ms")
        if start_ms is None:
            continue

        has_tokens = False
        for field in TOKEN_FIELDS:
            value = parse_int(added.get(field)) or 0
            group[field] += value
            if value:
                has_tokens = True
        if has_tokens:
            group["observed_token_turn_count"] = int(group["observed_token_turn_count"]) + 1

        if complete_ms is None:
            elapsed = now_ms - int(start_ms)
            incomplete = True
            group["elapsed_complete"] = False
        else:
            elapsed = max(0, int(complete_ms))
        group["active_elapsed_ms"] = int(group["active_elapsed_ms"]) + elapsed
        group["roles"] = set(group["roles"]) | {role}
        group["turn_count"] = int(group["turn_count"]) + 1

    rows = []
    for group in groups.values():
        roles = sorted(group.pop("roles"))
        group["roles"] = roles
        group["elapsed_status"] = "complete" if group.pop("elapsed_complete") else "to-checkpoint"
        rows.append(group)

    wall_time_ms = now_ms - latest_turn_start_ms
    status = "partial" if incomplete else "observed"
    return status, wall_time_ms, rows, reasons


def format_text(rows: List[Dict[str, object]], wall_time_ms: Optional[int], status: str, reason_lines: List[str]) -> str:
    lines = [TEXT_PREFIX, f"Wall time: {format_ms(wall_time_ms)}", f"Status: {status}"]
    observed = aggregate_tokens(rows)
    if any(int(row.get("observed_token_turn_count") or 0) for row in rows):
        lines.append(
            "Observed tokens: "
            f"total={format_int(observed['total_tokens'])} "
            f"input={format_int(observed['input_tokens'])} "
            f"cached={format_int(observed['cached_input_tokens'])} "
            f"output={format_int(observed['output_tokens'])} "
            f"reasoning={format_int(observed['reasoning_output_tokens'])}"
        )
    lines.append(
        "Source: local-codex-event-telemetry | Coverage: pre-final-checkpoint "
        "(final response and later telemetry are excluded)"
    )
    for row in sorted(rows, key=lambda item: (item["model"], item["reasoning_effort"])):
        elapsed_ms = int(row["active_elapsed_ms"])
        lines.append(
            f"{row['model']}/{row['reasoning_effort']}: "
            f"roles={','.join(row['roles'])} turns={row['turn_count']} "
            f"observed_token_turns={row['observed_token_turn_count']} "
            f"input={format_int(int(row['input_tokens']))} "
            f"cached={format_int(int(row['cached_input_tokens']))} "
            f"output={format_int(int(row['output_tokens']))} "
            f"reasoning={format_int(int(row['reasoning_output_tokens']))} "
            f"total={format_int(int(row['total_tokens']))} "
            f"active_elapsed={format_ms(elapsed_ms)} ({row['elapsed_status']})"
        )

    if reason_lines:
        for index, reason in enumerate(reason_lines, start=1):
            lines.append(f"Reason {index}: {reason}")

    lines.append("cached_input_tokens are included in input_tokens")
    lines.append("per-model active_elapsed_ms may exceed task wall time and may overlap")
    return "\n".join(lines)


def format_json(rows: List[Dict[str, object]], wall_time_ms: Optional[int], status: str, reason_lines: List[str]) -> str:
    payload = {
        "status": status,
        "wall_time_ms": wall_time_ms,
        "metadata_source": METADATA_SOURCE,
        "coverage": COVERAGE,
        "observed_tokens": aggregate_tokens(rows),
        "results": rows,
    }
    if reason_lines:
        payload["reasons"] = reason_lines
    return json.dumps(payload, indent=2, sort_keys=True)


def main() -> int:
    args = parse_args()
    codex_home = resolve_codex_home(args.codex_home)
    if codex_home is None:
        reasons = ["codex home unavailable"]
        output = (
            format_text([], None, "unknown", reasons)
            if args.format == "text"
            else format_json([], None, "unknown", reasons)
        )
        print(output)
        return 0

    thread_id = (
        args.thread_id
        or os.environ.get("CODEX_THREAD_ID")
        or os.environ.get("CODEX_SESSION_ID")
    )
    if not thread_id:
        reasons = ["thread id unavailable"]
        output = (
            format_text([], None, "unknown", reasons)
            if args.format == "text"
            else format_json([], None, "unknown", reasons)
        )
        print(output)
        return 0

    now = parse_utc_timestamp(args.now) if args.now else dt.datetime.now(tz=UTC)
    if now is None:
        reasons = ["invalid --now timestamp"]
        output = (
            format_text([], None, "unknown", reasons)
            if args.format == "text"
            else format_json([], None, "unknown", reasons)
        )
        print(output)
        return 0

    status, wall_time_ms, rows, reasons = snapshot(codex_home, thread_id, now)
    output = (
        format_text(rows, wall_time_ms, status, reasons)
        if args.format == "text"
        else format_json(rows, wall_time_ms, status, reasons)
    )
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
