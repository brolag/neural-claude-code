# Memory Upgrade: Engram

By default, Neural Claude Code uses Claude Code's native auto-memory (zero config). For cross-session persistent memory with full-text search, install Engram.

## What Engram Adds

- Memory that persists across sessions and context compactions
- Full-text search across all saved observations
- Session summaries and timeline
- MCP-based (runs as a local server)

## Install

Add to your `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "engram@engram": true
  },
  "extraKnownMarketplaces": {
    "engram": {
      "source": {
        "source": "github",
        "repo": "Gentleman-Programming/engram"
      }
    }
  }
}
```

Then restart Claude Code. It will install the plugin automatically.

## Usage

Engram tools become available in Claude Code:

- `mem_save` — save a decision, discovery, or convention
- `mem_search` — search past observations
- `mem_context` — get context for current project
- `mem_session_summary` — summarize current session

## When to Upgrade

- You work on the same project across many sessions
- You want to recall decisions made weeks ago
- You coordinate between multiple AI agents
- You want session summaries saved automatically

## When NOT to Upgrade

- You're a casual user (auto-memory is enough)
- You don't want external plugin dependencies
- You prefer manual notes over automated memory
