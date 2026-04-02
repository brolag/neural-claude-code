#!/bin/bash
# Hook: PostToolUse — Detect leaked secrets in output
# Always exits 0 (warns, never blocks)
set -euo pipefail

INPUT=$(cat)
TOOL_OUTPUT=$(echo "$INPUT" | jq -r '.tool_output // .output // ""' 2>/dev/null || echo "")

[[ -z "$TOOL_OUTPUT" ]] && exit 0

WARNINGS=()

if echo "$TOOL_OUTPUT" | grep -qE "sk-ant-[a-zA-Z0-9]{20,}" 2>/dev/null; then
    WARNINGS+=("Anthropic API Key")
fi
if echo "$TOOL_OUTPUT" | grep -qE "sk-[a-zA-Z0-9]{20,}" 2>/dev/null; then
    WARNINGS+=("OpenAI API Key")
fi
if echo "$TOOL_OUTPUT" | grep -qE "AKIA[0-9A-Z]{16}" 2>/dev/null; then
    WARNINGS+=("AWS Access Key")
fi
if echo "$TOOL_OUTPUT" | grep -qE "(ghp|gho|ghu|ghs|ghr)_[a-zA-Z0-9]{36,}" 2>/dev/null; then
    WARNINGS+=("GitHub Token")
fi
if echo "$TOOL_OUTPUT" | grep -qE "(sk|pk)_(live|test)_[0-9a-zA-Z]{24,}" 2>/dev/null; then
    WARNINGS+=("Stripe Key")
fi
if echo "$TOOL_OUTPUT" | grep -qE "xox[baprs]-[0-9a-zA-Z-]{10,}" 2>/dev/null; then
    WARNINGS+=("Slack Token")
fi
if echo "$TOOL_OUTPUT" | grep -qE "glpat-[a-zA-Z0-9_-]{20,}" 2>/dev/null; then
    WARNINGS+=("GitLab Token")
fi
if echo "$TOOL_OUTPUT" | grep -qE "-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----" 2>/dev/null; then
    WARNINGS+=("Private Key")
fi
if echo "$TOOL_OUTPUT" | grep -qE "(postgres|mysql|mongodb)://[^:]+:[^@]+@" 2>/dev/null; then
    WARNINGS+=("Database URL with password")
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    LIST=$(printf ", %s" "${WARNINGS[@]}")
    LIST=${LIST:2}
    echo "{\"systemMessage\": \"SECRET LEAK WARNING: Detected in output: $LIST. Do NOT commit or share.\"}"
fi

exit 0
