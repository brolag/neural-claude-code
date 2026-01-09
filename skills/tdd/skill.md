---
name: tdd
description: Test-Driven Development skill enforcing RED-GREEN-REFACTOR cycle. Use when implementing features, fixing bugs, or any code changes that require tests.
trigger: /tdd
context: fork
agent: general-purpose
---

# TDD Skill - Test-Driven Development

Enforces strict RED-GREEN-REFACTOR cycle based on obra/superpowers patterns.

## Philosophy

> "Delete code written before tests."

Tests ALWAYS come first. Code written before tests is suspect and should be rewritten test-first.

## The Cycle

```
┌─────────────────────────────────────────────────────────────┐
│                     RED-GREEN-REFACTOR                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌─────────┐        ┌─────────┐        ┌─────────┐         │
│   │   RED   │ ────▶ │  GREEN  │ ────▶ │ REFACTOR│ ────┐   │
│   │  Write  │        │  Write  │        │  Clean  │     │   │
│   │  test   │        │  code   │        │  code   │     │   │
│   └─────────┘        └─────────┘        └─────────┘     │   │
│        ▲                                                 │   │
│        └─────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Phase 1: RED
1. Write a test for the desired behavior
2. Run the test - it MUST fail
3. If it passes, the test is wrong (delete and rewrite)
4. Failure message should be clear and specific

### Phase 2: GREEN
1. Write MINIMAL code to pass the test
2. No extra features
3. No premature optimization
4. Just make it pass

### Phase 3: REFACTOR
1. Clean up the code
2. Remove duplication
3. Improve naming
4. Extract helpers if needed
5. Run tests again - must still pass

## Mandatory Rules

### Before Writing Code
- [ ] Test exists for the behavior
- [ ] Test fails with clear error
- [ ] Test name describes expected behavior

### While Writing Code
- [ ] Only write code that makes a failing test pass
- [ ] No speculative code ("might need later")
- [ ] No untested branches

### After Writing Code
- [ ] All tests pass
- [ ] Code is refactored
- [ ] No commented-out code
- [ ] No console.log/print statements

## Task Decomposition

Break work into bite-sized tasks (2-5 minutes each):

```yaml
tasks:
  - id: "test-1"
    description: "Write test for user creation"
    test_file: "tests/user.test.ts"
    expected_failure: "createUser is not defined"
    time_estimate: "2 min"

  - id: "impl-1"
    description: "Implement createUser"
    code_file: "src/user.ts"
    depends_on: "test-1"
    time_estimate: "3 min"

  - id: "refactor-1"
    description: "Extract validation helper"
    depends_on: "impl-1"
    time_estimate: "2 min"
```

## Test Structure

### Naming Convention
```
test("[unit] should [expected behavior] when [condition]")
```

Examples:
- `test("createUser should throw when email is invalid")`
- `test("calculateTotal should return 0 when cart is empty")`
- `test("auth middleware should reject expired tokens")`

### Arrange-Act-Assert (AAA)
```typescript
test("createUser should hash password before saving", async () => {
  // Arrange
  const userData = { email: "test@example.com", password: "plain" };

  // Act
  const user = await createUser(userData);

  // Assert
  expect(user.password).not.toBe("plain");
  expect(user.password).toMatch(/^\$2[aby]?\$/); // bcrypt pattern
});
```

## Debugging Integration

When tests fail unexpectedly, use systematic debugging:

### 4-Phase Root Cause Process
1. **Observe**: What exactly failed? What was expected vs actual?
2. **Hypothesize**: What could cause this? List possibilities.
3. **Test**: Verify each hypothesis with targeted tests.
4. **Fix**: Address root cause, not symptoms.

### Defense in Depth
- Add assertions at multiple levels
- Validate inputs AND outputs
- Log state at key points
- Use condition-based waiting for async

## Examples

### Feature Implementation
```bash
# Start TDD for new feature
/tdd "Add user email verification"

# Output:
# Task 1: Write test - verification email sent on signup
# Task 2: Implement email sending (minimal)
# Task 3: Write test - verification link validates token
# Task 4: Implement token validation
# Task 5: Refactor - extract token service
```

### Bug Fix
```bash
# TDD approach to bug fix
/tdd "Fix: users can login with expired tokens"

# Output:
# Task 1: Write failing test reproducing the bug
# Task 2: Implement fix (minimal)
# Task 3: Add regression tests for edge cases
# Task 4: Refactor if needed
```

### With Loop Integration
```bash
# Run TDD in a loop
/loop "Implement shopping cart with TDD" --type feature

# Each iteration:
# 1. Pick next untested behavior
# 2. Write failing test
# 3. Implement minimal code
# 4. Refactor
# 5. Commit
```

## Anti-Patterns to Avoid

### "Test After" (Wrong)
```
❌ Write code → Write tests → Discover bugs → Fix
```

### "Test First" (Correct)
```
✓ Write test → Watch fail → Write code → Watch pass → Refactor
```

### Other Anti-Patterns
- Testing implementation details (test behavior, not internals)
- Tests that depend on each other (each test should be isolated)
- Tests that test the framework (test YOUR code)
- Mocking everything (integration tests matter too)

## Verification Checklist

Before marking a TDD task complete:

- [ ] All new code has corresponding tests
- [ ] All tests pass
- [ ] Test failures were observed before implementation
- [ ] Code was refactored after tests passed
- [ ] No untested code paths
- [ ] Tests are readable and maintainable

## Output

TDD sessions produce:
- Test files in appropriate `tests/` or `__tests__/` directory
- Implementation files with minimal, tested code
- Commit history showing RED-GREEN-REFACTOR cycle

## Related Skills

- `code-reviewer` - Reviews test coverage
- `test-writer-fixer` - Focuses on test maintenance
- `debugging` - Systematic issue resolution
