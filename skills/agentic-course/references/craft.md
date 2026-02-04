# Quick Reference: CRAFT Framework

```
C = CONTEXT
    What is the current situation?
    What exists already?
    What constraints apply?

R = REQUIREMENTS
    What exactly needs to be done?
    What does success look like?
    What is OUT of scope?

A = ACTIONS
    What operations are allowed?
    What is forbidden?
    What rules apply?

F = FLOW
    What are the steps?
    In what order?
    How to iterate?

T = TESTS
    How to verify completion?
    What automated checks?
    What is the completion promise?
```

## Quick Template

```yaml
context: |
  [Current state and constraints]

requirements: |
  [What must be achieved]

actions: |
  allowed: [list]
  forbidden: [list]

flow: |
  1. Step one
  2. Step two
  3. Step three

tests: |
  - npm test passes
  - npm run lint clean
  <promise>DONE</promise>
```

## When to Use

- Tasks > 30 min
- Multiple files/steps
- Need clear success criteria
- Running autonomous loops

---
*Quick reference from /course ref craft*
