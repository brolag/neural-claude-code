#!/bin/bash
# Hook: PreCompact — Preserve context before compaction
# Saves key state so Claude can recover after context compression
set -e

PROJECT_DIR="$PWD"
COMPACT_FILE="$PROJECT_DIR/.claude/compact-context.md"

mkdir -p "$PROJECT_DIR/.claude" 2>/dev/null || true

{
    echo "# Pre-Compaction Context ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
    echo ""

    # Current branch and recent commits
    if command -v git &>/dev/null && git rev-parse --git-dir &>/dev/null 2>&1; then
        echo "## Git State"
        echo "Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
        echo "Recent commits:"
        git log --oneline -5 2>/dev/null || true
        echo ""
        echo "Modified files:"
        git diff --name-only 2>/dev/null || true
        git diff --staged --name-only 2>/dev/null || true
        echo ""
    fi

    # Active tasks if any
    if [[ -d "$PROJECT_DIR/plans" ]]; then
        LATEST_PLAN=$(ls -t "$PROJECT_DIR/plans/" 2>/dev/null | head -1)
        if [[ -n "$LATEST_PLAN" ]]; then
            echo "## Active Plan"
            echo "Latest: plans/$LATEST_PLAN"
            echo ""
        fi
    fi
} > "$COMPACT_FILE" 2>/dev/null || true

echo '{"systemMessage": "Context preserved to .claude/compact-context.md. Read it after compaction to recover state."}'
exit 0
