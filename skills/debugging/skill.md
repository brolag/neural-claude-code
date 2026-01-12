---
name: debugging
description: Systematic debugging skill with 4-phase root cause analysis. Use when encountering bugs, unexpected behavior, or test failures.
trigger: /debug
context: fork
agent: general-purpose
---

# Systematic Debugging Skill

Structured debugging methodology based on obra/superpowers patterns. Replaces ad-hoc guessing with systematic root cause analysis.

## Philosophy

> "Systematic over ad-hoc. Evidence over claims. Verification before completion."

Never guess. Always investigate systematically.

## The 4-Phase Process

```
┌─────────────────────────────────────────────────────────────┐
│                    ROOT CAUSE ANALYSIS                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────┐   ┌──────────────┐   ┌──────────┐   ┌──────┐│
│   │ OBSERVE  │──▶│ HYPOTHESIZE  │──▶│   TEST   │──▶│ FIX  ││
│   │  What    │   │   Why?       │   │  Verify  │   │ Root ││
│   │  failed? │   │  List all    │   │  each    │   │ cause││
│   └──────────┘   └──────────────┘   └──────────┘   └──────┘│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Phase 1: OBSERVE

Gather facts before making assumptions.

### Questions to Answer
1. **What exactly failed?** (Error message, stack trace)
2. **What was expected?** (Correct behavior)
3. **What was actual?** (Observed behavior)
4. **When did it start?** (Recent change? Always broken?)
5. **Is it reproducible?** (Always? Sometimes? Specific conditions?)

### Information to Collect
```yaml
observation:
  error_type: "TypeError | NetworkError | AssertionError | etc"
  error_message: "exact message"
  stack_trace: "relevant lines"
  expected: "what should happen"
  actual: "what happened"
  reproducibility: "always | sometimes | first_run_only"
  environment:
    - node_version: "20.x"
    - os: "macOS"
    - relevant_config: "..."
```

### DO NOT
- Jump to conclusions
- Start fixing without understanding
- Assume you know the cause

## Phase 2: HYPOTHESIZE

List ALL possible causes before testing any.

### Hypothesis Categories
1. **Input Issues**: Bad data, edge cases, null values
2. **State Issues**: Race conditions, stale state, initialization order
3. **Environment Issues**: Config, dependencies, versions
4. **Logic Issues**: Wrong algorithm, off-by-one, boundary conditions
5. **Integration Issues**: API changes, contract violations

### Hypothesis Format
```yaml
hypotheses:
  - id: "H1"
    description: "Null user object causes crash"
    likelihood: high
    test_method: "Add null check, log user value"

  - id: "H2"
    description: "Race condition between auth and data fetch"
    likelihood: medium
    test_method: "Add timing logs, sequence diagram"

  - id: "H3"
    description: "Cached stale token"
    likelihood: low
    test_method: "Clear cache, verify token expiry"
```

### Prioritization
Test hypotheses in order of:
1. **Likelihood** (most likely first)
2. **Impact** (critical path first)
3. **Ease of testing** (quick wins)

## Phase 3: TEST

Verify each hypothesis systematically.

### Testing Methods

#### Logging
```typescript
// Strategic placement
console.log("[DEBUG] Before auth check:", { user, token, timestamp });
// ... code
console.log("[DEBUG] After auth check:", { result, error });
```

#### Assertions
```typescript
// Add defensive checks
assert(user !== null, "User should not be null at this point");
assert(token.expiresAt > Date.now(), "Token should not be expired");
```

#### Isolation
```typescript
// Test component in isolation
const result = await fetchUser({ id: 1 }); // Direct call
console.log("Isolated result:", result);
```

#### Binary Search
```
If bug is in large code section:
1. Comment out half
2. Test
3. Bug gone? It's in commented half
4. Bug persists? It's in remaining half
5. Repeat until found
```

### Test Results
```yaml
test_results:
  - hypothesis: "H1"
    result: "CONFIRMED"
    evidence: "user was null when accessed at line 42"

  - hypothesis: "H2"
    result: "RULED_OUT"
    evidence: "timing logs show correct sequence"
```

## Phase 4: FIX

Address the ROOT CAUSE, not symptoms.

### Fix Checklist
- [ ] Root cause identified and documented
- [ ] Fix addresses root cause (not workaround)
- [ ] Regression test added
- [ ] No other code paths affected
- [ ] Debug code removed

### Good Fix
```typescript
// Root cause: user can be null when fetched fails silently
// Fix: Handle fetch failure explicitly
const user = await fetchUser(id);
if (!user) {
  throw new UserNotFoundError(id);
}
```

### Bad Fix (Workaround)
```typescript
// This hides the problem, doesn't fix it
const user = await fetchUser(id) || { name: "Unknown" };
```

## Defense in Depth

After fixing, add layers of protection:

### 1. Input Validation
```typescript
function processUser(user: User) {
  validateUser(user); // Throws if invalid
  // ... process
}
```

### 2. Early Returns
```typescript
function getDiscount(user: User | null) {
  if (!user) return 0;
  if (!user.isPremium) return 0;
  return user.discountRate;
}
```

### 3. Assertions at Boundaries
```typescript
async function fetchData(id: number) {
  assert(typeof id === "number", "ID must be a number");
  const data = await api.get(id);
  assert(data !== undefined, "API should return data");
  return data;
}
```

### 4. Condition-Based Waiting (Async)
```typescript
// Don't use arbitrary delays
// ❌ await sleep(1000);

// ✓ Wait for condition
await waitFor(() => element.isVisible());
```

## Output Format

```markdown
# Debug Report: [Issue Description]

## Observation
- **Error**: [exact error]
- **Expected**: [expected behavior]
- **Actual**: [actual behavior]
- **Reproducibility**: [always/sometimes/conditions]

## Hypotheses
1. [H1 - likelihood] - [description]
2. [H2 - likelihood] - [description]
3. [H3 - likelihood] - [description]

## Investigation
### H1: [description]
- Test: [how tested]
- Result: [CONFIRMED/RULED_OUT]
- Evidence: [what was found]

## Root Cause
[Clear description of the actual cause]

## Fix
- **File**: [path]
- **Change**: [description]
- **Test**: [regression test added]

## Prevention
- [Defensive measure 1]
- [Defensive measure 2]
```

## Examples

```bash
# Debug a specific error
/debug "TypeError: Cannot read property 'email' of undefined"

# Debug a test failure
/debug "test 'user login' fails intermittently"

# Debug performance issue
/debug "API response time increased 5x after last deploy"
```

## Anti-Patterns

### "Shotgun Debugging"
```
❌ Change random things until it works
```

### "Print-and-Pray"
```
❌ Add console.log everywhere without strategy
```

### "Works on My Machine"
```
❌ Dismiss bug without investigating environment differences
```

### "Quick Fix"
```
❌ Add workaround without understanding root cause
```

## Integration

### With TDD
```bash
# When test fails unexpectedly
/debug "Test started failing after feature X"
# Then fix with TDD approach
/tdd "Fix: [root cause identified]"
```

### With Loop
```bash
# Debug as part of iteration
/loop "Fix all flaky tests" --type feature
# Each iteration uses debugging skill for failures
```

## Usage

```bash
# Debug a specific error
/debug "TypeError: Cannot read property 'email' of undefined"

# Debug test failure
/debug "test 'user login' fails intermittently"

# Debug performance issue
/debug "API response time increased 5x after last deploy"

# Debug with context
/debug --file src/auth.ts --line 42 "null reference error"
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Cannot reproduce | Environment difference | Document exact steps, check env vars |
| Multiple root causes | Complex issue | Address one at a time, re-test |
| Fix introduces regression | Incomplete testing | Add more test cases before fix |
| Hypothesis exhausted | All ruled out | Gather more data, consider external factors |

**Fallback**: If systematic debugging fails after 3 hypotheses, escalate to `/ai-collab` for multi-perspective analysis.

## Related Skills

- `tdd` - Write regression tests after fixing
- `code-reviewer` - Review fix for quality
- `test-writer-fixer` - Add comprehensive test coverage
