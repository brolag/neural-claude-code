# Lesson 11: Pre-Design Workflow

## Objective

Learn to explore and validate designs BEFORE writing code, avoiding wasted implementation effort.

## The Problem

Most developers jump straight to implementation:

```
❌ COMMON PATTERN (Failing)
───────────────────────────────────────
Idea → Code → Problems → Rework → More Code → More Problems
       ↑                                              │
       └──────────── EXPENSIVE LOOP ──────────────────┘
```

This causes:
- **60% of rework** comes from misunderstood requirements
- **Over-engineering** adds 2-3x to implementation time
- **Scope creep** kills autonomous sessions
- **Context exhaustion** from trying multiple approaches

## The Solution

Design-first development with incremental validation:

```
✅ DESIGN-FIRST PATTERN (Winning)
───────────────────────────────────────
Idea → Explore → Design → Validate → Implement
         ↑                    │
         └─── CHEAP LOOP ─────┘
```

Catch problems when they're cheap to fix (in design), not expensive (in code).

---

## The Pre-Design Process

### Phase 1: Exploration

**Goal**: Understand what you're building before proposing solutions.

**Method**: Ask questions ONE AT A TIME.

```
❌ BAD: Overwhelming
─────────────────────
"What's the feature? Who uses it? What are the constraints?
What's the timeline? What technologies should we use?
What about edge cases? How do we test it?"

✅ GOOD: Focused
─────────────────────
"What problem does this feature solve for the user?"
[Wait for answer]
"Who is the primary user of this feature?"
[Wait for answer]
"What happens if this feature fails?"
[Wait for answer]
```

**Question Types** (prefer multiple choice):

| Type | When | Example |
|------|------|---------|
| **Multiple choice** | Clear options exist | "Should this be sync or async? A) Sync B) Async C) User chooses" |
| **Clarifying** | Ambiguous requirement | "When you say 'fast', do you mean < 100ms or < 1s?" |
| **Boundary** | Define scope | "Should this handle edge case X, or is that out of scope?" |
| **Success criteria** | Define done | "How do we know this feature is working correctly?" |

**Key Questions to Ask**:

1. What problem does this solve?
2. Who uses this feature?
3. What are the hard constraints?
4. What's explicitly OUT of scope?
5. How do we measure success?

---

### Phase 2: Approach Selection

**Goal**: Explore alternatives before committing.

**Method**: Always propose 2-3 different approaches with trade-offs.

```markdown
## Approaches

### A: Direct Database Queries (Recommended)
Query the database directly for each request.
- ✅ Simple implementation
- ✅ Always fresh data
- ❌ Higher latency (50-100ms)
- ❌ More database load

### B: In-Memory Cache
Cache results in memory with TTL.
- ✅ Fast responses (< 5ms)
- ✅ Reduced database load
- ❌ Stale data possible
- ❌ Memory overhead
- ❌ Cache invalidation complexity

### C: Hybrid Approach
Cache for reads, direct for writes.
- ✅ Good balance
- ❌ More complex
- ❌ Inconsistency window

## Recommendation
Approach A because:
1. Simplicity reduces bugs
2. 50-100ms latency is acceptable for this use case
3. Database can handle the load at current scale
4. We can add caching later if needed (YAGNI)
```

**Never commit to the first idea**. Even if it seems obvious, proposing alternatives often reveals better solutions or confirms the first choice.

---

### Phase 3: Design Validation

**Goal**: Validate the design incrementally before implementation.

**Method**: Present design in SMALL SECTIONS (200-300 words), validate each.

```
Section 1: Architecture Overview
  ↓ "Does this look right so far?"
Section 2: Data Model
  ↓ "Does this look right so far?"
Section 3: API Design
  ↓ "Does this look right so far?"
Section 4: Error Handling
  ↓ "Does this look right so far?"
COMPLETE VALIDATED DESIGN
```

**Section Template**:

```markdown
## Section: [Name]

### Purpose
[1-2 sentences explaining why this component exists]

### Components
- **[Component A]**: [role and responsibility]
- **[Component B]**: [role and responsibility]

### Data Flow
[How data moves through this section]

### Error Handling
[What happens when things fail]

---
*Does this look right so far?*
```

**If something doesn't look right**: Go back and clarify. It's much cheaper to iterate on design than on code.

---

### Phase 4: Documentation

**Goal**: Capture the validated design for implementation.

**Method**: Write design doc BEFORE any code.

```markdown
# Design: [Feature Name]

**Date**: YYYY-MM-DD
**Status**: Validated

## Problem Statement
[What problem this solves]

## Approach
[Selected approach with reasoning]

## Design

### Architecture
[Validated architecture section]

### Data Model
[Validated data model section]

### API Design
[Validated API section]

### Error Handling
[Validated error handling section]

## Out of Scope
[Explicitly excluded items]

## Success Criteria
[How we know it's done]
```

**Save to**: `docs/plans/YYYY-MM-DD-<feature>-design.md`

**Commit before implementation**: The design doc becomes the contract.

---

## Integration with Autonomous Loops

The design doc becomes input for `/loop`:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   DESIGN DOC ──→ WORKTREE ──→ LOOP ──→ MERGE               │
│       │                         │                           │
│       │                         ↓                           │
│       │                   Tests pass?                       │
│       │                    ├─ Yes → Merge                   │
│       │                    └─ No → Fix                      │
│       │                                                     │
│       └─── Reference during implementation ─────────────────│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

The agent references the design doc to stay on track:
- "According to the design, this component should..."
- "The design specifies error handling as..."
- "This is out of scope per the design doc"

---

## Key Principles

| Principle | Why |
|-----------|-----|
| **One question at a time** | Don't overwhelm; get focused answers |
| **Multiple choice preferred** | Easier to answer than open-ended |
| **2-3 approaches always** | Avoid commitment bias |
| **Lead with recommendation** | Show your reasoning |
| **Incremental validation** | Catch problems early |
| **YAGNI ruthlessly** | Remove unnecessary features from designs |
| **Document before code** | Design doc = implementation contract |

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| **Multiple questions at once** | Overwhelming, incomplete answers | One at a time |
| **Open-ended when options exist** | Vague answers | Multiple choice |
| **First idea = final idea** | Miss better solutions | Always 2-3 approaches |
| **Design dump** | Too much to validate | 200-300 word sections |
| **Skip validation** | Problems found in code | Validate each section |
| **Verbal agreement only** | Forgotten details | Write design doc |

---

## Try It

Take a feature you want to build. Before writing ANY code:

### Exercise 1: Exploration
Write 5 clarifying questions, each asking ONE thing:
1. ___
2. ___
3. ___
4. ___
5. ___

### Exercise 2: Approaches
Propose 2 different approaches with pros/cons:

**Approach A**: ___
- Pro: ___
- Con: ___

**Approach B**: ___
- Pro: ___
- Con: ___

**Recommendation**: ___ because ___

### Exercise 3: Validation
Break your design into 4 sections of ~250 words each:
1. Architecture Overview
2. Data Model
3. Core Logic
4. Error Handling

### Exercise 4: Documentation
Create a design doc at `docs/plans/YYYY-MM-DD-<feature>-design.md`

---

## Check

Answer these questions:

1. Can you explain the design to someone who wasn't in the conversation?
   - If no → Need more validation

2. Did you consider at least 2 different approaches?
   - If no → Go back and explore alternatives

3. Is every design section validated?
   - If no → Get feedback on remaining sections

4. Is there a written design doc?
   - If no → Write it before implementation

5. Is the design doc committed to git?
   - If no → Commit it as the implementation contract

---

## Next

Now that you have a validated design, you're ready for implementation.

**Next lesson**: Context Engineering - how to manage the context window during long implementations.

```bash
/course lesson 12
```

---

## Quick Reference

```
PRE-DESIGN WORKFLOW
═══════════════════

EXPLORE ─────────────────────────────────
  • One question at a time
  • Multiple choice when possible
  • Focus: purpose, constraints, success

APPROACH ────────────────────────────────
  • Always 2-3 options
  • Pros/cons for each
  • Lead with recommendation

DESIGN ──────────────────────────────────
  • 200-300 word sections
  • Validate each section
  • Cover: arch, data, logic, errors

DOCUMENT ────────────────────────────────
  • Write before code
  • Commit as contract
  • Reference during implementation
```

---

*"Weeks of coding can save you hours of planning." - Unknown*
