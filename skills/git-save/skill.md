---
name: git-save
description: Stage and commit code changes with Conventional Commits format. Use when: code changes are complete and ready to commit, at the end of engineering workflows, after overseer approval, user says "save", "commit", "ship it". Don't use when: tests are failing, work is still in progress, overseer flagged critical issues, user said "don't commit yet".
trigger: commit, save changes, ship it, git save
allowed-tools: Bash
---

# Git Save

Professional commit workflow following Conventional Commits v1.0.0.

## Behavior

1. Run `git status` — identify changed files
2. Run `git diff` — understand what changed and why
3. Run `git log --oneline -5` — match existing commit style
4. Stage specific files by name (never `git add -A` blindly)
5. Draft commit message: type(scope): description
6. Commit with Co-Authored-By footer

## Commit Types

| type | use when |
|---|---|
| `feat` | new feature added |
| `fix` | bug fixed |
| `refactor` | code restructured, no behavior change |
| `style` | formatting, no logic change |
| `docs` | documentation only |
| `test` | tests added or updated |
| `chore` | build, deps, config |

## Skip When

- Tests are failing
- Overseer flagged critical issues
- User explicitly said "not yet" or "hold off"
- Uncommitted work is partial / WIP

## Done When

- [ ] Commit created successfully
- [ ] `git status` shows clean working tree (for committed files)
