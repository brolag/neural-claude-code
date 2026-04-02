#!/bin/bash
# Hook: PreToolUse — Block access to sensitive files
# Exit 0 = allow, Exit 2 = block
set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty')

case "$TOOL_NAME" in
    Read|Edit|Write|Grep|Glob) ;;
    *) exit 0 ;;
esac

FILE_PATH=""
case "$TOOL_NAME" in
    Read|Edit|Write) FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty') ;;
    Grep) FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // empty') ;;
    Glob) FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // empty') ;;
esac

[[ -z "$FILE_PATH" ]] && exit 0

FILENAME=$(basename "$FILE_PATH" 2>/dev/null || echo "")

SENSITIVE_FILES=".env .env.local .env.production .env.staging credentials.json serviceAccountKey.json id_rsa id_ed25519 id_dsa .npmrc .pypirc"

for sensitive in $SENSITIVE_FILES; do
    if [[ "$FILENAME" == "$sensitive" ]]; then
        echo "BLOCKED: Access to sensitive file '$FILENAME'" >&2
        exit 2
    fi
done

# Block patterns
if echo "$FILENAME" | grep -qE "^\.env\." 2>/dev/null; then
    echo "BLOCKED: Access to env file '$FILENAME'" >&2
    exit 2
fi

exit 0
