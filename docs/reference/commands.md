# Reference: Commands

Complete list of all slash commands.

---

## Getting Started

| Command | Description |
|---------|-------------|
| `/onboard` | Interactive guided tour for new users |
| `/help` | List all available commands |

---

## Skills & Configuration

| Command | Description | Example |
|---------|-------------|---------|
| `/install-skills` | Install skills (interactive) | `/install-skills` |
| `/manage-skills` | Enable/disable/update skills | `/manage-skills` |
| `/tts` | Toggle TTS audio and summaries | `/tts off` |
| `/tts on` | Enable both audio + summary | `/tts on` |
| `/tts audio off` | Mute voice, keep text | `/tts audio off` |
| `/tts summary off` | Voice only, no text blocks | `/tts summary off` |

---

## Core Commands

| Command | Description |
|---------|-------------|
| `/evolve` | Run self-improvement cycle |
| `/health` | System health check |
| `/question` | Answer any question |

---

## Memory Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/remember <fact>` | Save to memory | `/remember API uses JWT` |
| `/recall <query>` | Search memory | `/recall database` |
| `/forget <id>` | Remove from memory | `/forget jwt-fact` |

---

## Development Commands

| Command | Description |
|---------|-------------|
| `/debug` | Systematic 4-phase debugging |
| `/tdd` | Test-Driven Development workflow |
| `/slop-scan` | Detect technical debt and code smells |
| `/slop-fix` | Auto-fix safe slop issues |
| `/overseer` | Review PR/diff quality before merge |

---

## Loop Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/loop "task"` | Unified loop (v3) | `/loop "Fix all errors"` |
| `/loop "task" --afk` | AFK mode (sandbox) | `/loop "Build API" --afk` |
| `/loop "task" --once` | Single iteration | `/loop "Quick fix" --once` |
| `/loop-plan "task"` | Plan before loop | `/loop-plan "Add auth"` |
| `/loop-start "task"` | Start loop (legacy) | `/loop-start "task" --max 20` |
| `/loop-status` | Check progress | `/loop-status` |
| `/loop-cancel` | Stop active loop | `/loop-cancel` |

**Loop Options:**
- `--max <n>` - Maximum iterations (default: 20)
- `--promise "<text>"` - Completion phrase
- `--type <type>` - Loop type: feature, coverage, lint, entropy
- `--afk` - Run in Docker sandbox
- `--once` - Single iteration only

---

## Todo Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/todo-new "task"` | Create todo.md | `/todo-new "Build API"` |
| `/todo-check` | Check progress | `/todo-check` |

---

## AI Collaboration Commands

| Command | Description |
|---------|-------------|
| `/ai-collab <problem>` | Get all AI perspectives |
| `/pv-mesh <problem>` | Parallel Multi-AI (3x faster) |
| `/plan-execute <task>` | Opus plans + Gemini executes |
| `/route <task>` | Get routing recommendation |
| `/pv <problem>` | Parallel verification (single AI) |

---

## Research & Learning Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/learn <url>` | Learn from any source (auto-detect) | `/learn https://...` |
| `/research <topic>` | Deep multi-source research | `/research "React vs Vue"` |
| `/research-swarm <topic>` | Parallel research agents | `/research-swarm "AI trends"` |

---

## Teleport Commands

| Command | Description |
|---------|-------------|
| `/teleport` | Switch to cloud Claude |
| `/teleport-sync export` | Export memory for cloud |
| `/teleport-sync import` | Import memory from cloud |

---

## Meta Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/meta:agent <name>` | Create agent | `/meta:agent security-checker` |
| `/meta:skill <name>` | Create skill | `/meta:skill api-testing` |
| `/meta:prompt <name>` | Create command | `/meta:prompt deploy` |
| `/meta:improve <name>` | Sync expertise | `/meta:improve project` |

---

## Worktree Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/wt-new <name>` | Create worktree | `/wt-new feature-auth` |
| `/wt-list` | List worktrees | `/wt-list` |
| `/wt-merge <name>` | Merge worktree | `/wt-merge feature-auth` |
| `/wt-clean <name>` | Remove worktree | `/wt-clean feature-auth` |
