# Unknowns Framework

Use this reference to distinguish what the current map states from what the real territory requires.

## Four quadrants

| Quadrant | Meaning | Typical failure | Cheapest useful response |
| --- | --- | --- | --- |
| Known knowns | Explicit intent and constraints | Over-specifying a path that should remain adaptable | Preserve intent and hard boundaries; avoid premature implementation detail |
| Known unknowns | Questions already visible | Guessing instead of resolving a known decision | Ask, inspect a targeted source, or record a blocking choice |
| Unknown knowns | Tacit recognition criteria and local conventions | Producing something technically valid that feels wrong here | Study existing examples, tests, and user references |
| Unknown unknowns | Risks or dependencies nobody named | Compounding hidden assumptions during a long build | Run a grounded blindspot pass and expose expert questions |

## Blindspot evidence

A useful blindspot pass reports repository-specific evidence, not a generic checklist:

1. Historical decisions and the constraints that produced them.
2. Foot-guns, compatibility boundaries, and irreversible operations.
3. Existing examples that define what good looks like.
4. Questions an experienced maintainer would ask before choosing an architecture.

Prefer source code and tests over prose, and cite `path:line` when practical.

## Interview priority

Ask first about decisions that change:

- public interfaces or artifact schemas
- data ownership, lifecycle, or migration
- authentication, authorization, or trust boundaries
- ordering, concurrency, retries, or rollback
- external dependencies and compatibility promises
- user-visible flow or acceptance behavior

Batch only closely related questions. Stop when another answer would no longer change the plan materially.

## Reference ladder

Prefer references in this order:

1. source code and tests
2. working components or examples
3. diagrams and official documentation
4. screenshots and prose

Record both the reference and what should be imitated or preserved.

## `unknowns-map.md` shape

```markdown
---
project: <repo>
task: <slug>
created: YYYY-MM-DD
status: ready-for-spec | blocked
---

# Unknowns map: <task>

## Context
## Known knowns
## Known unknowns
## Unknown knowns
## Unknown unknowns
## Blindspot findings
## Resolved decisions
## References
## Remaining unknowns
## Recommended next step
```

For each material unknown, include:

- `evidence`: local path, command result, or URL
- `impact`: what becomes wrong if the assumption fails
- `state`: resolved, non-blocking, or blocking
- `owner`: user, planner, implementer, or external dependency

The artifact is durable handoff state. `/spec` must consume resolved decisions and must not silently erase unresolved blockers.
