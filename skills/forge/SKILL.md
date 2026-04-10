---
name: forge
description: "Full dev pipeline: scan, plan, execute, review, ship. Use when user says /forge or wants the full quality pipeline on a task. Don't use for quick fixes (<25 LOC) or docs-only changes."
argument-hint: "[task description] [--full]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git *), Bash(npm *), Bash(npx *), Bash(pytest *), Bash(find *), Bash(wc *), Bash(mkdir *), Bash(date *), Bash(ls *), Agent, TaskCreate, TaskUpdate, Skill
---

# /forge — Development Pipeline

## Detect Mode

If $ARGUMENTS contains `--full`: use FULL mode.
Otherwise: use SIMPLE mode.

---

## SIMPLE MODE (default)

### Phase 1: SCAN
1. Read CLAUDE.md (project rules)
2. `git log --oneline -5` (recent work)
3. Grep/Glob for files related to $ARGUMENTS
4. Read 1-2 related files to understand patterns

### Phase 2: PLAN
Create `plans/forge-$(date +%Y-%m-%d)-[name]/plan.md`:
- What: requirements + acceptance criteria
- How: files to create/modify, in order
- Tests: what to test and how
- Max 5 subtasks

### Phase 3: EXECUTE
1. Implement subtasks in order
2. Run tests after each subtask
3. If test fails: fix, max 3 attempts, then escalate to human
4. Mark subtasks complete as you go

### Phase 4: REVIEW
Launch 1 Agent with fresh context (NOT the executing agent):
- Provide: diff of all changed files + plan.md
- Prompt: "Review for security (OWASP Top 10), bugs, code quality, and spec compliance. Output: PASS or FAIL with specific findings."
- If FAIL: fix issues, re-review once, then escalate

### Phase 5: SHIP
Print report:
```
## Forge Report
- Files changed: [list]
- Tests: [pass/fail count]
- Review: [PASS/FAIL + key findings]
```
Then STOP. Ask: "Review the diff with `git diff`. Say 'ship it' to commit."
NEVER auto-commit.

---

## FULL MODE (--full)

### Phase 1: SCAN (same as simple)

### Phase 2: CLARIFY
Ask questions ONLY when:
- Multiple valid interpretations exist
- Technical decision significantly affects architecture
- Scope is ambiguous
Max 3 questions. Each with a default: "I'll assume X unless you say otherwise."
If clear: skip, say "Requirements clear."

### Phase 3: DELIBERATE
Launch 3 Agents IN PARALLEL:
- **Agent A (Simplicity)**: Simplest implementation matching existing patterns
- **Agent B (Scalability)**: Design for 10x growth, extend don't replace
- **Agent C (Security)**: Attack vectors, OWASP Top 10, data sensitivity

Synthesize: agreements (do), disagreements (pick simplicity+security), security flags (address).
Write to `plans/forge-[date]-[name]/deliberation.md`

### Phase 4: PLAN
Create in `plans/forge-[date]-[name]/`:
- `spec.md`: requirements, acceptance criteria, out of scope
- `tasks.md`: subtasks with dependencies, mark parallel-safe ones

### Phase 5: EXECUTE
- Independent tasks: launch parallel Agents
- Dependent tasks: sequential with handoff
- Max 3 fix attempts per failing test, then escalate

### Phase 6: REVIEW
Launch 4 review Agents with fresh context (evaluator separation):
1. **Security**: OWASP Top 10 review
2. **Quality**: bugs, edge cases, error handling
3. **Slop**: dead code, over-engineering, inconsistent naming
4. **Overseer**: spec compliance, acceptance criteria met

All must PASS. If any FAIL: fix + re-review that one. Max 2 loops.

### Phase 7: SHIP (same as simple)

---

## When to use
- `/forge "task"` — features, bug fixes, refactors (any size)
- `/forge --full "task"` — 3+ files, auth/payments/data, architecture changes

## When NOT to use
- Quick fixes (<25 LOC): just code directly
- Docs-only changes: just edit
- Config changes: just edit
