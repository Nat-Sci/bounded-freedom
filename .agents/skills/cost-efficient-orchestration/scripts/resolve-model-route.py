#!/usr/bin/env python3
"""Plan one Codex route from exact pairs advertised by the intended launch surface."""

import argparse
import json
import sys
from pathlib import Path


POLICY = Path(__file__).resolve().parent.parent / "model-routing.json"
EFFORTS = ("none", "minimal", "low", "medium", "high", "xhigh", "max", "ultra")


def exact_pair(value):
    model, _, effort = value.partition("/")
    if not model or effort not in EFFORTS:
        raise argparse.ArgumentTypeError("expected MODEL/EFFORT")
    return model, effort


def cli_catalog_pairs(document):
    if not isinstance(document, dict) or not isinstance(document.get("models"), list):
        raise ValueError("expected a models array")
    pairs = set()
    for model in document["models"]:
        if not isinstance(model, dict) or model.get("visibility") != "list":
            continue
        slug = model.get("slug")
        levels = model.get("supported_reasoning_levels")
        if not isinstance(slug, str) or not slug or not isinstance(levels, list):
            continue
        for level in levels:
            if isinstance(level, dict) and level.get("effort") in EFFORTS:
                pairs.add((slug, level["effort"]))
    return pairs


def main():
    try:
        policy = json.loads(POLICY.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        raise SystemExit("could not read model-routing policy") from None
    if policy["schema_version"] != 1:
        raise SystemExit("unsupported model-routing policy version")

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("task", choices=policy["tasks"])
    parser.add_argument("--subtype", default="default")
    parser.add_argument("--surface", required=True, choices=("app-worker", "cli"))
    catalog = parser.add_mutually_exclusive_group()
    catalog.add_argument("--cli-catalog", metavar="FILE",
                         help="read an existing CLI catalog snapshot (use - for stdin)")
    catalog.add_argument("--available", nargs="*", type=exact_pair, metavar="MODEL/EFFORT",
                         help="exact pairs advertised and bindable on this surface")
    parser.add_argument("--exclude", nargs="*", type=exact_pair, default=[], metavar="MODEL/EFFORT",
                        help="pairs with an explicit applicable block")
    parser.add_argument("--model", help="restrict selection to this exact model")
    parser.add_argument("--effort", choices=EFFORTS, help="restrict selection to this exact effort")
    parser.add_argument("--depth-approved", action="store_true",
                        help="attest Chief approved the explicitly raised effort")
    parser.add_argument("--frontier-approved", action="store_true",
                        help="attest Chief accepted evidence under the frontier decision gate")
    parser.add_argument("--review-shortfall", action="store_true",
                        help="attest documented independent Sol/high shortfall for frontier review")
    args = parser.parse_args()
    if args.cli_catalog is not None and args.surface != "cli":
        parser.error("--cli-catalog requires --surface cli")

    task = policy["tasks"][args.task]
    if args.subtype not in task or args.subtype == "role":
        parser.error("unknown subtype for this task")

    lane, effort = task[args.subtype]
    if args.frontier_approved:
        lane = policy["frontier"]["lane"]
        effort = policy["frontier"]["effort"]
    result = {
        "plan": True, "policy_version": policy["schema_version"], "surface": args.surface,
        "role": task["role"], "task": args.task, "subtype": args.subtype, "lane": lane,
        "model": None, "effort": args.effort or effort, "fallback": None,
        "evidence": "missing",
    }
    if args.available is not None:
        result["evidence"] = "supplied_exact_pairs"
    if args.cli_catalog is not None:
        result["evidence"] = "supplied_cli_catalog"

    def finish(status, reason):
        print(json.dumps(dict(result, status=status, reason=reason)))
        return 0 if status == "selected" else 1

    if args.frontier_approved and task["role"] == "Reviewer" and not args.review_shortfall:
        return finish("unavailable", "independent_review_shortfall_required")
    if args.effort is not None and args.effort != effort:
        if not args.depth_approved or EFFORTS.index(args.effort) < EFFORTS.index(effort):
            return finish("unavailable", "requested_effort_outside_approved_route")
        effort = args.effort
        lane = policy["depth_lanes"].get(lane, lane)
        result["lane"] = lane

    models = policy["lanes"][lane]
    if args.model is not None and args.model not in models:
        return finish("unavailable", "requested_model_outside_approved_route")
    if args.cli_catalog is not None:
        try:
            if args.cli_catalog == "-":
                advertised = cli_catalog_pairs(json.load(sys.stdin))
            else:
                with Path(args.cli_catalog).open(encoding="utf-8") as source:
                    advertised = cli_catalog_pairs(json.load(source))
        except OSError:
            return finish("unavailable", "cli_catalog_unreadable")
        except (ValueError, RecursionError):
            return finish("unavailable", "invalid_cli_catalog")
    elif args.available is not None:
        advertised = set(args.available)
    else:
        return finish("unknown", "missing_launch_evidence")

    if not advertised:
        return finish("unavailable", "empty_launch_catalog")
    excluded = set(args.exclude)
    if args.model is not None:
        pair = (args.model, effort)
        if pair not in advertised:
            return finish("unavailable", "requested_pair_not_advertised")
        if pair in excluded:
            return finish("unavailable", "requested_pair_excluded")
        result["model"] = args.model
        return finish("selected", "explicit_model")

    rejected = []
    for model in models:
        pair = (model, effort)
        if pair not in advertised:
            rejected.append("pair_not_advertised")
            continue
        if pair in excluded:
            rejected.append("pair_excluded")
            continue
        result["model"] = model
        if rejected:
            result["fallback"] = {"preferred_model": models[0], "reasons": rejected}
        return finish("selected", "eligible_pair")
    return finish("unavailable", "no_eligible_pair" if "pair_excluded" in rejected else "no_advertised_pair")


if __name__ == "__main__":
    raise SystemExit(main())
