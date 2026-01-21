---
description: Loop Plan - Safe Autonomous Task Execution
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Loop Plan - Safe Autonomous Task Execution

Plan a task thoroughly, then execute it autonomously with proper safety harnesses.

## Usage

```
/loop-plan "<task description>"
```

## Examples

```
/loop-plan "Add user authentication with JWT tokens"
/loop-plan "Refactor the payment module to use Stripe API v2"
/loop-plan "Fix all TypeScript errors and add missing types"
```

## Prompt

You are about to plan and execute an autonomous loop. Follow this structured process:

### Phase 1: Analysis (Do NOT skip)

1. **Understand the task**: What exactly needs to be done?
2. **Explore the codebase**: Read relevant files to understand current state
3. **Identify scope**: List all files/components that will be affected
4. **Detect project type**: What test runner exists? (npm test, pytest, cargo test, etc.)

### Phase 2: Create Execution Plan

Generate a `todo.md` file with this EXACT structure:

```markdown
# Task: [Task Name]

**Created**: [Today's date]
**Completion Promise**: LOOP_COMPLETE
**Max Iterations**: [Calculate based on complexity: 10-40]

## Success Criteria (Must be measurable)

- [ ] [Specific criterion with command to verify]
- [ ] [Another criterion]
- [ ] All tests pass: `[test command]`

## Pre-flight Checks

- [ ] Verify: `[command to check current state]`
- [ ] Backup/branch: `git checkout -b feature/[name]` (if needed)

## Phase 1: [Name] (Iterations 1-X)

### Tasks
- [ ] 1.1 [Atomic task]
- [ ] 1.2 [Atomic task]

### Validation
- [ ] Run: `[validation command]`
- [ ] Expected: [specific result]

## Phase 2: [Name] (Iterations X-Y)

### Tasks
- [ ] 2.1 [Atomic task]
- [ ] 2.2 [Atomic task]

### Validation
- [ ] Run: `[validation command]`
- [ ] Expected: [specific result]

## Phase 3: Finalize (Last iterations)

### Tasks
- [ ] 3.1 Run full test suite
- [ ] 3.2 Fix any remaining issues
- [ ] 3.3 Final validation

### Validation
- [ ] Run: `[full test command]`
- [ ] Expected: All tests pass, no errors

---

**EXIT CONDITION**: Output `LOOP_COMPLETE` when ALL success criteria are met.
```

### Phase 3: Calculate Safety Parameters

Based on task complexity, determine:

| Complexity | Tasks | Max Iterations |
|------------|-------|----------------|
| Simple (1-3 files) | 3-5 | 10 |
| Medium (4-8 files) | 6-10 | 20 |
| Complex (9-15 files) | 11-20 | 30 |
| Large (16+ files) | 20+ | 40 |

### Phase 4: Present Plan for Approval

Show the user:
1. **Summary**: What will be done
2. **Scope**: Files affected
3. **Phases**: High-level breakdown
4. **Safety**: Max iterations and exit criteria
5. **Risk assessment**: What could go wrong

Ask: "Ready to start the loop? (yes/no/adjust)"

### Phase 5: Execute Loop

Once approved, run:

```bash
/loop-start "Follow todo.md step by step. Mark tasks [x] when complete. Run validation after each phase. Output LOOP_COMPLETE when all success criteria pass" --max [calculated] --promise "LOOP_COMPLETE"
```

## Key Rules

1. **NEVER skip the planning phase** - Always analyze first
2. **ALWAYS include validation commands** - Every phase needs verification
3. **Atomic tasks only** - Each task completable in one iteration
4. **Measurable success criteria** - Must be verifiable with commands
5. **Conservative max iterations** - Start lower, can always restart
6. **Create feature branch** for risky changes

## What Makes a Good Plan

✅ **Good:**
- "Run `npm test` - expect 0 failures"
- "Run `npm run typecheck` - expect no errors"
- "Verify endpoint: `curl localhost:3000/api/users` returns 200"

❌ **Bad:**
- "Code should work"
- "Tests should pass" (which tests? what command?)
- "Feature complete" (how to verify?)

## Abort Conditions

The loop should stop if:
- Same error appears 3+ times (stuck)
- Tests were passing, now failing (regression)
- Scope creep detected (working on unrelated files)

If stuck, output: `LOOP_STUCK: [reason]` and stop.

## Output Format

```markdown
## Loop Plan Ready

**Task**: [description]
**Complexity**: [Simple|Medium|Complex|Large]
**Estimated Iterations**: [n]

### Scope
- [n] files affected
- [list key files]

### Phases
1. **[Phase 1]**: [n] tasks
2. **[Phase 2]**: [n] tasks
3. **Finalize**: [n] tasks

### Safety Parameters
- Max iterations: [n]
- Completion promise: LOOP_COMPLETE
- Feature branch: [yes/no]

### Risk Assessment
- [risk 1]
- [risk 2]

**Ready to start?** (yes/no/adjust)
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Can't determine scope | Unclear task | Ask for more specifics |
| Too many files | Task too broad | Break into smaller tasks |
| No test runner | Can't validate | Set up testing first |
| Conflicting changes | Git state dirty | Commit or stash changes |

**Fallback**: If planning fails, create minimal todo.md with manual oversight.
