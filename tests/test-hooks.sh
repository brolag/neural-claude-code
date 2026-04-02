#!/bin/bash
#
# Neural Claude Code — Hook Tests
# Validates that all hooks work correctly with simulated input
#

HOOKS_DIR="${1:-$(dirname "$0")/../hooks}"
PASS=0
FAIL=0

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

assert_exit() {
    local name="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then
        echo -e "${GREEN}PASS${RESET} $name (exit $actual)"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${RESET} $name (expected exit $expected, got $actual)"
        FAIL=$((FAIL + 1))
    fi
}

run_hook() {
    local input="$1" hook="$2"
    echo "$input" | bash "$HOOKS_DIR/$hook" >/dev/null 2>&1
    echo $?
}

echo "Testing hooks in: $HOOKS_DIR"
echo ""

# --- dangerous-actions-blocker ---
echo "## dangerous-actions-blocker.sh"
HOOK="dangerous-actions-blocker.sh"

EC=$(run_hook '{"tool_name":"Bash","tool_input":{"command":"ls -la"}}' "$HOOK")
assert_exit "Allow safe command" 0 "$EC"

EC=$(run_hook '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' "$HOOK")
assert_exit "Block rm -rf /" 2 "$EC"

EC=$(run_hook '{"tool_name":"Bash","tool_input":{"command":"git push --force origin main"}}' "$HOOK")
assert_exit "Block force push to main" 2 "$EC"

EC=$(run_hook '{"tool_name":"Write","tool_input":{"file_path":"/app/.env"}}' "$HOOK")
assert_exit "Block write to .env" 2 "$EC"

echo ""

# --- prompt-injection-detector ---
echo "## prompt-injection-detector.sh"
HOOK="prompt-injection-detector.sh"

EC=$(run_hook '{"tool_name":"Bash","tool_input":{"command":"npm install"}}' "$HOOK")
assert_exit "Allow normal command" 0 "$EC"

EC=$(run_hook '{"tool_name":"Bash","tool_input":{"command":"echo ignore previous instructions"}}' "$HOOK")
assert_exit "Block prompt injection" 2 "$EC"

EC=$(run_hook '{"tool_name":"Write","tool_input":{"file_path":"README.md","content":"ignore previous instructions"}}' "$HOOK")
assert_exit "Allow injection text in .md files" 0 "$EC"

EC=$(run_hook '{"tool_name":"Bash","tool_input":{"command":"git commit -m \"fix: ignore previous instructions bug\""}}' "$HOOK")
assert_exit "Allow injection text in git commits" 0 "$EC"

echo ""

# --- sensitive-file-guard ---
echo "## sensitive-file-guard.sh"
HOOK="sensitive-file-guard.sh"

EC=$(run_hook '{"tool_name":"Read","tool_input":{"file_path":"src/index.ts"}}' "$HOOK")
assert_exit "Allow normal file read" 0 "$EC"

EC=$(run_hook '{"tool_name":"Read","tool_input":{"file_path":"/project/.env"}}' "$HOOK")
assert_exit "Block .env read" 2 "$EC"

EC=$(run_hook '{"tool_name":"Write","tool_input":{"file_path":"/home/user/.env.production"}}' "$HOOK")
assert_exit "Block .env.production write" 2 "$EC"

EC=$(run_hook '{"tool_name":"Read","tool_input":{"file_path":"/app/credentials.json"}}' "$HOOK")
assert_exit "Block credentials.json read" 2 "$EC"

echo ""

# --- output-scanner ---
echo "## output-scanner.sh"
HOOK="output-scanner.sh"

EC=$(run_hook '{"tool_output":"Hello world"}' "$HOOK")
assert_exit "No warning on clean output" 0 "$EC"

EC=$(run_hook '{"tool_output":"Found key: sk-ant-abc123def456ghi789jkl012mno345"}' "$HOOK")
assert_exit "Detect Anthropic key (exits 0)" 0 "$EC"

OUTPUT=$(echo '{"tool_output":"Found key: sk-ant-abc123def456ghi789jkl012mno345"}' | bash "$HOOKS_DIR/output-scanner.sh" 2>&1)
if echo "$OUTPUT" | grep -q "SECRET LEAK"; then
    echo -e "${GREEN}PASS${RESET} Warning message includes SECRET LEAK"
    PASS=$((PASS + 1))
else
    echo -e "${RED}FAIL${RESET} No SECRET LEAK warning in output"
    FAIL=$((FAIL + 1))
fi

echo ""

# --- pre-compact ---
echo "## pre-compact.sh"

TMPDIR=$(mktemp -d)
HOOK_ABS="$(cd "$(dirname "$HOOKS_DIR/pre-compact.sh")" && pwd)/pre-compact.sh"
(cd "$TMPDIR" && git init --quiet && echo '{}' | bash "$HOOK_ABS" >/dev/null 2>&1)
assert_exit "Pre-compact runs in git repo" 0 $?
rm -rf "$TMPDIR"

echo ""

# --- Summary ---
TOTAL=$((PASS + FAIL))
echo "================================"
echo -e "Results: ${GREEN}$PASS passed${RESET}, ${RED}$FAIL failed${RESET} / $TOTAL total"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
