# Start Neural Loop

Start an autonomous iteration loop that continues until completion or max iterations.

## Usage

```
/loop-start "<task description>" [--max <n>] [--promise "<text>"]
```

## Arguments

- `task description` - The task for Claude to work on iteratively
- `--max <n>` - Maximum iterations (default: 20)
- `--promise "<text>"` - Completion phrase to output when done (default: LOOP_COMPLETE)

## Examples

```
/loop-start "Implement user authentication with tests" --max 30 --promise "AUTH_COMPLETE"

/loop-start "Fix all TypeScript errors in src/" --max 10

/loop-start "Build REST API with CRUD, validation, and tests" --promise "API_DONE"
```

## Prompt

Parse the user's arguments to extract:
1. The task description (required)
2. Max iterations (look for --max, default 20)
3. Completion promise (look for --promise, default LOOP_COMPLETE)

Execute:
```bash
bash .claude/scripts/neural-loop/start.sh "$TASK" "$MAX" "$PROMISE"
```

Then begin working on the task. The Stop hook will intercept exit attempts and re-inject the prompt until:
- You output the completion promise phrase
- Max iterations are reached
- User runs /loop-cancel

## How It Works

1. You work on the task
2. When you finish responding, the Stop hook fires
3. Tests run automatically (if detected)
4. If completion promise not found, prompt is re-injected with test results
5. Continue iterating until done

## Best Practices

1. **Clear success criteria** - Include testable goals
2. **Use TDD** - Write tests first, then implement
3. **Set reasonable max** - Start with 10-20 iterations
4. **Atomic tasks** - Break into small steps
