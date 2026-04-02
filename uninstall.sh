#!/bin/bash
#
# Neural Claude Code v2 — Uninstaller
# Removes hooks, skills, and rules installed by neural-claude-code
#
set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks/neural"
RULES_DIR="$CLAUDE_DIR/rules/neural"
SKILLS=("forge" "init" "git-save" "overseer" "slop-scan")

echo -e "${BOLD}Neural Claude Code — Uninstall${RESET}"
echo ""

# Remove hooks
if [ -d "$HOOKS_DIR" ]; then
    rm -rf "$HOOKS_DIR"
    echo -e "${GREEN}ok${RESET} Removed hooks from $HOOKS_DIR"
else
    echo -e "${YELLOW}--${RESET} No hooks found at $HOOKS_DIR"
fi

# Remove skills
for skill in "${SKILLS[@]}"; do
    SKILL_DIR="$CLAUDE_DIR/skills/$skill"
    if [ -d "$SKILL_DIR" ]; then
        rm -rf "$SKILL_DIR"
        echo -e "${GREEN}ok${RESET} Removed skill: $skill"
    fi
done

# Remove rules
if [ -d "$RULES_DIR" ]; then
    rm -rf "$RULES_DIR"
    echo -e "${GREEN}ok${RESET} Removed rules from $RULES_DIR"
else
    echo -e "${YELLOW}--${RESET} No rules found at $RULES_DIR"
fi

echo ""
echo -e "${YELLOW}Note:${RESET} settings.json was not modified. Neural hooks in settings.json"
echo "  still reference removed scripts and will fail silently."
echo "  To clean up: edit $CLAUDE_DIR/settings.json and remove entries"
echo "  containing 'hooks/neural/'."
echo ""
echo -e "${GREEN}Uninstall complete.${RESET}"
