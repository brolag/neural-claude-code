#!/bin/bash
# Neural Loop - Autonomous iteration for Claude Code
# Stop hook that re-injects prompts until completion
# Based on Ralph Wiggum pattern: https://ghuntley.com/ralph/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$SCRIPT_DIR/.neural-loop-state.json"
LOG_DIR="${CLAUDE_LOG_DIR:-$SCRIPT_DIR/../../logs}"
LOG_FILE="$LOG_DIR/neural-loop.log"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check if loop is active
if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

STATE=$(cat "$STATE_FILE")
ACTIVE=$(echo "$STATE" | jq -r '.active // false')
ITERATION=$(echo "$STATE" | jq -r '.iteration // 0')
MAX_ITERATIONS=$(echo "$STATE" | jq -r '.max_iterations // 50')
PROMPT=$(echo "$STATE" | jq -r '.prompt // ""')
COMPLETION_PROMISE=$(echo "$STATE" | jq -r '.completion_promise // "LOOP_COMPLETE"')

if [ "$ACTIVE" != "true" ]; then
    log "Loop inactive, allowing exit"
    exit 0
fi

# Check max iterations
if [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
    log "Max iterations ($MAX_ITERATIONS) reached"
    echo "$STATE" | jq '.active = false | .stopped_reason = "max_iterations"' > "$STATE_FILE"

    # Notify if available
    NOTIFY_SCRIPT="$SCRIPT_DIR/../notify-telegram.sh"
    if [ -f "$NOTIFY_SCRIPT" ]; then
        bash "$NOTIFY_SCRIPT" "Neural Loop stopped: Max iterations reached" "Neural Loop" "warning"
    fi
    exit 0
fi

# Check for completion promise in last output
LAST_OUTPUT_FILE="$SCRIPT_DIR/../../.last-output.txt"
if [ -f "$LAST_OUTPUT_FILE" ] && grep -q "$COMPLETION_PROMISE" "$LAST_OUTPUT_FILE"; then
    log "Completion promise found: $COMPLETION_PROMISE"
    echo "$STATE" | jq '.active = false | .stopped_reason = "completion_promise"' > "$STATE_FILE"

    NOTIFY_SCRIPT="$SCRIPT_DIR/../notify-telegram.sh"
    if [ -f "$NOTIFY_SCRIPT" ]; then
        bash "$NOTIFY_SCRIPT" "Neural Loop completed after $ITERATION iterations!" "Neural Loop" "success"
    fi
    exit 0
fi

# Increment iteration
NEW_ITERATION=$((ITERATION + 1))
echo "$STATE" | jq ".iteration = $NEW_ITERATION" > "$STATE_FILE"
log "Continuing loop: iteration $NEW_ITERATION of $MAX_ITERATIONS"

# Check for test results
TEST_RESULTS_FILE="$SCRIPT_DIR/../../.test-results.txt"
TEST_STATUS=""
if [ -f "$TEST_RESULTS_FILE" ]; then
    TEST_STATUS=$(head -1 "$TEST_RESULTS_FILE")
fi

# Output prompt for re-injection
echo ""
echo "---"
echo "NEURAL LOOP - Iteration $NEW_ITERATION/$MAX_ITERATIONS"
echo "---"
echo ""
echo "$PROMPT"
echo ""
echo "Previous work is in modified files. Check git status and continue."

if [ "$TEST_STATUS" = "TESTS_FAILED" ]; then
    echo ""
    echo "---"
    echo "TEST FAILURES FROM PREVIOUS ITERATION:"
    echo "---"
    tail -n +2 "$TEST_RESULTS_FILE"
    echo ""
    echo "Fix these test failures before continuing."
elif [ "$TEST_STATUS" = "TESTS_PASSED" ]; then
    echo ""
    echo "Tests passed in previous iteration."
fi

echo ""
echo "Output '$COMPLETION_PROMISE' when complete."

# Exit code 2 blocks exit and re-injects output as prompt
exit 2
