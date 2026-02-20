---
name: workflow-engineering
description: Software development workflow for features, bugfixes, and hotfixes. Use when: implementing a feature, fixing a bug, refactoring code, any backend or logic work. Three modes: feature | bugfix | hotfix. Don't use when: frontend-only visual changes — use workflow-frontend-* instead.
trigger: implement feature, fix bug, add endpoint, refactor, build backend, hotfix
---

# Workflow: Engineering

Three entry modes. Pick based on task type.

## Mode: Feature

New functionality. Full quality chain.

```
1. spec?                     → SKIP if: task is clear and loc_delta <= 50
2. discover-standards        → ALWAYS
3. craft?                    → SKIP if: spec written OR task is small (loc_delta <= 25)
4. tdd                       → ALWAYS — write the test before the implementation
5. slop-scan                 → SKIP if: loc_delta <= 50 (not worth the noise)
6. overseer                  → ALWAYS
7. git-save?                 → SKIP if: user wants to review the diff first
```

## Mode: Bugfix

Known issue. Root cause first, then fix.

```
1. debugging                 → ALWAYS — find root cause before touching code
2. tdd                       → ALWAYS — repro test BEFORE writing the fix
3. overseer                  → ALWAYS
4. git-save?                 → SKIP if: user wants to review first
```

## Mode: Hotfix

Urgent production issue. Speed over process.

```
1. debugging                 → ALWAYS — still need to know what's broken
2. overseer (reduced)        → Quick check only — no slop scan
3. git-save                  → ALWAYS — ship it
```

## Skip Gates

| Step | Skip When |
|---|---|
| `spec` | Clear task, loc_delta <= 50, no async delegation needed |
| `craft` | Spec already written OR simple, small task |
| `tdd` | Hotfix mode with zero logic change (config/copy fix only) |
| `slop-scan` | loc_delta <= 50 OR hotfix mode |
| `git-save` | User wants to review diff before committing |

## Done When

- [ ] Tests pass (green)
- [ ] No TypeScript errors
- [ ] Overseer approved
- [ ] Committed (if git-save ran)

## Entry Signals

**Feature**: "implement", "add feature", "build", "create endpoint", "new functionality"
**Bugfix**: "fix", "bug", "broken", "not working", "regression", "error in..."
**Hotfix**: "urgent", "production down", "hotfix", "asap", "critical"
