#!/bin/bash
# Session Start Hook
# Initializes session state, generates agent name, loads output style
# NOW WITH AUTO-EXPERTISE INJECTION (Learning Loop Fix #1)

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code}"
DATA_DIR="$PWD/.claude/data"
SESSION_FILE="$DATA_DIR/current-session.json"
CONFIG_FILE="$PWD/.claude/settings.local.json"
EXPERTISE_DIR="$PWD/.claude/expertise"
MANIFEST_FILE="$EXPERTISE_DIR/manifest.yaml"
MEMORY_DIR="$PWD/.claude/memory"
EVENTS_DIR="$MEMORY_DIR/events"

# Create directories if needed
mkdir -p "$DATA_DIR" "$EVENTS_DIR"

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

# ============================================
# AUTO-INJECT EXPERTISE (Learning Loop Fix #1)
# ============================================
# Ensures agents always have their mental models loaded

inject_expertise() {
    # Skip if no expertise directory
    [ ! -d "$EXPERTISE_DIR" ] && return

    local expertise_summary=""

    # Check for manifest to load in dependency order
    if [ -f "$MANIFEST_FILE" ]; then
        LOAD_ORDER=$(grep -A 20 "load_order:" "$MANIFEST_FILE" 2>/dev/null | grep "^\s*-" | sed 's/.*- //' | tr '\n' ' ')
    else
        # Default: common expertise domains
        LOAD_ORDER="second-brain knowledge-management cognitive-amplifier strategic-advisor"
    fi

    # Build expertise summary
    for domain in $LOAD_ORDER; do
        EXPERTISE_FILE="$EXPERTISE_DIR/${domain}.yaml"
        if [ -f "$EXPERTISE_FILE" ]; then
            DOMAIN=$(grep "^domain:" "$EXPERTISE_FILE" 2>/dev/null | cut -d':' -f2 | xargs)
            VERSION=$(grep "^version:" "$EXPERTISE_FILE" 2>/dev/null | cut -d':' -f2 | xargs)
            PATTERNS=$(grep -A 20 "patterns:" "$EXPERTISE_FILE" 2>/dev/null | grep "^\s*-" | head -3 | sed 's/.*- "//' | sed 's/"$//' | tr '\n' '; ')

            expertise_summary="${expertise_summary}[${DOMAIN:-$domain} v${VERSION:-1}] "
        fi
    done

    if [ -n "$expertise_summary" ]; then
        echo ""
        echo "# Expertise Loaded"
        echo "$expertise_summary"
        echo ""
    fi
}

# Inject expertise if available
inject_expertise

# ============================================
# AUTO-INJECT LEARNINGS (Learning Loop Fix #2)
# ============================================
# Loads compact learnings summary into context

inject_learnings() {
    LEARNINGS_SUMMARY="$MEMORY_DIR/learnings/summary.md"

    # Skip if no learnings summary
    [ ! -f "$LEARNINGS_SUMMARY" ] && return

    # Check if summary is recent (within 7 days)
    if [ -f "$LEARNINGS_SUMMARY" ]; then
        SUMMARY_AGE=$(( ($(date +%s) - $(stat -f %m "$LEARNINGS_SUMMARY" 2>/dev/null || echo 0)) / 86400 ))

        echo ""
        echo "# Recent Learnings"

        if [ "$SUMMARY_AGE" -gt 7 ]; then
            echo "*Summary is ${SUMMARY_AGE} days old - run index-learnings.sh to refresh*"
            echo ""
        fi

        # Output just the key sections (skip header, keep under ~400 tokens)
        sed -n '/^## Recent Knowledge/,/^## Domains Covered/p' "$LEARNINGS_SUMMARY" | head -30
        echo ""
        echo "*Full details: /recall <topic>*"
        echo ""
    fi
}

# Inject learnings if available
inject_learnings

# Log session start event for pattern analysis
TODAY=$(date +%Y-%m-%d)
SESSION_LOG="$EVENTS_DIR/$TODAY.jsonl"
echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"session_start\",\"session_id\":\"$SESSION_ID\",\"agent\":\"$AGENT_NAME\"}" >> "$SESSION_LOG" 2>/dev/null || true

# Log session start
echo "[Session $SESSION_ID started with agent '$AGENT_NAME' using '$OUTPUT_STYLE' style]" >&2
