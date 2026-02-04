# Lesson 3: Your First Autonomous Task

## Objective

Run your first autonomous loop and understand how it works.

## The Basic Loop

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   1. You give a task + success criteria                     │
│   2. AI executes                                            │
│   3. AI self-evaluates result                               │
│   4. If not done → retry with context of what failed        │
│   5. Repeat until success OR limit reached                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Anatomy of a Loop Command

```bash
/loop "Fix all failing tests" --max 10
       │                        │
       │                        └── Circuit breaker: max iterations
       │
       └── The task with implicit success criteria
```

## Your First Loop

Let's start with something safe. Create a test file:

```bash
# First, create a file with intentional issues
echo 'const x = 1
const y = 2
const z = x + y
console.log(z)' > /tmp/test-loop.js
```

Now run a simple loop:

```bash
/loop "Add proper semicolons and 'use strict' to /tmp/test-loop.js" --max 3
```

## What Happens

```
Iteration 1:
├── Read file
├── Identify issues (missing semicolons, no 'use strict')
├── Apply fixes
├── Self-check: All fixed?
│   └── If YES → Complete
│   └── If NO  → Continue
│
Iteration 2 (if needed):
├── Re-read file
├── Find remaining issues
├── Fix them
└── Self-check again
```

## The Completion Promise

Every loop needs a way to know it's done:

```bash
# Implicit criteria (AI infers from task)
/loop "Make all tests pass"

# Explicit promise (output exact text when done)
/loop "Refactor auth module" --promise "REFACTOR_COMPLETE"
```

## Safe Loops vs Risky Loops

```
SAFE (good for learning):              RISKY (needs more prep):
───────────────────────────────────────────────────────────
- Format files                         - Refactor core modules
- Add missing tests                    - Change database schema
- Fix linting errors                   - Modify authentication
- Update documentation                 - Deploy to production
```

## Try It

Run this safe loop now:

```bash
/loop "Create a README.md in /tmp/loop-test/ that documents a fictional CLI tool called 'hello-world'" --max 5
```

Watch how it:
1. Creates the directory if needed
2. Writes initial README
3. Self-reviews for completeness
4. Iterates if missing sections

## Check

Confirm you understand:

1. Loops self-evaluate and retry automatically
2. `--max` sets a circuit breaker (essential!)
3. Start with safe, reversible tasks
4. Completion can be implicit or explicit (`--promise`)

## Next

**Lesson 4: CRAFT Framework** - Structure prompts for complex autonomous tasks.

```bash
/course lesson 4
```

---
*Completion: Mark this lesson done and continue*
