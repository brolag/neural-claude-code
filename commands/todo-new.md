# Create Todo Workflow

Generate a structured todo.md for a long-running task, optimized for neural-loop.

## Usage

```
/todo-new "<task name>"
```

## Examples

```
/todo-new "Build REST API for user management"
/todo-new "Migrate database to PostgreSQL"
/todo-new "Implement authentication system"
```

## Prompt

Create a new todo workflow based on `templates/todo-workflow.md`:

1. Read the template
2. Replace placeholders:
   - `{TASK_NAME}` with the user's task
   - `{DATE}` with today's date
   - `{PROMISE}` with `TASK_COMPLETE`
   - `{MAX}` with `20`

3. Analyze the task and generate:
   - 3-5 measurable success criteria
   - Phase 1: Setup tasks (2-4 items)
   - Phase 2: Core implementation tasks (3-6 items)
   - Phase 3: Polish tasks (2-3 items)
   - Appropriate validation commands for the project type

4. Write to `todo.md` in the project root

5. Suggest running:
   ```
   /loop-start "Follow todo.md step by step" --max 20 --promise "TASK_COMPLETE"
   ```

## Tips

- Each task should be atomic and completable in one iteration
- Include validation steps between phases
- Be specific about expected outcomes
- Include test commands where applicable
