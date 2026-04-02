---
name: git-save
description: "Stage and commit with Conventional Commits. Use when changes are ready to commit."
trigger: commit, save, ship it, git save
allowed-tools: Bash
---

# /git-save — Commit Workflow

1. `git status` — identify changed files
2. `git diff` — understand what changed
3. `git log --oneline -5` — match existing commit style
4. Stage specific files by name (never `git add -A`)
5. Skip files that look sensitive (.env, credentials, keys)
6. Draft commit: `type(scope): description`

## Commit Types

| type | when |
|---|---|
| `feat` | new feature |
| `fix` | bug fix |
| `refactor` | restructure, no behavior change |
| `docs` | documentation only |
| `test` | tests added/updated |
| `chore` | build, deps, config |

## Rules
- NEVER commit if tests are failing
- NEVER commit .env or credential files
- NEVER auto-push (commit only, user pushes manually)
- Ask before committing if scope is unclear
