# Cancel Neural Loop

Stop an active Neural Loop iteration.

## Usage

```
/loop-cancel
```

## Prompt

Cancel the active Neural Loop:

```bash
bash .claude/scripts/neural-loop/cancel.sh
```

Confirm to the user that the loop was cancelled and report iterations completed.

## When to Use

- Task is complete but promise wasn't detected
- Loop is stuck or making no progress
- Need to change approach
- Want to take manual control
