# Neural Loop

Autonomous iteration system for Claude Code. Our implementation of the [Ralph Wiggum pattern](https://ghuntley.com/ralph/).

## What It Does

Neural Loop allows Claude Code to run autonomously for extended periods by:
1. Intercepting session exit attempts via Stop hook
2. Re-injecting the original prompt with context
3. Including test results from previous iteration
4. Continuing until completion promise or max iterations

## Components

| File | Purpose |
|------|---------|
| `neural-loop.sh` | Stop hook - intercepts exit, re-injects prompt |
| `start.sh` | Starts a loop session |
| `cancel.sh` | Cancels active loop |
| `test-on-stop.sh` | Auto-runs tests, feeds results to loop |

## Installation

### Add to Stop Hook

In your `.claude/settings.local.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "bash .claude/scripts/neural-loop/test-on-stop.sh",
          "timeout": 60
        }]
      },
      {
        "hooks": [{
          "type": "command",
          "command": "bash .claude/scripts/neural-loop/neural-loop.sh",
          "timeout": 10
        }]
      }
    ]
  }
}
```

### Add Commands

Copy `commands/loop-*.md` to your `.claude/commands/` directory.

## Usage

### Start a Loop

```
/loop-start "Implement user authentication with tests" --max 30 --promise "AUTH_COMPLETE"
```

**Options:**
- `--max <n>` - Maximum iterations (default: 20)
- `--promise "<text>"` - Phrase that signals completion

### Check Status

```
/loop-status
```

### Cancel Loop

```
/loop-cancel
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                      Neural Loop Flow                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  /loop-start "task" ──► Claude works ──► Stop hook fires    │
│                              ▲                    │          │
│                              │                    ▼          │
│                              │         test-on-stop.sh       │
│                              │              (run tests)      │
│                              │                    │          │
│                              │                    ▼          │
│                              │         neural-loop.sh        │
│                              │         (check state)         │
│                              │                    │          │
│                              │         ┌──────────┴──────┐   │
│                              │         ▼                 ▼   │
│                              │    [continue]         [done]  │
│                              │         │                 │   │
│                              │         ▼                 ▼   │
│                              └── re-inject          exit     │
│                                  prompt             normally │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Best Practices

1. **Clear completion criteria** - Be specific about what "done" looks like
2. **Set max iterations** - Always limit to prevent runaway loops
3. **Use TDD** - Write tests first; loop continues until they pass
4. **Atomic tasks** - Break work into small, verifiable steps

## Test Runner Support

The `test-on-stop.sh` script auto-detects:

| Project Type | Detection | Command |
|--------------|-----------|---------|
| Node.js | `package.json` with `test` script | `npm test` |
| Rust | `Cargo.toml` | `cargo test` |
| Python | `pyproject.toml` or `pytest.ini` | `pytest` |
| Go | `go.mod` | `go test ./...` |
| Make | `Makefile` with `test` target | `make test` |

## State File

Loop state is stored in `.neural-loop-state.json`:

```json
{
  "active": true,
  "prompt": "Your task...",
  "max_iterations": 20,
  "completion_promise": "DONE",
  "iteration": 5,
  "started_at": "2025-01-04T12:00:00Z",
  "stopped_reason": null
}
```

## Tips

- Use `/loop-status` to check progress mid-session
- Combine with `/todo-new` for structured workflows
- Test results are automatically fed into the next iteration
- Telegram notifications alert you when loops complete or fail
