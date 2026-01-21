---
description: Loop Status - Check current autonomous loop state
allowed-tools: Bash, Read
---

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

## Output Format

```markdown
## Neural Loop Status

**Status**: [ACTIVE | STOPPED | NONE]

### Current Loop
- **Task**: [description]
- **Type**: [feature|coverage|lint|entropy]
- **Iteration**: [n] of [max]
- **Promise**: [completion phrase]
- **Started**: [timestamp]

### Progress
- Features complete: [n] of [total]
- Last activity: [description]

### Files
- State: .claude/loop/state.json
- Features: .claude/loop/features.json
- Progress: .claude/loop/progress.txt
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No state file | Loop never started | Run `/loop-start` |
| Corrupt state | JSON parse error | Delete state file, restart |
| Stale state | Loop crashed | Check progress.txt for last activity |

**Fallback**: If state file is corrupt, read progress.txt for status.
