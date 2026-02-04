# Lesson 8: Circuit Breakers

## Objective

Implement safety mechanisms that prevent runaway autonomous loops.

## What Can Go Wrong

```
Without circuit breakers:

1. INFINITE LOOPS
   Fix A breaks B → Fix B breaks A → Fix A breaks B → ...

2. RESOURCE EXHAUSTION
   Loop runs for hours → Consumes all API credits

3. DAMAGE ACCUMULATION
   Each iteration makes things slightly worse

4. STUCK DETECTION FAILURE
   Loop doesn't realize it's not making progress
```

## The 5 Circuit Breakers

```
┌─────────────────────────────────────────────────────────────────┐
│                   5 CIRCUIT BREAKERS                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. ITERATION LIMIT     Maximum attempts (--max 10)            │
│                                                                 │
│  2. TIME LIMIT          Maximum duration (--timeout 30m)       │
│                                                                 │
│  3. TOKEN BUDGET        Maximum context usage                   │
│                                                                 │
│  4. STUCK DETECTION     Same error 3x = stop                   │
│                                                                 │
│  5. DAMAGE THRESHOLD    Regression = abort                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 1. Iteration Limit

```bash
# Always set --max
/loop "Fix tests" --max 10

# Recommended limits:
# Simple: 5
# Medium: 10
# Complex: 20
# Max: 30
```

## 2. Time Limit

```bash
# Stop after 30 minutes
/loop "Refactor module" --max 20 --timeout 30m

# Common timeouts:
# Quick fixes: 10m
# Medium tasks: 30m
# Large refactors: 60m
```

## 3. Token Budget

The 50-60% rule:

```
Context Window: 200K tokens
Optimal Usage:  100-120K tokens
Beyond 120K:    Quality degrades, "forgetfulness"
```

When approaching limit:
- Start fresh session
- Use sub-agents with clean context
- Archive and summarize progress

## 4. Stuck Detection

Loop should track attempts:

```json
{
  "attempts": [
    {"iteration": 1, "error": "TypeError: x is undefined"},
    {"iteration": 2, "error": "TypeError: x is undefined"},
    {"iteration": 3, "error": "TypeError: x is undefined"}
  ],
  "stuck": true,
  "reason": "Same error 3 consecutive times"
}
```

When stuck:
- Stop iterating
- Report what was tried
- Ask for human guidance

## 5. Damage Threshold

Check for regressions:

```bash
Before loop:  15 tests passing, 5 failing
After iter 3: 10 tests passing, 10 failing  # REGRESSION!
```

If tests that were passing start failing → ABORT

```yaml
damage_threshold:
  regression_tolerance: 0    # Any regression = stop
  # or
  regression_tolerance: 2    # Allow 2 new failures
```

## Implementing Breakers

Add to your loop command:

```bash
/loop "Fix all tests" \
  --max 15 \
  --timeout 30m \
  --abort-on-regression
```

Or in CRAFT spec:

```yaml
circuit_breakers:
  max_iterations: 15
  timeout_minutes: 30
  stuck_threshold: 3
  regression_abort: true
```

## Recovery Strategies

When a breaker trips:

```
1. SAVE PROGRESS
   - Commit any working changes
   - Document what was attempted
   - Note the failure point

2. ANALYZE
   - Why did it fail?
   - What pattern caused the loop?
   - What's the blocker?

3. RESTART WITH KNOWLEDGE
   - Include failure context
   - Try different approach
   - Maybe break into smaller tasks
```

## Try It

Create a loop with full safety:

```bash
/loop "Add input validation to all form components in src/components/forms/" \
  --max 10 \
  --timeout 20m \
  --abort-on-regression
```

## Check

Confirm you understand:

1. Five breakers: Iterations, Time, Tokens, Stuck, Damage
2. Always set `--max` (no exceptions)
3. Stuck = same error 3x
4. Regression = tests that passed now fail → abort
5. Save progress before breaker trips

## Next

**Lesson 9: State Management** - Track progress across iterations.

```bash
/course lesson 9
```

---
*Completion: Mark this lesson done and continue*
