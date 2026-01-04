#!/bin/bash
# Cancel an active Neural Loop

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$SCRIPT_DIR/.neural-loop-state.json"

if [ ! -f "$STATE_FILE" ]; then
    echo "No Neural Loop is active"
    exit 0
fi

ACTIVE=$(jq -r '.active // false' "$STATE_FILE")
ITERATION=$(jq -r '.iteration // 0' "$STATE_FILE")

if [ "$ACTIVE" != "true" ]; then
    echo "No Neural Loop is currently active"
    echo "Last loop completed at iteration $ITERATION"
    exit 0
fi

jq '.active = false | .stopped_reason = "user_cancelled"' "$STATE_FILE" > "$STATE_FILE.tmp"
mv "$STATE_FILE.tmp" "$STATE_FILE"

echo "Neural Loop cancelled after $ITERATION iterations"

# Notify if available
NOTIFY_SCRIPT="$SCRIPT_DIR/../notify-telegram.sh"
if [ -f "$NOTIFY_SCRIPT" ]; then
    bash "$NOTIFY_SCRIPT" "Neural Loop cancelled after $ITERATION iterations" "Neural Loop" "warning"
fi
