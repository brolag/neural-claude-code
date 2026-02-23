---
name: pr-review
description: "Dual-AI automated PR review. Use when: a PR is ready to merge and you want Codex + Claude to review it before human approval. Don't use when: reviewing uncommitted local changes (use codex review --uncommitted instead) or reviewing files directly."
trigger: /pr-review
allowed-tools: Bash
---

# PR Review

Runs dual-AI automated review on a GitHub PR using Codex (logic/edge cases) + Claude (security/architecture), then posts the combined review as a PR comment.

## Usage

```bash
# From any directory — auto-detects repo from current git context
/pr-review 42

# Specify repo explicitly
/pr-review 42 indie-mind/mission-control

# From a project directory
cd /Users/brolag/Sites/mission-control && /pr-review 15
```

## What it reviews

| Reviewer | Focus |
|----------|-------|
| **Codex** | Logic errors, edge cases, race conditions, null handling, off-by-one |
| **Claude Sonnet** | Security vulnerabilities, architectural anti-patterns, breaking changes |

## Output Format

Posts a comment directly on the PR:

```markdown
## Automated Review — 2026-02-23 14:30 UTC

### Codex (Logic & Edge Cases)
[CRITICAL] Missing null check on user.id — api/users.ts:42
[HIGH] Race condition in concurrent writes — lib/db.ts:108

---

### Claude Sonnet (Security & Architecture)
[HIGH] SQL input not sanitized before query — api/search.ts:67
No critical issues found in architecture.

---
*Auto-review by `pr-review.sh` — Codex v0.98.0 + Claude Sonnet 4.6*
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `Could not auto-detect repo` | Not in a git directory | Pass REPO as second argument |
| `[Codex review unavailable]` | Codex CLI error | Check `codex login` status |
| `[Claude review unavailable]` | Claude CLI error | Check Claude Code installation |
| `diff unavailable` | PR not found or no access | Verify PR number and repo permissions |

**Fallback**: If script fails, run manually:
```bash
gh pr diff <PR#> | cat  # inspect diff
codex review --base main  # from the PR branch worktree
```

## Implementation

```bash
# Find script relative to plugin installation
PLUGIN_DIR="$(find ~/.claude/plugins/cache -name 'pr-review.sh' -path '*/neural-claude-code*' 2>/dev/null | head -1)"
if [ -z "$PLUGIN_DIR" ]; then
  # Fallback: direct path
  PLUGIN_DIR="$HOME/Sites/neural-claude-code-plugin/scripts/pr-review.sh"
fi
bash "$PLUGIN_DIR" "$1" "${2:-}"
```
