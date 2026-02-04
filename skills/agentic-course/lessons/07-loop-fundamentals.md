# Lesson 7: Loop Fundamentals

## Objective

Master the core mechanics of autonomous iteration loops.

## The Loop Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                      LOOP LIFECYCLE                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   INIT                                                          │
│   ├── Parse task and success criteria                          │
│   ├── Set iteration limit                                       │
│   └── Initialize state tracking                                 │
│                                                                 │
│   EXECUTE (repeat until done)                                   │
│   ├── Attempt task                                              │
│   ├── Self-evaluate result                                      │
│   ├── If success → Exit with completion promise                 │
│   └── If failure → Retry with failure context                   │
│                                                                 │
│   EXIT                                                          │
│   ├── Success: Output completion promise                        │
│   ├── Limit reached: Report partial progress                    │
│   └── Fatal error: Stop and report                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Loop Types

```bash
# Standard loop - iterate until done
/loop "Make all tests pass" --max 10

# TDD loop - test-driven development
/loop "Implement user service with full test coverage" --type tdd

# Lint loop - fix all linting issues
/loop "Fix all ESLint errors" --type lint

# CRAFT loop - use structured prompt
/loop "Implement auth system" --craft
```

## The --max Flag

**Critical safety feature:**

```bash
# Safe: Will stop after 10 iterations max
/loop "Fix tests" --max 10

# Risky: No limit (avoid!)
/loop "Fix tests"
```

Always set `--max`. Common values:
- Simple fixes: `--max 5`
- Medium tasks: `--max 10`
- Complex work: `--max 20`
- Never go above 30 without good reason

## Self-Evaluation

At each iteration, the loop asks itself:

```
1. Did I complete the task?
   → YES: Output promise and exit
   → NO: Continue

2. Am I making progress?
   → YES: Continue with new approach
   → NO: May need to stop (stuck detection)

3. Did I hit a blocker?
   → YES: Report and ask for help
   → NO: Continue
```

## State Memory

Good loops remember what they tried:

```
Iteration 1: Tried fix A → Failed (type error)
Iteration 2: Tried fix B → Failed (import error)
Iteration 3: Tried fix A+B combined → Success!
```

Without state memory, loops can:
- Try the same failed approach repeatedly
- Undo previous fixes
- Go in circles

## Loop Commands

```bash
# Start a loop
/loop "Task description" --max 10

# Check loop status
/loop-status

# Cancel a running loop
/loop-cancel

# Create todo workflow for complex loops
/todo-new "Feature implementation"
```

## When Loops Work Best

```
✅ GOOD FOR LOOPS                    ❌ BAD FOR LOOPS
─────────────────────────────────────────────────────────
Fix failing tests                    Design decisions
Resolve linting errors               Architecture choices
Update documentation                 Unclear requirements
Apply consistent changes             External dependencies
Refactor with clear rules            Subjective quality
```

## Try It

Run a lint-fixing loop:

```bash
# First, check for lint errors
npm run lint

# Then fix them automatically
/loop "Fix all ESLint errors in src/" --max 10 --type lint
```

## Check

Confirm you understand:

1. Loops self-evaluate and iterate automatically
2. `--max` is essential (circuit breaker)
3. State memory prevents going in circles
4. Best for objective, verifiable tasks

## Next

**Lesson 8: Circuit Breakers** - Advanced loop safety mechanisms.

```bash
/course lesson 8
```

---
*Completion: Mark this lesson done and continue*
