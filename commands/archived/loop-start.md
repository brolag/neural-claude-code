---
description: Start Neural Loop - Autonomous iteration until completion
allowed-tools: Bash, Read, Write
---

# Start Neural Loop

Start an autonomous iteration loop that continues until completion or max iterations.

## Version 2.0

Neural Loop v2 incorporates learnings from:
- **Ralph Wiggum** (Matt Pocock) - 11 tips for autonomous coding
- **Anthropic Engineering** - Effective harnesses for long-running agents
- **Vercel v0** - Multi-system pipeline architecture

## Usage

```
/loop-start "<task description>" [options]
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--max <n>` | 20 | Maximum iterations |
| `--promise "<text>"` | LOOP_COMPLETE | Completion phrase |
| `--sandbox` | false | Run in Docker sandbox (AFK safety) |
| `--type <type>` | feature | Loop type: feature, coverage, lint, entropy |
| `--init` | false | Run /loop-init first to generate features.json |

## Examples

```bash
# Basic feature loop
/loop-start "Implement user authentication with tests" --max 30

# With Docker sandbox for AFK work
/loop-start "Refactor database layer" --sandbox --max 50

# Test coverage loop
/loop-start "Increase test coverage to 80%" --type coverage --max 20

# Linting cleanup loop
/loop-start "Fix all ESLint errors" --type lint

# Initialize first, then start
/loop-start "Build REST API with CRUD" --init --promise "API_DONE"
```

## Prompt

Parse the user's arguments to extract:
1. Task description (required)
2. Max iterations (--max, default 20)
3. Completion promise (--promise, default LOOP_COMPLETE)
4. Sandbox mode (--sandbox, default false)
5. Loop type (--type, default feature)
6. Initialize first (--init, default false)

Execute:
```bash
bash .claude/scripts/neural-loop/start.sh "$TASK" "$MAX" "$PROMISE" "$TYPE" "$SANDBOX"
```

## How It Works (v2)

### Iteration Flow
```
┌─────────────────────────────────────────────────────────────┐
│                    NEURAL LOOP v2                            │
├─────────────────────────────────────────────────────────────┤
│  1. Read features.json → Pick next incomplete feature        │
│  2. Work on SINGLE feature (small steps)                     │
│  3. Run feedback loops (types, tests, lint)                  │
│  4. Mark feature passes: true in features.json               │
│  5. Append to progress.txt                                   │
│  6. Commit changes                                           │
│  7. Stop hook checks for <promise>COMPLETE</promise>         │
│  8. If not complete → re-inject prompt with context          │
└─────────────────────────────────────────────────────────────┘
```

### Key Principles (from Ralph Wiggum)

1. **Agent picks the task** - Claude decides priority, not strict order
2. **Progress file for memory** - Cheaper than re-exploring codebase
3. **Promise-based exit** - Output `<promise>COMPLETE</promise>` when done
4. **Single feature per iteration** - Prevents context exhaustion
5. **Small steps** - Context rot makes large tasks worse
6. **Prioritize risky tasks** - Architectural work first

### Files Used

| File | Purpose |
|------|---------|
| `.claude/loop/features.json` | Feature tracking with passes field |
| `.claude/loop/progress.txt` | Human-readable iteration log |

## Loop Types

### feature (default)
Work through features.json items sequentially by priority.

### coverage
Target test coverage percentage. Use `/loop-coverage` for specialized version.

### lint
Fix linting errors one at a time. Use `/loop-lint` for specialized version.

### entropy
Clean up code smells. Use `/loop-entropy` for specialized version.

## Docker Sandbox (AFK Safety)

For unsupervised AFK loops, use --sandbox:

```bash
/loop-start "Big refactor" --sandbox --max 50
```

This runs Claude Code inside a Docker container for safety.

## Best Practices

### From Ralph Wiggum
1. **Start HITL, then go AFK** - Learn the loop behavior first
2. **Define scope explicitly** - Vague tasks risk infinite loops
3. **Use feedback loops** - Types, tests, linting as guardrails
4. **Take small steps** - Quality over speed
5. **Prioritize risky tasks** - Architecture first, polish last
6. **Fight entropy** - Leave codebase better than you found it

### Safety
- Always set --max to cap iterations
- Use --sandbox for AFK work
- Use /loop-cancel if stuck
- Check git status between iterations

## Related Commands

- `/loop-init` - Initialize features.json before starting
- `/loop-status` - Check current loop state
- `/loop-cancel` - Stop active loop
- `/loop-coverage` - Specialized coverage loop
- `/loop-lint` - Specialized linting loop
- `/loop-entropy` - Specialized entropy cleanup loop

## Output Format

```markdown
## Neural Loop Started

**Task**: [description]
**Type**: [feature|coverage|lint|entropy]
**Max Iterations**: [n]
**Promise**: [completion phrase]
**Sandbox**: [enabled|disabled]

### Initial State
- Features loaded: [n] (if using features.json)
- Tests status: [passing|failing|none]
- Git status: [clean|dirty]

### Progress
Iteration 1: Starting...
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Script not found | Plugin not synced | Run `/sync project` |
| features.json missing | Not initialized | Run `/loop-init` first or use `--init` |
| Docker not found | Sandbox mode without Docker | Install Docker or disable sandbox |
| Task too vague | No clear completion criteria | Add specific success criteria |

**Fallback**: If start script fails, work directly with manual iteration tracking.
