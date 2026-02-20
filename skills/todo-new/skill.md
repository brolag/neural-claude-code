---
name: todo-new
description: Create a structured todo.md for autonomous loop execution. Use when: starting a multi-step autonomous task with 3+ distinct steps, before /loop, task has clear phases that need tracking. Don't use when: single-step tasks, quick fixes, hotfixes, interactive conversational work.
trigger: create a plan, make a todo, /todo-new, before loop
allowed-tools: Write, Read
---

# Todo New

Creates a structured `todo.md` that guides autonomous loop execution.

## Output Format

Creates `todo.md` in project root:

```markdown
# Todo: [Task Title]

**Created**: [date]
**Promise**: [what done looks like]
**Max iterations**: [n]

## Tasks

### Phase 1: [Setup/Research]
- [ ] Task 1.1
- [ ] Task 1.2

### Phase 2: [Implementation]
- [ ] Task 2.1
- [ ] Task 2.2

### Phase 3: [Validation]
- [ ] Tests pass
- [ ] No TypeScript errors
- [ ] Overseer approved

## Done When
[Single clear statement of completion]

## Notes
[Constraints, edge cases, things to watch out for]
```

## Skip When

- Single-step task (just do it directly)
- Hotfix (no time for planning)
- User just wants a quick answer

## Done When

- [ ] `todo.md` created with all phases populated
- [ ] Done When criteria are specific and verifiable
