#!/bin/bash
# Session Start Hook
# Initializes session state, generates agent name, loads output style

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"
DATA_DIR="$PWD/.claude/data"
SESSION_FILE="$DATA_DIR/current-session.json"
CONFIG_FILE="$PWD/.claude/settings.local.json"

# Create data directory if needed
mkdir -p "$DATA_DIR"

# Generate session ID
SESSION_ID="session-$(date +%s)-$$"

# Generate agent name using the shared utility script
generate_agent_name() {
  if [ -x "$PLUGIN_ROOT/scripts/utils/agent-name.sh" ]; then
    "$PLUGIN_ROOT/scripts/utils/agent-name.sh"
  else
    # Fallback to random feminine name
    local names=("Nova" "Luna" "Aurora" "Iris" "Stella" "Aria" "Lyra" "Freya" "Athena" "Celeste" "Diana" "Electra" "Flora" "Gaia" "Hera" "Ivy" "Jade" "Kira" "Lila" "Maya" "Nyla" "Opal" "Pearl" "Quinn" "Ruby" "Sage" "Terra" "Uma" "Vera" "Willow")
    echo "${names[$RANDOM % ${#names[@]}]}"
  fi
}

AGENT_NAME=$(generate_agent_name)

# Get current output style from config or default
OUTPUT_STYLE="default"
if [ -f "$CONFIG_FILE" ]; then
  OUTPUT_STYLE=$(jq -r '.outputStyle // "default"' "$CONFIG_FILE" 2>/dev/null)
fi

# Create session state file
cat > "$SESSION_FILE" << EOF
{
  "session_id": "$SESSION_ID",
  "agent_name": "$AGENT_NAME",
  "project": "$(basename "$PWD")",
  "output_style": "$OUTPUT_STYLE",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "prompts": []
}
EOF

# Load output style prompt if exists
STYLE_FILE="$PLUGIN_ROOT/output-styles/$OUTPUT_STYLE.md"
if [ -f "$STYLE_FILE" ]; then
  echo ""
  echo "# Output Style: $OUTPUT_STYLE"
  echo ""
  cat "$STYLE_FILE"
  echo ""
fi

# Log session start
echo "[Session $SESSION_ID started with agent '$AGENT_NAME' using '$OUTPUT_STYLE' style]" >&2
