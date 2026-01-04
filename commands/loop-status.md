# Neural Loop Status

Check the status of the current Neural Loop.

## Usage

```
/loop-status
```

## Prompt

Check the Neural Loop state:

```bash
if [ -f .claude/scripts/neural-loop/.neural-loop-state.json ]; then
    cat .claude/scripts/neural-loop/.neural-loop-state.json | jq .
else
    echo "No Neural Loop state found"
fi
```

Report to the user:
- Whether a loop is active
- Current iteration / max iterations
- The task prompt
- Completion promise
- When it started
- Stopped reason (if stopped)

If no state file exists, inform the user that no loop has been started.
