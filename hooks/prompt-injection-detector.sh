#!/bin/bash
# Hook: PreToolUse — Detect prompt injection attempts
# Exit 0 = allow, Exit 2 = block
set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty')

case "$TOOL_NAME" in
    Bash|Write|Edit|WebFetch) ;;
    *) exit 0 ;;
esac

CONTENT=""
case "$TOOL_NAME" in
    Bash) CONTENT=$(echo "$TOOL_INPUT" | jq -r '.command // empty') ;;
    Write|Edit) CONTENT=$(echo "$TOOL_INPUT" | jq -r '.content // .new_string // empty') ;;
    WebFetch) CONTENT=$(echo "$TOOL_INPUT" | jq -r '.url // empty') ;;
esac

[[ -z "$CONTENT" ]] && exit 0

# Skip legitimate contexts
if [[ "$TOOL_NAME" == "Bash" ]]; then
    echo "$CONTENT" | grep -qE "^git (commit|tag|log)" && exit 0
fi
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
    case "$FILE_PATH" in
        *.md|*.yaml|*.yml|*.txt) exit 0 ;;
    esac
fi

CONTENT_LOWER=$(echo "$CONTENT" | tr '[:upper:]' '[:lower:]')

# Role override patterns
for pattern in "ignore previous instructions" "ignore all previous" "disregard previous" \
    "forget your instructions" "you are now" "pretend you are" "new instructions:" \
    "override:" "system prompt:"; do
    if [[ "$CONTENT_LOWER" == *"$pattern"* ]]; then
        echo "BLOCKED: Prompt injection detected: '$pattern'" >&2
        exit 2
    fi
done

# Jailbreak patterns
for pattern in "do anything now" "developer mode" "jailbreak" "ignore safety" \
    "bypass restrictions" "act as an unrestricted"; do
    if [[ "$CONTENT_LOWER" == *"$pattern"* ]]; then
        echo "BLOCKED: Jailbreak attempt detected: '$pattern'" >&2
        exit 2
    fi
done

exit 0
