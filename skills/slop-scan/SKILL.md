---
name: slop-scan
description: "Scan a codebase for accumulated slop, technical debt, dead code, and refactor opportunities. Default is recent changes only. Use when user says 'scan for slop', 'find tech debt', 'what needs cleanup', or before a refactor sprint. Don't use as the pre-PR gate — that is /vet (lens D)."
argument-hint: "[path] [--quick] [--commits N] [--full]"
allowed-tools: Glob, Grep, Read, Bash(git log *), Bash(git diff *), Bash(wc *), Bash(find *)
---

# /slop-scan — Detect Technical Debt

## Usage
```
/slop-scan              # recent changes (uncommitted + staged)
/slop-scan --commits 3  # last N commits
/slop-scan src/         # changed files in a directory
/slop-scan --full       # whole project
/slop-scan --quick      # top issues only, still recent-changes unless --full
```

## What It Detects

1. **Code smells**: functions >50 lines, files >500 lines, nesting >3 levels
2. **Duplication**: copy-pasted blocks, repeated patterns
3. **Dead code**: unused functions, commented-out code >10 lines, unused imports
4. **Tech debt**: old TODOs, deprecated APIs, outdated deps
5. **Anti-patterns**: magic numbers, tight coupling, missing error handling
6. **AI slop**: over-abstraction, unnecessary helpers, verbose comments on obvious code

## Process

1. Select files (default = diff mode):
   - Default: `git diff --name-only HEAD` + `git diff --cached --name-only`
   - `--commits N`: `git diff --name-only HEAD~N`
   - `--full`: all files by type (exclude node_modules, .git, dist, vendor)
   - If no git changes found, ask before running `--full`
2. Prioritize most-changed files (`git log --format=%H -- FILE | wc -l`)
3. Grep for patterns (TODO, FIXME, unused, deprecated)
4. Read top hotspot files for deeper analysis
5. Score and rank by impact

## Output

```markdown
## Slop Report: [project]

**Slop Level**: Low/Medium/High
**Files scanned**: X | **Issues**: Y

### Critical (fix now)
| Issue | Location | Effort |
|-------|----------|--------|

### Quick Wins (low effort, high impact)
- [list with estimated time]

### Deep Refactors (plan for sprint)
- [list with estimated time]

### Hotspots (most problematic files)
1. file.ts — X issues
```

## Decision Rules
- High (>30 issues): pause features, refactor sprint
- Medium (10-30): weekly cleanup sessions
- Low (<10): maintenance mode
