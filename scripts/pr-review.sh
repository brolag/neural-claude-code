#!/bin/bash
# pr-review.sh - Dual-AI PR review (Codex + Claude)
# Usage: ./pr-review.sh <PR_NUMBER> [REPO]
# Fetches PR diff from GitHub, runs both AIs, posts combined review comment.

set -e

PR_NUMBER="$1"
if [ -z "$PR_NUMBER" ]; then
  echo "Usage: $0 <PR_NUMBER> [REPO]"
  echo "Example: $0 42 owner/my-repo"
  exit 1
fi

# Auto-detect repo from current git directory if not provided
REPO="${2:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
if [ -z "$REPO" ]; then
  echo "ERROR: Could not auto-detect repo. Pass REPO as second argument."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/pr-review-${PR_NUMBER}-$(date +%Y-%m-%d-%H%M).log"
CODEX_OUTPUT="/tmp/pr-review-codex-$PR_NUMBER.txt"
CLAUDE_OUTPUT="/tmp/pr-review-claude-$PR_NUMBER.txt"
SLOP_OUTPUT="/tmp/pr-review-slop-$PR_NUMBER.txt"

log() { echo "$1" | tee -a "$LOG_FILE"; }

log "=== PR Review ==="
log "PR: #$PR_NUMBER | Repo: $REPO"
log "Time: $(date)"
log ""

# --- Fetch PR metadata ---
PR_TITLE=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json title -q .title 2>/dev/null || echo "Unknown")
PR_URL=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json url -q .url 2>/dev/null || echo "")
PR_DIFF=$(gh pr diff "$PR_NUMBER" --repo "$REPO" 2>/dev/null || echo "[diff unavailable]")
DIFF_SIZE=${#PR_DIFF}

log "PR: $PR_TITLE"
log "URL: $PR_URL"
log "Diff size: $DIFF_SIZE chars"
log ""

# Truncate diff to avoid token limits (keep first 10k chars)
DIFF_SNIPPET="${PR_DIFF:0:10000}"
if [ "$DIFF_SIZE" -gt 10000 ]; then
  DIFF_SNIPPET="$DIFF_SNIPPET
[... diff truncated at 10k chars ...]"
fi

# --- Codex Review: Logic, Edge Cases, Race Conditions ---
log "Running Codex review (logic & edge cases)..."
CODEX_PROMPT="You are a senior code reviewer. Review this PR diff for: logic errors, edge cases, race conditions, missing error handling, null/undefined issues, off-by-one errors.

FORMAT: List issues as [CRITICAL|HIGH|MEDIUM|LOW] Description — file.ext:line
Be specific and actionable. Skip style/formatting. If clean, say 'No critical issues found.'

PR: $PR_TITLE

Diff:
$DIFF_SNIPPET"

codex exec \
  --sandbox read-only \
  --skip-git-repo-check \
  -o "$CODEX_OUTPUT" \
  "$CODEX_PROMPT" 2>>"$LOG_FILE" || true

CODEX_REVIEW=$(cat "$CODEX_OUTPUT" 2>/dev/null || echo "[Codex review unavailable]")
log "Codex review complete ($(echo "$CODEX_REVIEW" | wc -l) lines)"

# --- Claude Review: Security, Architecture, Breaking Changes ---
log "Running Claude review (security & architecture)..."
CLAUDE_PROMPT="You are a senior security and architecture reviewer. Review this PR diff for: security vulnerabilities (injection, auth bypass, data exposure), architectural anti-patterns, breaking changes, performance regressions.

FORMAT: List issues as [CRITICAL|HIGH|MEDIUM|LOW] Description — file.ext:line
Be specific and actionable. Skip style/formatting. If clean, say 'No critical issues found.'

PR: $PR_TITLE

Diff:
$DIFF_SNIPPET"

# Prevent nested session errors
unset CLAUDECODE

claude --print \
  --dangerously-skip-permissions \
  --model "claude-sonnet-4-6" \
  -p "$CLAUDE_PROMPT" > "$CLAUDE_OUTPUT" 2>>"$LOG_FILE" || true

CLAUDE_REVIEW=$(cat "$CLAUDE_OUTPUT" 2>/dev/null || echo "[Claude review unavailable]")
log "Claude review complete ($(echo "$CLAUDE_REVIEW" | wc -l) lines)"

# --- Slop & Over-Engineering Review ---
log "Running slop & over-engineering review..."
SLOP_PROMPT="You are a senior code quality reviewer with zero tolerance for AI slop and over-engineering.

Review this PR diff for TWO categories:

## 1. AI SLOP
Patterns that signal AI-generated or low-quality code:
- Comments/docstrings explaining obvious code ('# increment counter by 1')
- Redundant backwards-compatibility shims for unused code
- Generic placeholder names (data, result, temp, helper, util, manager)
- Unused _var renames instead of actual deletion
- Verbose boilerplate that adds zero value
- Catch-all error messages ('An error occurred', 'Something went wrong')
- Re-exporting types or values that nothing imports
- '// removed' or '// TODO: remove' comments left in

## 2. OVER-ENGINEERING
YAGNI/premature abstraction violations:
- Interface/abstract class with only one implementation
- Factory/builder pattern for simple object creation
- Feature flags or config for things that are always-on
- Helper function used exactly once
- Generics/type parameters that don't add type safety
- Abstraction layers with pass-through methods
- Observer/event pattern where a direct call suffices
- Backwards-compatibility shims for code with no consumers
- 'Designed for future extensibility' when no extension is planned

FORMAT: List issues as [SLOP|OVERENG] severity(HIGH/MED/LOW) Description — file.ext:line
Be ruthless but precise. Skip issues already covered by logic/security review.
If clean, say 'No slop or over-engineering detected.'

PR: $PR_TITLE

Diff:
$DIFF_SNIPPET"

unset CLAUDECODE
claude --print \
  --dangerously-skip-permissions \
  --model "claude-sonnet-4-6" \
  -p "$SLOP_PROMPT" > "$SLOP_OUTPUT" 2>>"$LOG_FILE" || true

SLOP_REVIEW=$(cat "$SLOP_OUTPUT" 2>/dev/null || echo "[Slop review unavailable]")
log "Slop review complete ($(echo "$SLOP_REVIEW" | wc -l) lines)"

# --- Post combined comment ---
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")
COMMENT="## Automated Review — $TIMESTAMP

### Codex (Logic & Edge Cases)
$CODEX_REVIEW

---

### Claude Sonnet (Security & Architecture)
$CLAUDE_REVIEW

---

### Claude Sonnet (AI Slop & Over-Engineering)
$SLOP_REVIEW

---
*Auto-review by \`pr-review.sh\` — Codex v0.98.0 + Claude Sonnet 4.6*"

log ""
log "Posting review comment to PR #$PR_NUMBER..."
gh pr comment "$PR_NUMBER" --repo "$REPO" --body "$COMMENT"

log ""
log "=== Done ==="
log "Log: $LOG_FILE"

# Cleanup temp files
rm -f "$CODEX_OUTPUT" "$CLAUDE_OUTPUT" "$SLOP_OUTPUT"
