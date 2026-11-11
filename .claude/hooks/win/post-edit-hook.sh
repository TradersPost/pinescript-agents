#!/bin/bash
# PostToolUse hook adapter (Claude Code stdin JSON -> after-edit.sh args)
#
# after-edit.sh is strictly advisory (repainting / NA / risk / input-group
# tips for .pine files). PostToolUse cannot block the tool call — exit codes
# other than 0 are ignored, stderr just shows up in the transcript. So we
# simply forward the path and always exit 0.

INPUT="$(cat 2>/dev/null)"
if [ -n "$INPUT" ]; then
    FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
else
    FILE_PATH="$1"
fi

[ -z "$FILE_PATH" ] && exit 0

HOOKS_DIR="$(cd "$(dirname "$0")/../" && pwd)"
"$HOOKS_DIR/after-edit.sh" "$FILE_PATH" 2>&1 || true
exit 0
