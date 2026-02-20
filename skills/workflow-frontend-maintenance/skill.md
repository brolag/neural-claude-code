---
name: workflow-frontend-maintenance
description: Lightweight frontend workflow for minor UI changes. Use when: CSS fixes, spacing adjustments, color changes, copy edits, minor tweaks to existing components. Don't use when: building new components or implementing designs — use workflow-frontend-design instead.
trigger: fix spacing, update color, tweak padding, edit copy, minor UI fix, css fix
---

# Workflow: Frontend Maintenance

For minor UI changes. Skips design and visual validation by default.

## Chain

```
1. discover-standards        → ALWAYS — check conventions even for small changes
2. stop-slop?                → SKIP if: no user-facing copy changed
3. playwright-browser?       → SKIP if: change is CSS/spacing only with no behavioral impact
4. overseer?                 → SKIP if: loc_delta <= 10 AND single file changed
```

## Skip Gates

| Step | Skip When |
|---|---|
| `stop-slop` | No text/copy changed — pure CSS/layout fix |
| `playwright-browser` | Pure spacing/color change, no interaction affected |
| `overseer` | Very small change: 1 file, <= 10 lines |

## Done When

- [ ] Change renders correctly
- [ ] No visual regressions introduced
- [ ] Follows existing conventions

## Entry Signals

"fix the spacing", "change the color to...", "update the copy", "tweak the padding", "the button looks off", "adjust the margin"
