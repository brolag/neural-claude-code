# Monitoring Quick Reference

## Layer Stack

```
L4: NOTIFICATIONS   ← Alerts when events happen
L3: CONVERSATION    ← Track message/token counts
L2: ACTIVITY        ← File changes, git status
L1: PROCESS         ← Is agent running?
```

---

## Layer 1: Process Detection

```bash
# Check for Claude processes
ps aux | grep -E "claude|anthropic" | grep -v grep

# Check for any AI CLI
ps aux | grep -E "claude|codex|gemini" | grep -v grep

# Quick health check
if pgrep -f "claude" > /dev/null; then
    echo "✅ Running"
else
    echo "❌ Not running"
fi
```

---

## Layer 2: Activity Monitoring

```bash
# Watch git status (every 5 seconds)
watch -n 5 'git status --short'

# Watch git status + recent commits
watch -n 5 'git status --short && echo "---" && git log --oneline -3'

# Monitor file changes (macOS)
fswatch -r . | while read f; do echo "Changed: $f"; done

# Visual monitoring
lazygit    # or gitui
```

---

## Layer 3: Conversation State

Track these metrics:

| Metric | What | Warning | Critical |
|--------|------|---------|----------|
| Time since activity | Staleness | > 5 min | > 15 min |
| Token consumption | Budget | > 80% | > 95% |
| Consecutive failures | Stability | > 3 | > 5 |
| Iteration count | Progress | > 75% max | = max |

---

## Layer 4: Notification Hooks

### macOS

```json
{
  "hooks": {
    "Stop": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "osascript -e 'display notification \"Agent completed\" with title \"Claude\"'"
      }]
    }]
  }
}
```

### Linux

```json
{
  "hooks": {
    "Stop": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "notify-send 'Claude' 'Agent completed'"
      }]
    }]
  }
}
```

### With Sound

```bash
# macOS
afplay /System/Library/Sounds/Glass.aiff

# Linux
paplay /usr/share/sounds/freedesktop/stereo/complete.oga
```

---

## Minimal Setup

```bash
# Terminal 1: Agent
claude

# Terminal 2: Monitor
watch -n 5 'git status --short'
```

---

## Standard Setup

```bash
# Terminal 1: Agent
claude

# Terminal 2: Lazygit
lazygit

# Add notification hook (one-time)
# Edit ~/.claude/settings.json
```

---

## Parallel Agent Monitoring

```
┌─────────────────┬─────────────────┐
│   Worktree 1    │   Worktree 2    │
│   Claude Code   │   Claude Code   │
├─────────────────┴─────────────────┤
│              Lazygit               │
│    (sees all worktree commits)     │
└───────────────────────────────────┘
```

---

## Quick Commands

| Task | Command |
|------|---------|
| Is agent running? | `pgrep -f claude` |
| Watch file changes | `watch -n 5 'git status'` |
| Visual monitoring | `lazygit` |
| Notify on done | Add Stop hook |

---

*"Monitor early, catch problems early."*
