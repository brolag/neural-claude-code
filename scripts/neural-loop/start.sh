#!/bin/bash
# Start a Neural Loop session
# Usage: start.sh "prompt" [max_iterations] [completion_promise]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$SCRIPT_DIR/.neural-loop-state.json"

PROMPT="$1"
MAX_ITERATIONS="${2:-20}"
COMPLETION_PROMISE="${3:-LOOP_COMPLETE}"

if [ -z "$PROMPT" ]; then
    echo "Error: Prompt required"
    echo "Usage: start.sh \"prompt\" [max_iterations] [completion_promise]"
    exit 1
fi

# Check if already active
if [ -f "$STATE_FILE" ]; then
    ACTIVE=$(jq -r '.active // false' "$STATE_FILE")
    if [ "$ACTIVE" = "true" ]; then
        echo "Error: A Neural Loop is already active"
        echo "Use /loop-cancel to stop it first"
        exit 1
    fi
fi

# Create state
cat > "$STATE_FILE" << EOF
{
  "active": true,
  "prompt": $(echo "$PROMPT" | jq -Rs .),
  "max_iterations": $MAX_ITERATIONS,
  "completion_promise": "$COMPLETION_PROMISE",
  "iteration": 0,
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "stopped_reason": null
}
EOF

echo "Neural Loop started!"
echo ""
echo "Configuration:"
echo "  Max iterations: $MAX_ITERATIONS"
echo "  Completion promise: $COMPLETION_PROMISE"
echo ""
echo "Loop continues until you output '$COMPLETION_PROMISE' or reach max iterations."
echo "Use /loop-cancel to stop manually."
echo ""
echo "---"
echo "Starting task:"
echo "---"
echo ""
echo "$PROMPT"
