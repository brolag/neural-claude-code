# Lesson 4: CRAFT Framework

## Objective

Master the structured prompt format for complex autonomous tasks.

## What is CRAFT?

```
C - Context      → What is the current situation?
R - Requirements → What exactly needs to be done?
A - Actions      → What operations are allowed/forbidden?
F - Flow         → What are the execution steps?
T - Tests        → How do we verify completion?
```

## Why CRAFT?

Simple prompts work for simple tasks:
```
"Fix the typo in README.md"
```

But complex tasks need structure:
```
"Implement user authentication with login, registration,
password reset, email verification, session management,
and proper security measures"
```

Without structure, the AI might:
- Miss requirements
- Take unsafe actions
- Not know when it's done
- Go in circles

## CRAFT Template

```yaml
craft:
  context:
    description: |
      What project is this?
      What exists already?
      What's the current state?

    constraints:
      - Time/budget limits
      - Technical constraints
      - Security requirements

  requirements:
    objective: |
      What should exist when done?
      What problem does this solve?

    success_criteria:
      - Criterion 1: Tests pass
      - Criterion 2: Feature works
      - Criterion 3: No regressions

    out_of_scope:
      - Things NOT to do
      - Prevents scope creep

  actions:
    allowed:
      - read_files
      - write_files
      - run_tests

    forbidden:
      - delete_production_data
      - push_to_main
      - modify_secrets

  flow:
    steps:
      - "1. Explore and understand"
      - "2. Plan the changes"
      - "3. Implement one at a time"
      - "4. Test after each change"
      - "5. Validate all criteria"

  tests:
    automated:
      - "npm test → All pass"
      - "npm run lint → No errors"

    completion_promise: |
      <promise>CRAFT_COMPLETE</promise>
```

## The /craft Command

Generate a CRAFT prompt automatically:

```bash
/craft "Add user authentication with JWT"
```

This creates a structured prompt you can review and modify.

## Quick CRAFT (for simpler tasks)

```
Context:     Adding auth to a Next.js app with Prisma
Requirements: Users can login/register, protected routes
Actions:     Use existing User model, follow patterns
Flow:        1. Install deps 2. API routes 3. Middleware 4. Tests
Tests:       All auth tests pass → <promise>DONE</promise>
```

## Try It

Run the /craft command now:

```bash
/craft "Create a CLI tool that converts markdown to HTML"
```

Review the generated prompt. Notice:
- Context asks what you have
- Requirements are specific
- Actions have boundaries
- Flow has steps
- Tests define "done"

## Check

Confirm you understand:

1. CRAFT = Context + Requirements + Actions + Flow + Tests
2. Use for complex tasks (not simple fixes)
3. The `/craft` command generates the structure
4. You can modify the generated prompt before running

## Next

**Lesson 5: 6 Core Areas** - What every specification needs to cover.

```bash
/course lesson 5
```

---
*Completion: Mark this lesson done and continue*
