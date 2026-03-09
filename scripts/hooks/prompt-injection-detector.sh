#!/bin/bash
# Hook: PreToolUse — Detect prompt injection attempts
# Source: Adapted from FlorianBruniaux/claude-code-ultimate-guide
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

CONTENT_LOWER=$(echo "$CONTENT" | tr '[:upper:]' '[:lower:]')

# Role override patterns
for pattern in "ignore previous instructions" "ignore all previous" "disregard previous" \
    "forget your instructions" "you are now" "pretend you are" "new instructions:" \
    "override:" "system prompt:"; do
    if [[ "$CONTENT_LOWER" == *"$pattern"* ]]; then
        echo "BLOCKED: Prompt injection — role override: '$pattern'" >&2
        exit 2
    fi
done

# Jailbreak patterns
for pattern in "dan mode" "developer mode" "jailbreak" "do anything now" \
    "unrestricted mode" "god mode" "sudo mode"; do
    if [[ "$CONTENT_LOWER" == *"$pattern"* ]]; then
        echo "BLOCKED: Prompt injection — jailbreak: '$pattern'" >&2
        exit 2
    fi
done

# Delimiter injection
for pattern in "</system>" "<|endoftext|>" "<|im_end|>" "[/INST]" "[INST]" \
    "<<SYS>>" "<</SYS>>" "### System:" "### Human:" "### Assistant:"; do
    if [[ "$CONTENT" == *"$pattern"* ]]; then
        echo "BLOCKED: Prompt injection — delimiter: '$pattern'" >&2
        exit 2
    fi
done

# ANSI escape sequences (terminal injection)
if echo "$CONTENT" | grep -qE $'\x1b\[|\x1b\]|\x1b\('; then
    echo "BLOCKED: ANSI escape sequence — terminal injection" >&2
    exit 2
fi

# Null byte injection
if echo "$CONTENT" | grep -qP '\x00' 2>/dev/null; then
    echo "BLOCKED: Null byte — truncation attack" >&2
    exit 2
fi

exit 0
