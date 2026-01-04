# Check Todo Progress

Check the current status of todo.md and report progress.

## Usage

```
/todo-check
```

## Prompt

Read `todo.md` in the project root and report:

1. **Overall Progress**: Count completed vs total tasks
2. **Current Phase**: Which phase is in progress
3. **Next Tasks**: What needs to be done next
4. **Blockers**: Any failed validations

Format the output:

```
## Todo Progress

**Task**: {task name}
**Progress**: {completed}/{total} ({percentage}%)
**Current Phase**: {phase}

### Completed
- [x] Task 1
- [x] Task 2

### In Progress
- [ ] Task 3 (current)

### Remaining
- [ ] Task 4

### Next Steps
1. Complete current task
2. Run validation
3. Move to next task
```

If todo.md doesn't exist, suggest running `/todo-new`.
