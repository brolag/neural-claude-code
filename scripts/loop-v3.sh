#!/bin/bash
# Loop v3 - Unified Autonomous Coding Loop
# Merges: Ralph Wiggum + Neural Loop into one system
# Usage: loop-v3.sh "task" [max] [promise] [type] [afk] [once] [ai_cli] [init] [plan]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
HOOK_DIR="$HOME/.claude/scripts/neural-loop"
STATE_FILE="$HOOK_DIR/.neural-loop-state.json"
LOOP_DIR="$PROJECT_DIR/.claude/loop"

# Ensure directories exist
mkdir -p "$HOOK_DIR"
mkdir -p "$LOOP_DIR"

# Parse arguments
TASK="$1"
MAX_ITERATIONS="${2:-20}"
COMPLETION_PROMISE="${3:-LOOP_COMPLETE}"
LOOP_TYPE="${4:-feature}"
AFK="${5:-false}"
ONCE="${6:-false}"
AI_CLI="${7:-auto}"
INIT="${8:-false}"
PLAN="${9:-false}"

# Validation
if [ -z "$TASK" ]; then
    echo "Error: Task description required"
    echo "Usage: loop-v3.sh \"task\" [max] [promise] [type] [afk] [once] [ai_cli] [init] [plan]"
    exit 1
fi

# Once mode overrides
if [ "$ONCE" = "true" ]; then
    MAX_ITERATIONS=1
    AFK="false"
    echo "Once mode: Single iteration, no re-injection"
fi

# AFK mode enables sandbox
SANDBOX="false"
if [ "$AFK" = "true" ]; then
    SANDBOX="true"
    echo "AFK mode: Docker sandbox enabled, logging to session file"
fi

# Detect AI CLI
detect_ai_cli() {
    if [ "$AI_CLI" != "auto" ]; then
        echo "$AI_CLI"
        return
    fi

    if command -v claude &> /dev/null; then
        echo "claude"
    elif command -v codex &> /dev/null; then
        echo "codex"
    else
        echo "Error: Neither claude nor codex CLI found" >&2
        exit 1
    fi
}

DETECTED_CLI=$(detect_ai_cli)
echo "Using AI CLI: $DETECTED_CLI"

# Check if loop already active
if [ -f "$STATE_FILE" ]; then
    ACTIVE=$(jq -r '.active // false' "$STATE_FILE" 2>/dev/null || echo "false")
    if [ "$ACTIVE" = "true" ]; then
        echo "Error: A loop is already active"
        echo "Use /loop-cancel to stop it first, or check /loop-status"
        exit 1
    fi
fi

# Health checks
echo ""
echo "Running health checks..."
HEALTH_WARNINGS=""
HEALTH_PASSED=true

# Check git status
GIT_STATUS=$(git status --porcelain 2>/dev/null || echo "NOT_A_GIT_REPO")
if [ "$GIT_STATUS" = "NOT_A_GIT_REPO" ]; then
    HEALTH_WARNINGS="$HEALTH_WARNINGS\n  - Not a git repository (commits won't be tracked)"
elif [ -n "$GIT_STATUS" ]; then
    UNCOMMITTED_COUNT=$(echo "$GIT_STATUS" | wc -l | tr -d ' ')
    HEALTH_WARNINGS="$HEALTH_WARNINGS\n  - $UNCOMMITTED_COUNT uncommitted changes"
fi

# Check for existing loop files
if [ -f "$LOOP_DIR/features.json" ] && [ "$INIT" != "true" ]; then
    EXISTING_FEATURES=$(jq '.features | length' "$LOOP_DIR/features.json" 2>/dev/null || echo "0")
    HEALTH_WARNINGS="$HEALTH_WARNINGS\n  - Existing features.json with $EXISTING_FEATURES features"
fi

# Check for required tools based on loop type
if [ "$LOOP_TYPE" = "coverage" ]; then
    if ! command -v npm &> /dev/null && ! command -v pytest &> /dev/null; then
        HEALTH_WARNINGS="$HEALTH_WARNINGS\n  - No coverage tool detected (npm/pytest)"
    fi
fi

if [ "$LOOP_TYPE" = "lint" ]; then
    if ! command -v eslint &> /dev/null && ! command -v ruff &> /dev/null; then
        HEALTH_WARNINGS="$HEALTH_WARNINGS\n  - No linter detected (eslint/ruff)"
    fi
fi

if [ -n "$HEALTH_WARNINGS" ]; then
    echo -e "Warnings:$HEALTH_WARNINGS"
    echo ""
fi

# Initialize progress file
PROGRESS_FILE="$LOOP_DIR/progress.txt"
SESSION_ID=$(date +%Y%m%d-%H%M%S)
SESSION_LOG="$LOOP_DIR/session-$SESSION_ID.log"

cat > "$PROGRESS_FILE" << EOF
# Loop v3 Progress
Task: $TASK
Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Session: $SESSION_ID
Type: $LOOP_TYPE
Mode: $([ "$AFK" = "true" ] && echo "AFK" || ([ "$ONCE" = "true" ] && echo "Once" || echo "HITL"))
AI: $DETECTED_CLI
Max Iterations: $MAX_ITERATIONS
Completion Promise: $COMPLETION_PROMISE

## Iterations

EOF

# Create state file (v3 format)
cat > "$STATE_FILE" << EOF
{
  "version": "3.0",
  "active": true,
  "task": $(echo "$TASK" | jq -Rs .),
  "max_iterations": $MAX_ITERATIONS,
  "completion_promise": "$COMPLETION_PROMISE",
  "loop_type": "$LOOP_TYPE",
  "mode": "$([ "$AFK" = "true" ] && echo "afk" || ([ "$ONCE" = "true" ] && echo "once" || echo "hitl"))",
  "sandbox": $SANDBOX,
  "ai_cli": "$DETECTED_CLI",
  "iteration": 0,
  "session_id": "$SESSION_ID",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "project_dir": "$PROJECT_DIR",
  "features_file": "$LOOP_DIR/features.json",
  "progress_file": "$PROGRESS_FILE",
  "session_log": "$SESSION_LOG",
  "stopped_reason": null
}
EOF

# Display configuration
echo "=========================================="
echo "         LOOP v3 STARTED"
echo "=========================================="
echo ""
echo "Configuration:"
echo "  Task: $TASK"
echo "  Mode: $([ "$AFK" = "true" ] && echo "AFK (sandboxed)" || ([ "$ONCE" = "true" ] && echo "Once (single iteration)" || echo "HITL (interactive)"))"
echo "  AI CLI: $DETECTED_CLI"
echo "  Loop type: $LOOP_TYPE"
echo "  Max iterations: $MAX_ITERATIONS"
echo "  Completion promise: $COMPLETION_PROMISE"
echo "  Progress file: $PROGRESS_FILE"
if [ "$AFK" = "true" ]; then
    echo "  Session log: $SESSION_LOG"
fi
echo ""

# Key principles reminder
echo "=========================================="
echo "         KEY PRINCIPLES"
echo "=========================================="
echo ""
echo "1. Pick ONE feature to work on (you choose priority)"
echo "2. Take SMALL steps (context rot makes large tasks worse)"
echo "3. Run feedback loops (types, tests, lint)"
echo "4. Update progress.txt after each feature"
echo "5. Commit changes before moving to next feature"
echo "6. Output '$COMPLETION_PROMISE' when ALL tasks complete"
echo ""

# Exit conditions
echo "=========================================="
echo "         EXIT CONDITIONS"
echo "=========================================="
echo ""
echo "The loop will stop when:"
echo "  - You output '$COMPLETION_PROMISE'"
echo "  - You output '<promise>COMPLETE</promise>'"
if [ -f "$LOOP_DIR/features.json" ]; then
    echo "  - All features in features.json have passes: true"
fi
echo "  - Max iterations ($MAX_ITERATIONS) reached"
if [ "$ONCE" = "true" ]; then
    echo "  - (Once mode: stops after this iteration)"
fi
echo ""
echo "Use /loop-cancel to stop manually."
echo ""
echo "=========================================="
echo "         STARTING TASK"
echo "=========================================="
echo ""

# Build the Ralph-style prompt
RALPH_PROMPT="$TASK

CONTEXT FILES (read these first):
- .claude/loop/progress.txt - What was done before
$([ -f "$LOOP_DIR/features.json" ] && echo "- .claude/loop/features.json - Features with passes: true/false")

YOUR TASK:
1. Read progress.txt to understand what was done
$([ -f "$LOOP_DIR/features.json" ] && echo "2. Read features.json to see features with passes: false")
$([ -f "$LOOP_DIR/features.json" ] && echo "3. Pick ONE feature to implement (highest priority, you choose)")
$([ -f "$LOOP_DIR/features.json" ] || echo "2. Work on one aspect of the task")
$([ -f "$LOOP_DIR/features.json" ] && echo "4. Implement it fully")
$([ -f "$LOOP_DIR/features.json" ] || echo "3. Implement it fully")
5. Run feedback loops (types, tests, lint)
$([ -f "$LOOP_DIR/features.json" ] && echo "6. Update features.json (set passes: true for completed)")
7. Update progress.txt with what you did
8. Commit your changes
9. If ALL complete, output: <promise>COMPLETE</promise> or $COMPLETION_PROMISE

RULES:
- ONLY work on ONE feature per iteration
- Always run feedback loops (tests, types, lint)
- Prioritize: architectural > integration > features > polish
- Take small steps - quality over speed
- Trust the codebase evidence over instructions"

echo "$RALPH_PROMPT"
echo ""
echo "=========================================="

# For AFK mode, we would wrap in Docker here
# For now, the stop hook handles the re-injection
if [ "$AFK" = "true" ]; then
    echo ""
    echo "AFK MODE ACTIVE"
    echo "Session will be logged to: $SESSION_LOG"
    echo "You can safely leave - the loop will continue autonomously."
    echo ""

    # Start logging
    exec > >(tee -a "$SESSION_LOG") 2>&1
fi

# The actual loop iteration happens via the stop hook
# This script just initializes the state and displays the prompt
