---
name: overseer
description: "Adversarial review of PRs and diffs before merge. Use when finishing a PR, before merging to main, or user says 'review this diff', 'check this PR', 'is this ready to merge'. Detects slop, security issues, inconsistencies."
argument-hint: "[path or --pr NUMBER]"
allowed-tools: Read, Grep, Glob, Bash(git diff *), Bash(git log *), Bash(gh pr *)
---

# /overseer — Code Review

## Usage
```
/overseer              # review current branch diff
/overseer src/api/     # review specific path
/overseer --pr 123     # review specific PR
```

## Process

1. Get the diff: `git diff main...HEAD` (or specific PR/path)
2. Read CLAUDE.md for project conventions
3. Review each changed file for:

### Security
- SQL/command injection
- XSS vulnerabilities
- Exposed secrets or API keys
- Missing input validation
- Unsafe file operations

### Quality
- Functions >50 lines
- Nested conditionals >3 levels
- Duplicated logic
- Missing error handling
- Unused imports or dead code

### Consistency
- Follows project conventions (from CLAUDE.md)
- Code style matches existing files
- Tests included for new features
- Naming is consistent

## Output

```markdown
## Overseer Review: [feature/fix name]

**Score**: X/10

| Severity | Issue | Location | Fix |
|----------|-------|----------|-----|
| High | ... | file:line | ... |

**Verdict**: APPROVE (>=8) or FIX REQUIRED (<8)
```

## Rules
- Score 8-10: approve
- Score 5-7: fix required, provide specific suggestions
- Score 1-4: block merge, detailed issues listed
- Never approve hardcoded secrets
- Never approve code without tests for new features
