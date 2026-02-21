# Pre-Design Workflow Quick Reference

## The Process

```
EXPLORE → APPROACH → DESIGN → VALIDATE → IMPLEMENT
    │         │          │         │
    │         │          │         └── Catch problems early
    │         │          └── 200-300 word sections
    │         └── Always 2-3 options
    └── One question at a time
```

---

## Phase 1: Exploration

Ask ONE question at a time:

| # | Question | Purpose |
|---|----------|---------|
| 1 | What problem does this solve? | Understand value |
| 2 | Who uses this feature? | Identify user |
| 3 | What are the constraints? | Define limits |
| 4 | What's out of scope? | Prevent creep |
| 5 | How do we measure success? | Define done |

**Prefer multiple choice**:
```
❌ "How should we handle errors?"
✅ "How should we handle errors?
    A) Return error codes
    B) Throw exceptions
    C) Log and continue"
```

---

## Phase 2: Approach Selection

**Always propose 2-3 approaches**:

```markdown
## Approaches

### A: [Name] (Recommended)
[Description]
- ✅ Pro: ...
- ✅ Pro: ...
- ❌ Con: ...

### B: [Name]
[Description]
- ✅ Pro: ...
- ❌ Con: ...
- ❌ Con: ...

## Recommendation
Approach A because [1-2 sentence reasoning].
```

---

## Phase 3: Design Validation

**Present in sections** (200-300 words each):

```
Section 1: Architecture
    ↓ "Does this look right?"
Section 2: Data Model
    ↓ "Does this look right?"
Section 3: Core Logic
    ↓ "Does this look right?"
Section 4: Error Handling
    ↓ "Does this look right?"
VALIDATED DESIGN
```

**Section template**:
```markdown
## Section: [Name]

### Purpose
[1-2 sentences]

### Components
- **[A]**: [role]
- **[B]**: [role]

### Data Flow
[diagram or description]

### Error Handling
[what happens on failure]

---
*Does this look right so far?*
```

---

## Phase 4: Documentation

**Save to**: `docs/plans/YYYY-MM-DD-<feature>-design.md`

```markdown
# Design: [Feature Name]

**Date**: YYYY-MM-DD
**Status**: Validated

## Problem Statement
[What this solves]

## Approach
[Selected approach + reasoning]

## Design
[Validated sections]

## Out of Scope
[Explicitly excluded]

## Success Criteria
[How we know it's done]
```

**Commit before implementation** - design doc = contract.

---

## Key Principles

| Principle | Why |
|-----------|-----|
| One question at a time | Focused answers |
| Multiple choice preferred | Easier to answer |
| Always 2-3 approaches | Avoid bias |
| Lead with recommendation | Show reasoning |
| Incremental validation | Early problem detection |
| YAGNI ruthlessly | Prevent over-engineering |
| Document before code | Contract for implementation |

---

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Multiple questions at once | One at a time |
| Open-ended when options exist | Multiple choice |
| Commit to first idea | Explore 2-3 approaches |
| Design dump | 200-300 word sections |
| Skip validation | Validate each section |
| Verbal agreement only | Write design doc |

---

## Integration with Loops

```
DESIGN DOC ──→ /wt-new ──→ /loop ──→ Merge
     │                       │
     └── Reference during ───┘
         implementation
```

The design doc guides the autonomous loop:
- "According to the design..."
- "The design specifies..."
- "This is out of scope per design"

---

## Checklist

Before implementation:

- [ ] Asked clarifying questions (one at a time)
- [ ] Proposed 2-3 approaches with trade-offs
- [ ] Selected approach with reasoning
- [ ] Validated each design section
- [ ] Wrote design doc
- [ ] Committed design doc to git
- [ ] Can explain design to someone who wasn't there

---

*"Weeks of coding can save hours of planning."*
