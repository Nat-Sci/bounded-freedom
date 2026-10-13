#!/usr/bin/env python3
"""Compact file-deployment receipt; install-global.sh remains the authority."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

REPO = Path(__file__).resolve().parent.parent
BEGIN = b"# >>> BoundedFreedom managed block >>>"
END = b"# <<< BoundedFreedom managed block <<<"
LEGACY = "mathematical-problem-mapping statistical-model-analysis neural-network-mathematical-analysis loss-objective-optimization".split()


class CheckError(Exception):
    pass


def run_installer(target, host, mode):
    # Never forward installer output: even OS errors may contain private paths.
    result = subprocess.run(["sh", str(REPO / "scripts/install-global.sh"),
                             mode, "--host", host, "--codex-proxy", "unchanged",
                             "--target-root", str(target)], capture_output=True)
    if result.returncode or result.stderr:
        raise CheckError("installer_failed")
    return result.stdout.decode("utf-8").splitlines()


def inventory(host):
    skills = sorted(p.name for p in (REPO / ".agents/skills").iterdir() if p.is_dir())
    roles = []
    if host in ("codex", "all"):
        for line in (REPO / "install/codex-role-files.txt").read_text().splitlines():
            name = line.split("#", 1)[0].strip()
            if name:
                if not re.fullmatch(r"[A-Za-z0-9_-]+\.toml", name) or name in roles:
                    raise CheckError("source_contract_failed")
                roles.append(name)
    if not skills or any(not re.fullmatch(r"[A-Za-z0-9_-]+", s) for s in skills):
        raise CheckError("source_contract_failed")
    return skills, roles


def contract(host, skills, roles, version):
    required = {f"BoundedFreedom package: v{version} (Astra Edition)"}
    optional = set()
    apply_lines = {f"BoundedFreedom package: v{version} (Astra Edition)",
                   "installation complete",
                   "role file installation does not verify live role launch or model selection"}
    for prefix in (["portable"] + (["Claude"] if host in ("claude", "all") else [])):
        for name in skills:
            label = f"{prefix} Skill {name}"
            required.add(f"{label}: linked")
            apply_lines.update((f"link: {label}", f"link ok: {label}"))
        for name in LEGACY:
            optional.add(f"legacy {prefix} Skill {name}: preserved user-owned path")
            apply_lines.add(f"remove legacy managed {prefix} Skill {name}")
        apply_lines.add(f"create directory: {prefix} Skills")
    blocks = []
    if host in ("codex", "all"):
        blocks += ["Codex AGENTS.md", "Codex config.toml"]
        for role in roles:
            label = f"Codex agent {role[:-5]}"
            required.add(f"{label}: managed regular file (current)")
            apply_lines.update((f"role file ok: {label}", f"install managed role file: {label}"))
        required.update((f"Codex policy state: managed marker current for v{version}",
                         "Codex role file status is file-level only; it does not verify live role launch or model selection",
                         "Codex policy-state status is deployment evidence only; existing tasks may still be stale"))
        optional.update(("Codex proxy .env: managed block absent", "Codex proxy .env: managed block present"))
        apply_lines.update(("create directory: Codex agents", f"policy state ok: v{version}",
                            f"install managed Codex policy state: v{version}",
                            "POLICY RELOAD REQUIRED: existing/open tasks do not adopt this deployment",
                            "start or fork a new task before claiming current-policy routing or usage",
                            "policy deployment is unchanged; existing tasks retain their original instruction chain",
                            "role file installation does not verify live role launch or model selection"))
    if host in ("claude", "all"):
        blocks.append("Claude CLAUDE.md")
    for label in blocks:
        required.add(f"{label}: managed block present (current)")
        apply_lines.add(f"refresh managed {label} block")
    return required, optional, apply_lines


def verify(lines, required, optional, host):
    # Every required result must occur exactly once; unknown/stale results fail.
    if len(lines) != len(set(lines)) or not required.issubset(lines):
        raise CheckError("deployment_missing_stale_or_conflicting")
    if set(lines) - required - optional:
        raise CheckError("deployment_or_output_contract_failed")
    if host in ("codex", "all") and sum(x.startswith("Codex proxy .env:") for x in lines) != 1:
        raise CheckError("output_contract_failed")


def unmanaged_block(data):
    lines = data.splitlines(keepends=True)
    outside = []
    inside = False
    seen = False
    for line in lines:
        marker = line.rstrip(b"\n")
        if marker == BEGIN:
            if inside or seen:
                raise CheckError("invalid_managed_markers")
            inside = seen = True
        elif marker == END:
            if not inside:
                raise CheckError("invalid_managed_markers")
            inside = False
        elif not inside:
            outside.append(line)
    if inside:
        raise CheckError("invalid_managed_markers")
    return b"".join(outside)


def preserved_content(target, host, skills, roles):
    """Snapshot installer-facing unmanaged files only; never read host histories."""
    result = {}
    blocks = []
    directories = [(".agents/skills", set(skills))]
    if host in ("codex", "all"):
        blocks += [".codex/AGENTS.md", ".codex/config.toml"]
        directories.append((".codex/agents", set(roles)))
    if host in ("claude", "all"):
        blocks.append(".claude/CLAUDE.md")
        directories.append((".claude/skills", set(skills)))

    def record(relative, block=False):
        path = target / relative
        if path.is_symlink():
            value = ("link", os.readlink(path))
        elif path.is_file():
            data = path.read_bytes()
            if block:
                data = unmanaged_block(data)
            # Missing and empty unmanaged portions are equivalent on first install.
            value = ("file", hashlib.sha256(data).hexdigest()) if data or not block else None
        elif path.exists():
            value = ("directory",) if path.is_dir() else ("special",)
        else:
            value = None
        if value is not None:
            result[relative] = value

    for relative in blocks:
        record(relative, block=True)
    if host in ("codex", "all"):
        record(".codex/.env")  # Entire proxy file must stay unchanged.
    for directory, managed in directories:
        path = target / directory
        if not path.is_dir():
            continue
        for child in path.iterdir():
            if child.name in managed:
                continue
            if child.name in LEGACY and child.is_symlink() and os.readlink(child) == str(REPO / ".agents/skills" / child.name):
                continue  # Installer owns removal of its retired links.
            record(f"{directory}/{child.name}")
    return result


class SafeParser(argparse.ArgumentParser):
    def error(self, message):
        raise CheckError("invalid_arguments")


def error_format(arguments):
    # Parse only the format option before validating other arguments. Argparse
    # handles equals syntax, repeats, abbreviations, and the -- separator.
    parser = SafeParser(add_help=False)
    parser.add_argument("--format", default="text")
    try:
        args, _ = parser.parse_known_args(arguments)
    except CheckError:
        return "text"  # A missing format value has no usable format contract.
    return args.format if args.format in ("text", "json") else "text"


def main():
    receipt = {"source_version": "unknown", "source_commit": "unknown",
               "deployment_files": "failed", "unmanaged_preservation": "not_run",
               "live_route": "not_run", "status": "failed"}
    fmt = error_format(sys.argv[1:])
    try:
        parser = SafeParser(description=__doc__)
        parser.add_argument("--apply", action="store_true", help="invoke the existing installer before checking")
        parser.add_argument("--check", action="store_true", help="read-only check (default)")
        parser.add_argument("--target-root", type=Path, default=Path.home())
        parser.add_argument("--host", choices=("codex", "claude", "portable", "all"), default="codex")
        parser.add_argument("--format", choices=("text", "json"), default="text")
        args = parser.parse_args()
        fmt = args.format
        if args.apply and args.check:
            raise CheckError("invalid_arguments")
        version = (REPO / "VERSION").read_text().strip()
        if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
            raise CheckError("source_contract_failed")
        receipt["source_version"] = version
        try:
            git = subprocess.run(["git", "-C", str(REPO), "rev-parse", "--verify", "HEAD"], capture_output=True)
            commit = git.stdout.decode().strip()
            if git.returncode == 0 and re.fullmatch(r"[0-9a-f]{40,64}", commit):
                receipt["source_commit"] = commit
        except OSError:
            pass  # Source archives or hosts without Git retain unknown provenance.
        skills, roles = inventory(args.host)
        required, optional, apply_lines = contract(args.host, skills, roles, version)
        if args.apply:
            before = preserved_content(args.target_root, args.host, skills, roles)
            receipt["unmanaged_preservation"] = "unknown"
            try:
                output = run_installer(args.target_root, args.host, "--update")
            finally:
                after = preserved_content(args.target_root, args.host, skills, roles)
                receipt["unmanaged_preservation"] = "preserved" if before == after else "changed"
            if before != after:
                raise CheckError("unmanaged_content_changed")
            if not output or output[-1] != "role file installation does not verify live role launch or model selection":
                raise CheckError("output_contract_failed")
            if "installation complete" not in output or set(output) - apply_lines:
                raise CheckError("output_contract_failed")
        verify(run_installer(args.target_root, args.host, "--status"), required, optional, args.host)
        receipt.update(status="ok", deployment_files="verified")
    except CheckError as error:
        receipt["error"] = str(error)
    except (OSError, ValueError, UnicodeError):
        receipt["error"] = "local_io_or_contract_failed"
    if fmt == "json":
        print(json.dumps(receipt, sort_keys=True))
    else:
        print("deploy-verify " + " ".join(f"{key}={value}" for key, value in receipt.items()))
    return 0 if receipt["status"] == "ok" else 1


if __name__ == "__main__":
    sys.exit(main())
