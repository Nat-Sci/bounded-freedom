#!/bin/sh
# Human-invoked fresh Sol/max entry. The handoff is passed only on stdin.
set -eu

usage() {
  printf '%s\n' 'Usage: sh start-sol-chief.sh [--handoff FILE | --ephemeral-read-only --handoff FILE]' \
    'Brief: regular, nonblank file, at most 16384 bytes. No arguments starts interactive Codex.'
}

if [ "$#" -eq 1 ] && [ "$1" = "--help" ]; then
  usage
  exit 0
fi
if [ "$#" -eq 0 ]; then
  exec codex --model gpt-6.1-sol -c 'model_reasoning_effort="max"'
fi

mode=normal
if [ "$1" = "--ephemeral-read-only" ]; then
  mode=ephemeral
  shift
fi
if [ "$#" -ne 2 ] || [ "$1" != "--handoff" ]; then
  usage >&2
  exit 2
fi
brief=$2
if [ ! -f "$brief" ] || [ ! -r "$brief" ]; then
  printf '%s\n' 'Handoff must be a readable regular file.' >&2
  exit 2
fi
size=$(wc -c < "$brief")
if [ "$size" -gt 16384 ] || ! LC_ALL=C grep -q '[^[:space:]]' < "$brief"; then
  printf '%s\n' 'Handoff must be nonblank and at most 16384 bytes.' >&2
  exit 2
fi
if [ "$mode" = ephemeral ]; then
  exec codex exec --model gpt-6.1-sol -c 'model_reasoning_effort="max"' --ephemeral --sandbox read-only --json - < "$brief"
fi
exec codex exec --model gpt-6.1-sol -c 'model_reasoning_effort="max"' - < "$brief"
