#!/usr/bin/env python3
"""Verify the reviewed Git index; explicitly commit, push, or deploy that tree."""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import pwd
import re
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent
CHECKS = {
    "installer": ["sh", "scripts/test-install-global.sh"],
    "routing": [sys.executable, "scripts/test-model-routing.py"],
    "deployment": [sys.executable, "scripts/test-deploy-verify.py"],
    "launch": [sys.executable, "scripts/test-start-sol-chief.py"],
    "resources": [sys.executable, "scripts/test-codex-task-resource-snapshot.py"],
    "release": [sys.executable, "scripts/test-release.py"],
}
DEPLOY_INPUTS = ("VERSION", "install/global-agents.md", "install/agents-config.toml",
                 "install/codex-role-files.txt", ".agents/skills", ".codex/agents",
                 "scripts/deploy-verify.py", "scripts/install-global.sh")
GIT_REDIRECTIONS = {"GIT_DIR", "GIT_WORK_TREE", "GIT_COMMON_DIR", "GIT_INDEX_FILE",
                    "GIT_OBJECT_DIRECTORY", "GIT_ALTERNATE_OBJECT_DIRECTORIES",
                    "GIT_NAMESPACE", "GIT_SHALLOW_FILE", "GIT_GRAFT_FILE",
                    "GIT_REPLACE_REF_BASE"}


class Stop(Exception):
    def __init__(self, reason, status="DECISION"):
        self.reason, self.status = reason, status


def run(argv, cwd=ROOT):
    return subprocess.run(argv, cwd=cwd, capture_output=True)


def git(*args, cwd=ROOT):
    result = run(["git", *args], cwd)
    if result.returncode:
        raise Stop("git_operation_failed")
    return result.stdout.decode().strip()


def digest(value):
    return hashlib.sha256(value).hexdigest()


def load(path):
    try:
        value = json.loads(path.read_text())
        return value if isinstance(value, dict) else {}
    except (OSError, ValueError):
        return {}


def save(path, value):
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(value, sort_keys=True))
    temporary.replace(path)


HOME_PATTERNS = tuple(
    re.compile(re.escape(os.fsencode(home.rstrip("/"))) + rb"(?=$|[/\\\s\x22\x27),:;])")
    for home in {str(Path.home()), pwd.getpwuid(os.getuid()).pw_dir} if home and home != "/"
)
ACCOUNT_HOME = re.compile(
    rb"(?<![\w./\\:-])(?:file://(?:/(?=[a-z]:))?)?(?:[a-z]:)?[/\\]+"
    rb"(?:Users|home)[/\\]+([a-z0-9_.@-]+)", re.I
)
EXAMPLE_ACCOUNTS = {b"user", b"username", b"account", b"example", b"your-user", b"your-username"}


def private_home(value):
    return (any(pattern.search(value) for pattern in HOME_PATTERNS) or
            any(match[1].lower() not in EXAMPLE_ACCOUNTS for match in ACCOUNT_HOME.finditer(value)))


def candidate_preflight(base, tree, receipt, scope="candidate", *, check_whitespace=True):
    """Read frozen object IDs and NUL-delimited paths, never the working files."""
    evidence = {"privacy": "skipped", "whitespace": "skipped"}
    receipt["preflight"][scope] = evidence

    def checked(*args):
        result = run(["git", *args])
        if result.returncode:
            raise Stop(scope + "_preflight_unavailable", "REPAIR")
        return result.stdout

    records = checked("diff", "--raw", "-z", "--no-abbrev", "--no-renames",
                      "--no-ext-diff", "--no-textconv", base, tree, "--").split(b"\0")
    for index in range(0, len(records) - 1, 2):
        fields = records[index].split()
        path = records[index + 1]
        if len(fields) != 5:
            raise Stop(scope + "_preflight_unavailable", "REPAIR")
        if fields[4] == b"D":
            continue
        if private_home(b"/" + path):
            evidence["privacy"] = "failed"
            raise Stop(scope + "_private_home_path", "REPAIR")
        old, new = fields[2].decode("ascii"), fields[3].decode("ascii")
        if fields[0] == b":000000":
            content = checked("cat-file", "blob", new)
            additions = [] if b"\0" in content else content.splitlines()
        else:
            patch = checked("diff", "--no-ext-diff", "--no-textconv", "--no-color",
                            "--unified=0", old, new, "--")
            additions, in_hunk = [], False
            for line in patch.split(b"\n"):
                if line.startswith(b"@@ "):
                    in_hunk = True
                elif in_hunk and line.startswith(b"+"):
                    additions.append(line[1:])
        if any(private_home(line) for line in additions):
            evidence["privacy"] = "failed"
            raise Stop(scope + "_private_home_text", "REPAIR")
    evidence["privacy"] = "passed"
    if not check_whitespace:
        return
    whitespace = run(["git", "diff", "--check", "--no-ext-diff", "--no-textconv", base, tree, "--"])
    if whitespace.returncode:
        evidence["whitespace"] = "failed"
        reason = "_whitespace_error" if whitespace.returncode in (1, 2) else "_preflight_unavailable"
        raise Stop(scope + reason, "REPAIR")
    evidence["whitespace"] = "passed"


def outgoing_preflight(base, head, receipt):
    """Check outgoing history even when the destination has no baseline ref."""
    if base is None:
        raise Stop("outgoing_remote_unknown")
    if base != "absent" and run(["git", "cat-file", "-e", base + "^{commit}"]).returncode:
        receipt["push"] = "failed"
        raise Stop("outgoing_base_unavailable")
    args = ["git", "rev-list", "--reverse", "--parents", head]
    if base != "absent":
        args.extend(["--not", base])
    result = run(args)
    if result.returncode:
        raise Stop("outgoing_range_unavailable")
    for line in result.stdout.decode().splitlines():
        commit, *parents = line.split()
        if not parents:
            # Git's empty tree is object-format aware; no object/index mutation.
            empty = subprocess.run(["git", "hash-object", "-t", "tree", "--stdin"], cwd=ROOT,
                                   input=b"", capture_output=True).stdout.decode().strip()
            parents = [empty]
        for parent in parents:
            candidate_preflight(parent, commit, receipt, "outgoing", check_whitespace=base != "absent")


def deployment_inputs(root):
    """Compare actual installer inputs, including untracked/ignored additions.

    Bytecode is runtime output, not an installed policy input. Do not follow links
    while enumerating; Git records their targets rather than their referents.
    """
    result = {}

    def record(path):
        if path.name == "__pycache__" or path.suffix in (".pyc", ".pyo"):
            return
        name = path.relative_to(root).as_posix()
        if path.is_symlink():
            result[name] = ("link", os.readlink(path))
        elif path.is_file():
            result[name] = ("file", digest(path.read_bytes()), bool(path.stat().st_mode & 0o111))
        elif path.is_dir():
            result[name] = ("directory",)
            for child in path.iterdir():
                record(child)
        else:
            result[name] = ("missing_or_special",)

    for name in DEPLOY_INPUTS:
        record(root / name)
    return result


def policy_fingerprint(root):
    script = root / ".agents/skills/cost-efficient-orchestration/scripts/policy-fingerprint.sh"
    result = run(["sh", "-c", '. "$1" && compute_policy_fingerprint "$2"',
                  "fingerprint", str(script), str(root)], root)
    value = result.stdout.decode().strip()
    if result.returncode or result.stderr or not re.fullmatch(r"[0-9]+-[0-9]+", value):
        raise Stop("policy_fingerprint_unavailable", "REPAIR")
    return value


def deployment_result(args, fingerprint, mode):
    outcome = run([sys.executable, "scripts/deploy-verify.py", mode, "--format", "json",
                   "--expect-policy-fingerprint", fingerprint,
                   "--target-root", str(args.deploy_target.expanduser().resolve()), "--host", args.host])
    try:
        receipt = json.loads(outcome.stdout)
    except ValueError:
        return False
    return outcome.returncode == 0 and isinstance(receipt, dict) and receipt.get("status") == "ok"


def baseline():
    for name in ("MERGE_HEAD", "CHERRY_PICK_HEAD", "REVERT_HEAD", "rebase-merge",
                 "rebase-apply", "sequencer", "BISECT_LOG", "index.lock"):
        if (ROOT / git("rev-parse", "--git-path", name)).exists():
            raise Stop("git_operation_in_progress")
    if git("ls-files", "-u"):
        raise Stop("unmerged_index")
    # Intent-to-add and skip-worktree/assume-unchanged hide artifact boundaries.
    if any(line[:1] != "H" for line in git("ls-files", "-v").splitlines()):
        raise Stop("unsupported_index_flags")
    if run(["git", "diff", "--raw", "--ita-visible-in-index", "--cached"]).stdout != run(
            ["git", "diff", "--raw", "--ita-invisible-in-index", "--cached"]).stdout:
        raise Stop("intent_to_add")
    tree = git("write-tree")
    if "160000 " in git("ls-tree", "-r", tree):
        raise Stop("submodules_unsupported")
    return git("symbolic-ref", "-q", "HEAD"), git("rev-parse", "HEAD"), tree


def hook_context():
    hooks = Path(git("rev-parse", "--path-format=absolute", "--git-path", "hooks"))
    h = hashlib.sha256(run(["git", "config", "--null", "--list"]).stdout)
    if hooks.exists():
        for p in sorted(hooks.rglob("*")):
            h.update(str(p.relative_to(hooks)).encode())
            if p.is_file():
                h.update(p.read_bytes())
                h.update(str(p.stat().st_mode).encode())
    return h.hexdigest()


def push_target(branch):
    short = branch.removeprefix("refs/heads/")
    remote = git("config", "--get", f"branch.{short}.remote")
    ref = git("config", "--get", f"branch.{short}.merge")
    if remote == "." or not ref.startswith("refs/heads/"):
        raise Stop("incompatible_upstream")
    urls = git("remote", "get-url", "--push", "--all", remote).splitlines()
    # Git's single configured push URL is authoritative, including URL rewrites.
    if len(urls) != 1 or urls[0].startswith("-"):
        raise Stop("ambiguous_push_target")
    for key in ("pushRemote",):
        override = run(["git", "config", "--get", f"branch.{short}.{key}"]).stdout.decode().strip()
        if override and override != remote:
            raise Stop("ambiguous_push_target")
    override = run(["git", "config", "--get", "remote.pushDefault"]).stdout.decode().strip()
    if override and override != remote:
        raise Stop("ambiguous_push_target")
    return urls[0], ref


def remote_sha(url, ref):
    result = run(["git", "ls-remote", "--refs", url, ref])
    if result.returncode:
        return None
    rows = result.stdout.decode().splitlines()
    if not rows:
        return "absent"
    if len(rows) == 1 and rows[0].split()[1] == ref:
        return rows[0].split()[0]
    return None


class Parser(argparse.ArgumentParser):
    def error(self, message):
        raise Stop("invalid_arguments")


def main():
    started = time.monotonic()
    receipt = {"status": "DECISION", "tree": "unknown", "commit": "unknown",
               "checks": {}, "preflight": {}, "commit_action": "unrequested", "push": "unrequested",
               "remote_match": "not_observed", "deployment": "unrequested", "live_route": "not_run"}
    try:
        parser = Parser(description=__doc__)
        parser.add_argument("--check", action="append", choices=CHECKS)
        parser.add_argument("--fresh", action="store_true")
        parser.add_argument("--expect-tree")
        parser.add_argument("--commit", action="store_true")
        parser.add_argument("--message")
        parser.add_argument("--push", action="store_true")
        parser.add_argument("--deploy-target", type=Path)
        parser.add_argument("--host", choices=("codex", "claude", "portable", "all"), default="codex")
        args = parser.parse_args()
        receipt["selected_checks"] = list(dict.fromkeys(args.check or CHECKS))
        receipt["checks"] = {name: {"result": "skipped", "elapsed_seconds": 0}
                             for name in receipt["selected_checks"]}
        receipt.update(commit_action="skipped" if args.commit else "unrequested",
                       push="skipped" if args.push else "unrequested",
                       deployment="skipped" if args.deploy_target else "unrequested")
        if args.commit != bool(args.message and args.message.strip()):
            raise Stop("commit_requires_message")
        # Keep normal identity/transport/noninteractive controls. Reject only
        # repository, index, object and ref redirections that defeat tree binding.
        if GIT_REDIRECTIONS.intersection(os.environ):
            raise Stop("git_environment_override")
        if Path(git("rev-parse", "--show-toplevel")).resolve() != ROOT:
            raise Stop("repository_binding_changed")
        state = Path(git("rev-parse", "--path-format=absolute", "--git-path", "release-state"))
        state.mkdir(exist_ok=True)
        with (state / "lock").open("w") as lock:
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                raise Stop("release_already_running")
            branch, head, tree = baseline()
            receipt.update(tree=tree, base_commit=head,
                           commit=head if git("rev-parse", "HEAD^{tree}") == tree else "uncommitted")
            if args.expect_tree is not None:
                if not re.fullmatch(r"[0-9a-f]{" + str(len(tree)) + r"}", args.expect_tree):
                    raise Stop("invalid_expected_tree")
                if args.expect_tree != tree:
                    raise Stop("stale_expected_tree")
            candidate_preflight(head, tree, receipt)
            hooks = hook_context()
            target = push_target(branch) if args.push else None

            def guard(expected=head):
                if baseline() != (branch, expected, tree) or hook_context() != hooks:
                    raise Stop("release_scope_changed")

            context = digest(json.dumps({
                "python": sys.version, "executable": sys.executable,
                "git": git("--version"), "platform": sys.platform,
                "environment": {k: v for k, v in os.environ.items()
                                if k not in ("_", "PWD", "OLDPWD", "SHLVL")},
                "runner": digest(Path(__file__).read_bytes()), "hooks": hooks,
            }, sort_keys=True).encode())
            evidence_path = state / "evidence.json"
            evidence = load(evidence_path)
            with tempfile.TemporaryDirectory(prefix="release-") as directory:
                frozen = Path(directory) / "source"
                if run(["git", "clone", "--shared", "--no-checkout", "--quiet", str(ROOT), str(frozen)]).returncode:
                    raise Stop("snapshot_failed", "REPAIR")
                git("read-tree", tree, cwd=frozen)
                git("checkout-index", "-a", "-u", cwd=frozen)
                if (frozen / "scripts/release.py").read_bytes() != Path(__file__).read_bytes():
                    raise Stop("release_entry_not_staged")
                if args.deploy_target:
                    verified_inputs = deployment_inputs(frozen)
                for name in dict.fromkeys(args.check or CHECKS):
                    command = CHECKS[name]
                    key = digest(json.dumps([tree, name, command, context]).encode())
                    previous = evidence.get(name)
                    check_started = time.monotonic()
                    if not args.fresh and isinstance(previous, dict) and previous.get("key") == key and previous.get("passed") is True:
                        result = "reused"
                    else:
                        outcome = run(command, frozen)
                        result = "executed" if outcome.returncode == 0 else "failed"
                        evidence[name] = {"key": key, "passed": False}
                        save(evidence_path, evidence)
                    receipt["checks"][name] = {"result": result, "elapsed_seconds": round(time.monotonic() - check_started, 3)}
                    guard()
                    if (git("write-tree", cwd=frozen) != tree or
                            run(["git", "diff-files", "--quiet"], frozen).returncode or
                            (args.deploy_target and deployment_inputs(frozen) != verified_inputs)):
                        raise Stop("check_modified_snapshot", "REPAIR")
                    if result == "failed":
                        raise Stop("validation_failed", "REPAIR")
                    evidence[name] = {"key": key, "passed": True}
                    save(evidence_path, evidence)
                guard()
                if args.deploy_target:
                    fingerprint = policy_fingerprint(frozen)

                    def deployment_guard():
                        if deployment_inputs(ROOT) != verified_inputs:
                            raise Stop("deployment_inputs_changed", "REPAIR")
                        if policy_fingerprint(ROOT) != fingerprint:
                            raise Stop("policy_fingerprint_mismatch", "REPAIR")

                    deployment_guard()
                if git("rev-parse", "HEAD^{tree}") != tree:
                    if (args.push or args.deploy_target) and not args.commit:
                        raise Stop("uncommitted_candidate")
                    if args.commit:
                        receipt["commit_action"] = "unknown"
                        outcome = run(["git", "commit", "-m", args.message])
                        actual = git("rev-parse", "HEAD")
                        receipt["commit"] = actual
                        if outcome.returncode:
                            receipt["commit_action"] = "failed"
                            raise Stop("commit_failed", "REPAIR")
                        if git("rev-parse", "HEAD^1") != head or git("rev-parse", "HEAD^{tree}") != tree:
                            raise Stop("commit_postcondition_changed")
                        head = actual
                        receipt["commit_action"] = "completed"
                elif args.commit:
                    receipt["commit_action"] = "already_completed"
                guard(head)
                receipt["commit"] = head if git("rev-parse", "HEAD^{tree}") == tree else "uncommitted"
                if target:
                    url, ref = target
                    observed = remote_sha(url, ref)
                    if observed == head:
                        receipt.update(push="already_completed", remote_match="matched")
                    else:
                        receipt["remote_match"] = "unknown" if observed is None else "different"
                        outgoing_preflight(observed, head, receipt)
                        guard(head)
                        receipt["push"] = "unknown"
                        outcome = run(["git", "push", "--no-force", "--no-mirror", "--no-follow-tags",
                                       "--recurse-submodules=no", "--", url, f"{head}:{ref}"])
                        # Exactly one inspection after any attempted push; no retry.
                        observed = remote_sha(url, ref)
                        receipt["remote_match"] = "matched" if observed == head else "unknown" if observed is None else "different"
                        receipt["push"] = "completed" if observed == head else "unknown" if observed is None else "failed"
                        if observed != head:
                            raise Stop("push_failed_or_ambiguous")
                guard(head)
                if args.deploy_target:
                    deployment_guard()
                    receipt["deployment"] = "unknown"
                    if deployment_result(args, fingerprint, "--check"):
                        receipt["deployment"] = "already_completed"
                    else:
                        guard(head)
                        deployment_guard()
                        receipt["deployment"] = "completed" if deployment_result(args, fingerprint, "--apply") else "failed"
                    if receipt["deployment"] == "failed":
                        raise Stop("deployment_failed", "REPAIR")
                    guard(head)
                    deployment_guard()
            receipt["status"] = "READY"
    except Stop as error:
        receipt.update(status=error.status, reason=error.reason)
    except (OSError, ValueError, UnicodeError):
        receipt.update(status="REPAIR", reason="local_io_or_contract_failed")
    receipt["elapsed_seconds"] = round(time.monotonic() - started, 3)
    print(json.dumps(receipt, sort_keys=True))
    return 0 if receipt["status"] == "READY" else 1


if __name__ == "__main__":
    sys.exit(main())
