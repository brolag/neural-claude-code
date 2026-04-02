#!/bin/bash
#
# Neural Claude Code v2 — Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash
#
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

INSTALL_DIR="${NEURAL_INSTALL_DIR:-$HOME/Sites/neural-claude-code}"
REPO_URL="https://github.com/brolag/neural-claude-code.git"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks/neural"
SKILLS_DIR="$CLAUDE_DIR/skills"
RULES_DIR="$CLAUDE_DIR/rules/neural"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

echo -e "${BOLD}Neural Claude Code v2${RESET}"
echo -e "Lightweight harness: security hooks + forge pipeline + smart defaults"
echo ""

# --- Prerequisites ---
if ! command -v jq &>/dev/null; then
    echo -e "${RED}Error:${RESET} jq is required. Install with: brew install jq"
    exit 1
fi

if ! command -v git &>/dev/null; then
    echo -e "${RED}Error:${RESET} git is required."
    exit 1
fi

echo -e "${GREEN}ok${RESET} Prerequisites met (git, jq)"

# --- Clone or update repo ---
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${BLUE}->>${RESET} Updating existing installation..."
    cd "$INSTALL_DIR" && git pull origin main --quiet
else
    echo -e "${BLUE}->>${RESET} Cloning repository..."
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

echo -e "${GREEN}ok${RESET} Repository ready at $INSTALL_DIR"

# --- Backup existing settings ---
if [ -f "$SETTINGS_FILE" ]; then
    BACKUP="$SETTINGS_FILE.backup.$(date +%Y%m%d%H%M%S)"
    cp "$SETTINGS_FILE" "$BACKUP"
    echo -e "${GREEN}ok${RESET} Backed up settings.json to $(basename $BACKUP)"
fi

# --- Install hooks ---
mkdir -p "$HOOKS_DIR"
cp "$INSTALL_DIR/hooks/"*.sh "$HOOKS_DIR/"
chmod +x "$HOOKS_DIR/"*.sh
echo -e "${GREEN}ok${RESET} Installed 5 security hooks"

# --- Install skills ---
for skill in forge init git-save overseer slop-scan; do
    SKILL_SRC="$INSTALL_DIR/skills/$skill"
    SKILL_DST="$SKILLS_DIR/$skill"
    if [ -d "$SKILL_SRC" ]; then
        mkdir -p "$SKILL_DST"
        cp "$SKILL_SRC/SKILL.md" "$SKILL_DST/SKILL.md"
    fi
done
echo -e "${GREEN}ok${RESET} Installed 5 skills (forge, init, git-save, overseer, slop-scan)"

# --- Install rules ---
mkdir -p "$RULES_DIR"
cp "$INSTALL_DIR/core/rules/"*.md "$RULES_DIR/"
echo -e "${GREEN}ok${RESET} Installed 5 compact rules (~135 tokens total)"

# --- Merge settings.json ---
NEURAL_SETTINGS="$INSTALL_DIR/core/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    # Merge: add neural hooks without overwriting existing ones
    TEMP=$(mktemp)
    jq -s '
        .[0] as $existing |
        .[1] as $neural |
        $existing * {
            outputStyle: ($existing.outputStyle // $neural.outputStyle),
            hooks: (
                ($existing.hooks // {}) as $eh |
                ($neural.hooks // {}) as $nh |
                reduce ($nh | keys[]) as $event (
                    $eh;
                    .[$event] = ((.[$event] // []) + $nh[$event])
                )
            )
        }
    ' "$SETTINGS_FILE" "$NEURAL_SETTINGS" > "$TEMP"
    mv "$TEMP" "$SETTINGS_FILE"
    echo -e "${GREEN}ok${RESET} Merged hooks into existing settings.json"
else
    mkdir -p "$CLAUDE_DIR"
    cp "$NEURAL_SETTINGS" "$SETTINGS_FILE"
    echo -e "${GREEN}ok${RESET} Created settings.json with neural hooks"
fi

# --- Copy .gitignore template ---
if [ -f "$INSTALL_DIR/.gitignore.template" ]; then
    echo -e "${BLUE}->>${RESET} .gitignore template available at: $INSTALL_DIR/.gitignore.template"
    echo -e "    Copy to your project: cp $INSTALL_DIR/.gitignore.template /path/to/project/.gitignore"
fi

# --- Summary ---
echo ""
echo -e "${BOLD}Installation complete${RESET}"
echo ""
echo "  Hooks:  $HOOKS_DIR/ (5 scripts)"
echo "  Skills: $SKILLS_DIR/ (forge, init, git-save, overseer, slop-scan)"
echo "  Rules:  $RULES_DIR/ (5 compact rules)"
echo ""
echo -e "${BOLD}Next steps:${RESET}"
echo "  1. Open Claude Code in your project"
echo "  2. Run /init to generate a project-specific CLAUDE.md"
echo "  3. Run /forge \"your task\" to use the dev pipeline"
echo ""
echo -e "${BOLD}Token budget:${RESET} ~635 tokens/message overhead (rules + CLAUDE.md)"
echo ""
