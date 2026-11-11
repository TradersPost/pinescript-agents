#!/bin/bash
# PreToolUse hook adapter (Claude Code stdin JSON -> before-write.sh args)
#
# Claude Code pipes a JSON blob on stdin and reads the exit code:
#   0 = allow   2 = block (stderr is fed back to Claude)   other = warn + allow
#
# before-write.sh uses a Unix convention where exit 1 means "block".
# This adapter translates: block(1) -> CC-block(2), everything else -> allow(0).
#
# When there is no stdin (i.e. someone runs this script directly with args,
# like the original hook design), it falls back to positional arguments so
# the underlying before-write.sh stays testable without the CC harness.

INPUT="$(cat 2>/dev/null)"
if [ -n "$INPUT" ]; then
    FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
    FILE_CONTENT=$(printf '%s' "$INPUT" | jq -r '.tool_input.content // empty' 2>/dev/null)
else
    FILE_PATH="$1"
    FILE_CONTENT="$2"
fi

[ -z "$FILE_PATH" ] && exit 0   # nothing to check

HOOKS_DIR="$(cd "$(dirname "$0")/../" && pwd)"
set +e
OUT="$("$HOOKS_DIR/before-write.sh" "$FILE_PATH" "$FILE_CONTENT" 2>&1)"
RC=$?
set -e
[ -n "$OUT" ] && printf '%s\n' "$OUT" >&2   # warnings / tips are always surfaced

if [ $RC -eq 1 ]; then
    exit 2    # block the write (lock enforcement)
fi
exit 0
