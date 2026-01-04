#!/bin/bash
# Test-on-Stop Hook
# Auto-detects project type and runs tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"
LOG_DIR="${CLAUDE_LOG_DIR:-$SCRIPT_DIR/../../logs}"
LOG_FILE="$LOG_DIR/test-on-stop.log"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check for code changes
HAS_CHANGES=false
if ! git -C "$PROJECT_ROOT" diff --quiet HEAD 2>/dev/null; then
    HAS_CHANGES=true
fi

# Detect test runner
detect_runner() {
    if [ -f "$PROJECT_ROOT/package.json" ] && grep -q '"test"' "$PROJECT_ROOT/package.json" 2>/dev/null; then
        echo "npm"; return
    fi
    if [ -f "$PROJECT_ROOT/Cargo.toml" ]; then
        echo "cargo"; return
    fi
    if [ -f "$PROJECT_ROOT/pyproject.toml" ] || [ -f "$PROJECT_ROOT/pytest.ini" ]; then
        echo "pytest"; return
    fi
    if [ -f "$PROJECT_ROOT/go.mod" ]; then
        echo "go"; return
    fi
    if [ -f "$PROJECT_ROOT/Makefile" ] && grep -q "^test:" "$PROJECT_ROOT/Makefile" 2>/dev/null; then
        echo "make"; return
    fi
    echo "none"
}

run_tests() {
    local runner="$1"
    local output=""
    local exit_code=0

    cd "$PROJECT_ROOT"

    case "$runner" in
        npm)    output=$(npm test 2>&1) || exit_code=$? ;;
        cargo)  output=$(cargo test 2>&1) || exit_code=$? ;;
        pytest) output=$(python -m pytest 2>&1) || exit_code=$? ;;
        go)     output=$(go test ./... 2>&1) || exit_code=$? ;;
        make)   output=$(make test 2>&1) || exit_code=$? ;;
        none)   log "No test runner"; return 0 ;;
    esac

    log "Runner: $runner, Exit: $exit_code"

    # Save results for neural-loop
    RESULTS_FILE="$SCRIPT_DIR/../../.test-results.txt"

    if [ $exit_code -ne 0 ]; then
        echo "TESTS_FAILED" > "$RESULTS_FILE"
        echo "" >> "$RESULTS_FILE"
        echo "$output" | tail -50 >> "$RESULTS_FILE"

        echo ""
        echo "--- TEST RESULTS (FAILED) ---"
        echo "$output" | tail -50
        echo ""
        echo "Tests failed. Fix the issues above."

        NOTIFY_SCRIPT="$SCRIPT_DIR/../notify-telegram.sh"
        if [ -f "$NOTIFY_SCRIPT" ]; then
            bash "$NOTIFY_SCRIPT" "Tests failed!" "Test Runner" "error"
        fi
    else
        echo "TESTS_PASSED" > "$RESULTS_FILE"
        log "All tests passed"
        echo "All tests passed."
    fi

    return $exit_code
}

# Main
RUNNER=$(detect_runner)
log "Detected: $RUNNER"

if [ "$RUNNER" != "none" ] && [ "$HAS_CHANGES" = "true" ]; then
    run_tests "$RUNNER"
elif [ "$HAS_CHANGES" = "false" ]; then
    log "No changes, skipping tests"
fi

exit 0
