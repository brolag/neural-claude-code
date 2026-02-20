---
name: workflow-frontend-design
description: Full frontend workflow for new components, pages, redesigns, or mockup implementation. Use when: building new UI, implementing a design, creating a component from scratch, user provides a mockup or Figma reference. Don't use when: minor CSS fixes or copy edits — use workflow-frontend-maintenance instead.
trigger: build UI, new component, implement design, implement mockup, create page, redesign
---

# Workflow: Frontend Design-Led

For new UI builds and redesigns. Runs the full quality chain.

## Chain

```
1. discover-standards        → ALWAYS — know conventions before generating anything
2. craft?                    → SKIP if: loc_delta <= 25 OR task is a single component with clear spec
3. frontend-design           → ALWAYS — apply design thinking, typography, color, layout
4. react-best-practices?     → SKIP if: framework NOT IN [react, next, nextjs]
5. stop-slop?                → SKIP if: no user-facing copy/text in the output
6. playwright-browser?       → SKIP if: no browser URL to validate against
7. visual-compare?           → SKIP if: no mockup or reference image provided
8. overseer                  → ALWAYS — quality gate before done
```

## Skip Gates (measurable)

| Step | Skip When |
|---|---|
| `craft` | Change is a single component, spec is clear, loc_delta <= 25 |
| `react-best-practices` | Framework is not React or Next.js |
| `stop-slop` | Output is pure code — no buttons, labels, copy, headings |
| `playwright-browser` | No live URL available to test against |
| `visual-compare` | No mockup PNG or Figma reference provided |
| `overseer` | Never skip |

## Commands Available in This Workflow

All of these can be invoked as steps:
- `/discover-standards` — extract codebase conventions
- `/craft` — structure the task
- `/frontend-design` — apply design framework
- `/react-best-practices` — performance patterns
- `/stop-slop` — clean copy
- `/playwright-browser` — browser validation
- `/visual-compare` — diff mockup vs implementation
- `/overseer` — final review

## Done When

- [ ] Component/page renders correctly
- [ ] Follows codebase conventions (discover-standards passed)
- [ ] No generic fonts, no purple gradients, backgrounds have depth
- [ ] Copy is clean (stop-slop passed, if applicable)
- [ ] Visual diff approved (if mockup provided)
- [ ] Overseer approved

## Entry Signals

"build a [component/page]", "implement this design", "create UI for...", mockup image attached, Figma URL provided, "redesign the..."
