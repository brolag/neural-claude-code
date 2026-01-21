---
description: Cancel Loop - Stop an active autonomous loop
allowed-tools: Bash
---

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

## Output Format

```markdown
## Loop Cancelled

**Iterations Completed**: [n] of [max]
**Reason**: User requested cancellation
**State**: Saved to .claude/loop/state.json

### Summary
- Tasks completed: [list]
- Tasks remaining: [list]

### To Resume
Run `/loop-start` with the remaining task.
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No active loop | Loop already finished | Check `/loop-status` |
| Script not found | Plugin not synced | Run `/sync project` |
| State file locked | Concurrent access | Wait and retry |

**Fallback**: Manually delete `.claude/loop/state.json` to force reset.
