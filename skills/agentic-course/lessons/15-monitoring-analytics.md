# Lesson 15: Monitoring & Analytics

## Objective

Gain real-time visibility into what your autonomous agents are doing, catch problems early, and know when they're done.

## The Blind Spot Problem

Running agents without monitoring is like flying blind:

```
WITHOUT MONITORING
--------------------------------------------
Agent starts
    ↓
[SILENCE]     ← What's happening?
    ↓
[MORE SILENCE] ← Is it stuck? Working? Waiting?
    ↓
Eventually check → Hours wasted or success?
```

**Common failures:**
- Agent stuck in an infinite loop - you don't know
- Agent waiting for input - you're not checking
- Agent hit a blocker 10 minutes ago - still running (and burning tokens)
- Agent finished an hour ago - you're still waiting

---

## The Four Monitoring Layers

Build visibility from the bottom up:

```
┌─────────────────────────────────────────────────────────────┐
│  L4: NOTIFICATIONS                                          │
│      "Agent finished!" / "Error detected!"                  │
├─────────────────────────────────────────────────────────────┤
│  L3: CONVERSATION STATE                                     │
│      Messages: 45 | Tokens: 125K | Last: 2 min ago          │
├─────────────────────────────────────────────────────────────┤
│  L2: ACTIVITY TRACKING                                      │
│      Files changed | Git commits | Test results             │
├─────────────────────────────────────────────────────────────┤
│  L1: PROCESS DETECTION                                      │
│      Is the agent process running? PID? CPU usage?          │
└─────────────────────────────────────────────────────────────┘
```

---

### Layer 1: Process Detection

**Goal**: Know if your agent is even running.

```bash
# Check for Claude Code processes
ps aux | grep -E "claude|anthropic" | grep -v grep

# More specific - check for node processes running Claude
ps aux | grep "claude" | grep -v grep | awk '{print $2, $11}'

# Watch CPU usage of Claude processes
top -l 1 | grep -E "claude|node"
```

**Quick health check script:**

```bash
#!/bin/bash
# is-agent-running.sh

if pgrep -f "claude" > /dev/null; then
    echo "✅ Agent is running (PID: $(pgrep -f claude))"
else
    echo "❌ No agent process found"
fi
```

---

### Layer 2: Activity Tracking

**Goal**: See what the agent is actually doing.

**Option A: Watch git status**

```bash
# Refresh every 5 seconds
watch -n 5 'git status --short && echo "---" && git log --oneline -3'
```

**Option B: Monitor file changes**

```bash
# macOS
fswatch -r . | while read f; do echo "$(date +%H:%M:%S) Changed: $f"; done

# Linux
inotifywait -m -r . --format '%T %w%f' --timefmt '%H:%M:%S'
```

**Option C: Use visual git tools**

```bash
# Lazygit - excellent for monitoring multiple worktrees
lazygit

# GitUI - alternative
gitui
```

**The Lazygit Pattern for Parallel Agents:**

```
┌─────────────────────┬─────────────────────┐
│   Worktree 1        │   Worktree 2        │
│   (Claude Code)     │   (Claude Code)     │
│   feature-auth      │   feature-api       │
├─────────────────────┴─────────────────────┤
│              Terminal 3                    │
│              Lazygit                       │
│   (sees commits from both worktrees)       │
└───────────────────────────────────────────┘
```

Benefits:
- See commits from all agents in one view
- Visual diff of changes in real-time
- Catch conflicts before they become merge problems
- Quick staging and committing if needed

---

### Layer 3: Conversation State

**Goal**: Track the conversation's progress and resource consumption.

**Key metrics to track:**

| Metric | What it tells you |
|--------|------------------|
| Message count | How much back-and-forth |
| Token usage | Cost and context window health |
| Last activity time | Is it stuck? |
| Current state | Working / waiting / error |

**Session tracking file:**

```json
{
  "session_id": "abc123",
  "started_at": "2026-02-05T10:00:00Z",
  "messages": 45,
  "tokens_used": 125000,
  "tokens_budget": 200000,
  "last_activity": "2026-02-05T10:30:00Z",
  "state": "working",
  "current_task": "Implementing auth module"
}
```

**Warning thresholds:**

| Metric | Warning | Critical |
|--------|---------|----------|
| Time since activity | > 5 min | > 15 min |
| Consecutive failures | > 3 | > 5 |
| Token consumption | > 80% budget | > 95% |
| Iteration count | > 75% max | = max |

---

### Layer 4: Notifications

**Goal**: Get alerted when important events happen.

**Using Claude Code hooks:**

```json
{
  "hooks": {
    "Stop": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "notify-send 'Claude finished in $(basename $PWD)'"
      }]
    }]
  }
}
```

**Common notification triggers:**

| Event | Notification |
|-------|--------------|
| Agent completes task | Desktop notification + optional sound |
| Agent hits error | Alert with error summary |
| Agent waiting for input | "Input needed" notification |
| Cost threshold exceeded | "Budget warning" alert |
| No activity timeout | "Agent may be stuck" warning |

**macOS notification:**

```bash
osascript -e 'display notification "Agent completed!" with title "Claude Code"'
```

**Linux notification:**

```bash
notify-send "Claude Code" "Agent completed!"
```

**Cross-platform with sound:**

```bash
# Play a sound when done
afplay /System/Library/Sounds/Glass.aiff  # macOS
paplay /usr/share/sounds/freedesktop/stereo/complete.oga  # Linux
```

---

## Complete Monitoring Setup

### Minimal Setup (5 minutes)

```bash
# Terminal 1: Run your agent
claude

# Terminal 2: Watch activity
watch -n 5 'git status --short'
```

### Standard Setup (15 minutes)

```bash
# Terminal 1: Agent
claude

# Terminal 2: Activity monitor
lazygit

# Add stop hook for notifications
# In .claude/settings.json:
```

```json
{
  "hooks": {
    "Stop": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "osascript -e 'display notification \"Agent finished\" with title \"Claude\"'"
      }]
    }]
  }
}
```

### Advanced Setup (30 minutes)

Add session tracking and analytics:

```bash
# Session start hook - log session begin
# Session stop hook - log duration, tokens, outcome
# Activity hook - track every tool use
# Error hook - alert on failures
```

---

## Key Principles

| Principle | Why |
|-----------|-----|
| **Start simple** | watch + git status is often enough |
| **Layer incrementally** | Add complexity only when needed |
| **Fail loud** | Silent failures are the worst |
| **Automate alerts** | Don't rely on manual checking |
| **Track what matters** | Time, tokens, outcomes |

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| **No monitoring at all** | Blind to agent state | At minimum use `watch git status` |
| **Over-monitoring** | Information overload | Focus on actionable metrics |
| **Manual polling** | Wastes your time | Use notifications |
| **Ignoring warnings** | Problems compound | Set hard limits that stop execution |
| **No timeout** | Infinite loops possible | Always set max iterations |

---

## Try It

Set up monitoring for your next autonomous task:

### Exercise 1: Basic Monitoring

1. Open two terminals
2. Terminal 1: Start an agent task
3. Terminal 2: Run `watch -n 5 'git status && git log --oneline -3'`
4. Observe changes in real-time

### Exercise 2: Notification Hook

Add this to your `.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "echo 'Agent completed at $(date)' >> ~/.claude/agent-log.txt"
      }]
    }]
  }
}
```

Run an agent task and verify the log gets written.

### Exercise 3: Parallel Monitoring

If you have worktrees:
1. Start agents in 2 different worktrees
2. Open lazygit in a third terminal
3. Watch commits appear from both agents

---

## Check

Answer these questions:

1. Can you tell if an agent is running right now?
   - If no → Set up Layer 1 (process detection)

2. Can you see what files changed in the last 5 minutes?
   - If no → Set up Layer 2 (activity tracking)

3. Do you know how many tokens the current session has used?
   - If no → Set up Layer 3 (conversation state)

4. Will you be notified when the agent finishes?
   - If no → Set up Layer 4 (notifications)

---

## Next

Now that you can monitor what agents are doing, you're ready to learn how to make them improve over time.

**Next lesson**: Continuous Improvement - build systems that get better automatically.

```bash
/course lesson 16
```

---

## Quick Reference

```
MONITORING LAYERS
=================

L1: PROCESS DETECTION
  ps aux | grep claude

L2: ACTIVITY TRACKING
  watch -n 5 'git status'
  lazygit

L3: CONVERSATION STATE
  Track: messages, tokens, last_activity

L4: NOTIFICATIONS
  Hook on Stop event
  osascript / notify-send

WARNING THRESHOLDS
==================
Time since activity: > 5 min (warn), > 15 min (critical)
Token consumption: > 80% (warn), > 95% (critical)
Consecutive failures: > 3 (warn), > 5 (critical)
```

---

*"You can't improve what you can't measure." - Peter Drucker*
