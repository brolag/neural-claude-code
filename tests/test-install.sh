#!/bin/bash
#
# Neural Claude Code — Installation Integration Test
# Creates a temp project, runs installer, validates everything works
#
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

assert() {
    local name="$1" result="$2"
    if [[ "$result" == "true" ]]; then
        echo -e "${GREEN}PASS${RESET} $name"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${RESET} $name"
        FAIL=$((FAIL + 1))
    fi
}

# --- Setup ---
TMPDIR=$(mktemp -d)
TEST_CLAUDE="$TMPDIR/.claude-test"
export CLAUDE_DIR_OVERRIDE="$TEST_CLAUDE"

echo -e "${BOLD}Neural Claude Code — Integration Test${RESET}"
echo "Temp dir: $TMPDIR"
echo "Source:   $SCRIPT_DIR"
echo ""

# Create a fake project
cd "$TMPDIR"
git init --quiet
echo '{"name":"test-app","scripts":{"test":"jest","lint":"eslint ."}}' > package.json
mkdir -p src
echo 'export const hello = () => "world"' > src/index.ts
git add -A && git commit -m "init" --quiet

# --- Test 1: Simulate Installation ---
echo -e "${BOLD}## Installation${RESET}"

HOOKS_DIR="$TEST_CLAUDE/hooks/neural"
SKILLS_DIR="$TEST_CLAUDE/skills"
RULES_DIR="$TEST_CLAUDE/rules/neural"

mkdir -p "$HOOKS_DIR" "$SKILLS_DIR" "$RULES_DIR"

# Copy hooks
cp "$SCRIPT_DIR/hooks/"*.sh "$HOOKS_DIR/"
chmod +x "$HOOKS_DIR/"*.sh
assert "Hooks copied" "$([ -f "$HOOKS_DIR/dangerous-actions-blocker.sh" ] && echo true || echo false)"

# Copy skills
for skill in forge init git-save overseer slop-scan; do
    mkdir -p "$SKILLS_DIR/$skill"
    cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md" 2>/dev/null
done
assert "Skills copied (5)" "$([ -f "$SKILLS_DIR/forge/SKILL.md" ] && [ -f "$SKILLS_DIR/init/SKILL.md" ] && echo true || echo false)"

# Copy rules
cp "$SCRIPT_DIR/core/rules/"*.md "$RULES_DIR/"
assert "Rules copied (5)" "$([ -f "$RULES_DIR/verify-first.md" ] && [ -f "$RULES_DIR/no-slop.md" ] && echo true || echo false)"

# Copy settings
cp "$SCRIPT_DIR/core/settings.json" "$TEST_CLAUDE/settings.json"
assert "settings.json created" "$([ -f "$TEST_CLAUDE/settings.json" ] && echo true || echo false)"

# Verify file counts
HOOK_COUNT=$(ls "$HOOKS_DIR/"*.sh 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(ls -d "$SKILLS_DIR/"*/ 2>/dev/null | wc -l | tr -d ' ')
RULE_COUNT=$(ls "$RULES_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
assert "5 hooks installed" "$([ "$HOOK_COUNT" -eq 5 ] && echo true || echo false)"
assert "5 skills installed" "$([ "$SKILL_COUNT" -eq 5 ] && echo true || echo false)"
assert "5 rules installed" "$([ "$RULE_COUNT" -eq 5 ] && echo true || echo false)"

echo ""

# --- Test 2: Hook Unit Tests ---
echo -e "${BOLD}## Hook Unit Tests${RESET}"
bash "$SCRIPT_DIR/tests/test-hooks.sh" "$HOOKS_DIR" 2>&1
HOOK_EXIT=$?
assert "All hook tests pass" "$([ $HOOK_EXIT -eq 0 ] && echo true || echo false)"
echo ""

# --- Test 3: Security Checks ---
echo -e "${BOLD}## Security Checks${RESET}"

# No hardcoded paths
HARDCODED=$(grep -rn "/Users/" "$SCRIPT_DIR/hooks/" "$SCRIPT_DIR/skills/" "$SCRIPT_DIR/core/" "$SCRIPT_DIR/docs/" 2>/dev/null | wc -l | tr -d ' ')
assert "No hardcoded /Users/ paths" "$([ "$HARDCODED" -eq 0 ] && echo true || echo false)"

# No secrets
SECRETS=$(grep -rnE "(sk-ant-[a-z]{5}|AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36})" "$SCRIPT_DIR/hooks/" "$SCRIPT_DIR/skills/" "$SCRIPT_DIR/core/" 2>/dev/null | wc -l | tr -d ' ')
assert "No real secrets in code" "$([ "$SECRETS" -eq 0 ] && echo true || echo false)"

# Settings.json is valid JSON
jq empty "$TEST_CLAUDE/settings.json" 2>/dev/null
assert "settings.json is valid JSON" "$([ $? -eq 0 ] && echo true || echo false)"

# outputStyle is set
STYLE=$(jq -r '.outputStyle' "$TEST_CLAUDE/settings.json" 2>/dev/null)
assert "outputStyle is concise" "$([ "$STYLE" = "concise" ] && echo true || echo false)"

echo ""

# --- Test 4: Pre-compact Hook Integration ---
echo -e "${BOLD}## Pre-compact Integration${RESET}"

echo '{}' | bash "$HOOKS_DIR/pre-compact.sh" >/dev/null 2>&1
assert "Pre-compact creates compact-context.md" "$([ -f "$TMPDIR/.claude/compact-context.md" ] && echo true || echo false)"

if [ -f "$TMPDIR/.claude/compact-context.md" ]; then
    HAS_BRANCH=$(grep -c "Branch:" "$TMPDIR/.claude/compact-context.md" 2>/dev/null)
    assert "compact-context.md has git branch" "$([ "$HAS_BRANCH" -gt 0 ] && echo true || echo false)"

    HAS_COMMITS=$(grep -c "Recent commits:" "$TMPDIR/.claude/compact-context.md" 2>/dev/null)
    assert "compact-context.md has recent commits" "$([ "$HAS_COMMITS" -gt 0 ] && echo true || echo false)"
fi

echo ""

# --- Test 5: Skill Files Valid ---
echo -e "${BOLD}## Skill Validation${RESET}"

for skill in forge init git-save overseer slop-scan; do
    SKILL_FILE="$SKILLS_DIR/$skill/SKILL.md"
    if [ -f "$SKILL_FILE" ]; then
        HAS_FRONTMATTER=$(head -1 "$SKILL_FILE" | grep -c "^---$")
        HAS_NAME=$(grep -c "^name:" "$SKILL_FILE")
        assert "Skill $skill has valid frontmatter" "$([ "$HAS_FRONTMATTER" -gt 0 ] && [ "$HAS_NAME" -gt 0 ] && echo true || echo false)"
    else
        assert "Skill $skill exists" "false"
    fi
done

echo ""

# --- Test 6: Rules Compact ---
echo -e "${BOLD}## Rules Token Budget${RESET}"

TOTAL_LINES=0
for rule in "$RULES_DIR/"*.md; do
    LINES=$(wc -l < "$rule" | tr -d ' ')
    TOTAL_LINES=$((TOTAL_LINES + LINES))
done
assert "Rules total under 30 lines ($TOTAL_LINES)" "$([ "$TOTAL_LINES" -lt 30 ] && echo true || echo false)"

echo ""

# --- Cleanup ---
rm -rf "$TMPDIR"

# --- Summary ---
TOTAL=$((PASS + FAIL))
echo "================================"
echo -e "${BOLD}Results: ${GREEN}$PASS passed${RESET}, ${RED}$FAIL failed${RESET} / $TOTAL total"
echo ""

if [[ $FAIL -gt 0 ]]; then
    echo -e "${RED}INTEGRATION TEST FAILED${RESET}"
    exit 1
else
    echo -e "${GREEN}ALL INTEGRATION TESTS PASSED${RESET}"
fi
