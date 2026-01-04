#!/bin/bash
# Global Telegram Notification Script
# Auto-detects project name and includes agent info
# Usage: notify-telegram.sh "message" [title] [type] [agent]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEDUP_DIR="/tmp/telegram-notify-dedup"
DEDUP_WINDOW=10  # seconds to prevent duplicates

# Look for config in multiple locations
CONFIG_LOCATIONS=(
    "$SCRIPT_DIR/.telegram-config"
    "$HOME/.claude/scripts/.telegram-config"
    "$HOME/.telegram-config"
)

for config in "${CONFIG_LOCATIONS[@]}"; do
    if [ -f "$config" ]; then
        source "$config"
        break
    fi
done

# Check required variables
if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    exit 0
fi

# Auto-detect project name from current directory or git
detect_project() {
    # Try git remote name first
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local remote_url=$(git remote get-url origin 2>/dev/null)
        if [ -n "$remote_url" ]; then
            # Extract repo name from URL
            echo "$remote_url" | sed 's/.*\///' | sed 's/\.git$//'
            return
        fi
        # Fallback to directory name
        basename "$(git rev-parse --show-toplevel 2>/dev/null)"
        return
    fi
    # Last resort: current directory name
    basename "$(pwd)"
}

# Get message from argument or stdin
if [ -n "$1" ]; then
    MESSAGE="$1"
    TITLE="${2:-Claude Code}"
    TYPE="${3:-info}"
    AGENT="${4:-}"
else
    # Read from stdin (for hook usage)
    MESSAGE=$(cat)
    TITLE="Claude Code"
    TYPE="info"
    AGENT=""
fi

# Strip any JSON if accidentally passed
MESSAGE=$(echo "$MESSAGE" | sed 's/^{.*}$//' | head -1)
if [ -z "$MESSAGE" ]; then
    MESSAGE="Notification"
fi

# Auto-detect project
PROJECT=$(detect_project)

# Emoji based on type
case "$TYPE" in
    error)   EMOJI="❌" ;;
    warning) EMOJI="⚠️" ;;
    success) EMOJI="✅" ;;
    loop)    EMOJI="🔄" ;;
    test)    EMOJI="🧪" ;;
    agent)   EMOJI="🤖" ;;
    *)       EMOJI="📢" ;;
esac

# Format message with project and agent info
TIME=$(date '+%H:%M')

# Build header with project
HEADER="$EMOJI $TITLE"
if [ -n "$PROJECT" ]; then
    HEADER="$HEADER [$PROJECT]"
fi

# Add agent if provided
if [ -n "$AGENT" ]; then
    AGENT_LINE="Agent: $AGENT"
else
    AGENT_LINE=""
fi

# Compose full message
if [ -n "$AGENT_LINE" ]; then
    TEXT="$HEADER

$AGENT_LINE

$MESSAGE

🕐 $TIME"
else
    TEXT="$HEADER

$MESSAGE

🕐 $TIME"
fi

# Deduplication: prevent same message from being sent twice within window
mkdir -p "$DEDUP_DIR"
MSG_HASH=$(echo "$MESSAGE" | md5 2>/dev/null || echo "$MESSAGE" | md5sum 2>/dev/null | cut -d' ' -f1)
DEDUP_FILE="$DEDUP_DIR/$MSG_HASH"

# Clean old dedup files (older than window)
find "$DEDUP_DIR" -type f -mmin +1 -delete 2>/dev/null

# Check if recently sent
if [ -f "$DEDUP_FILE" ]; then
    LAST_SENT=$(cat "$DEDUP_FILE" 2>/dev/null)
    NOW=$(date +%s)
    if [ -n "$LAST_SENT" ] && [ $((NOW - LAST_SENT)) -lt $DEDUP_WINDOW ]; then
        # Duplicate within window, skip
        exit 0
    fi
fi

# Record this send
date +%s > "$DEDUP_FILE"

# Send to Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${TEXT}" \
    --data-urlencode "parse_mode=HTML" \
    > /dev/null 2>&1

exit 0
