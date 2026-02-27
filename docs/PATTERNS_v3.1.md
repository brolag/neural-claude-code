# Hidden Patterns v3.1.0

Advanced patterns leveraging Claude Code v2.1.x features with Neural Claude Code architecture.

## Overview

These 10 patterns were discovered by synthesizing new Claude Code v2.1.x capabilities with the existing Neural Claude Code system:

| Pattern | New Feature Used | Benefit |
|---------|------------------|---------|
| Research Swarm | `context: fork` | Parallel isolated research |
| Self-Improving Mesh | Skill hot-reload | Live expertise updates |
| Teleport Memory | `/teleport` command | Local ↔ cloud sync |
| Background Orchestrator | Ctrl+B backgrounding | Layered async loading |
| Wildcard Bash | Wildcard permissions | Autonomous loops |
| PV-Mesh | `context: fork` + Multi-AI | 3x faster consensus |
| Expertise Streaming | 10-min hook timeout | Real-time learning |
| Language Router | Language setting | Auto ES/EN detection |
| Deep Research | 600s timeout | Full article scraping |
| Clickable Memory | OSC 8 hyperlinks | Terminal navigation |

---

## Pattern 1: Research Swarm

**Command:** `/research-swarm <topic>`

Launch multiple research agents in parallel, each with isolated context.

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      RESEARCH SWARM                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Topic: $ARGUMENTS                                               │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ONE MESSAGE - FIVE PARALLEL FORKS           │    │
│  │                                                          │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │    │
│  │  │ ACADEMIC    │  │ PRACTICAL   │  │ CONTRARIAN  │      │    │
│  │  │ context:fork│  │ context:fork│  │ context:fork│      │    │
│  │  │ Research    │  │ Real-world  │  │ Devils      │      │    │
│  │  │ papers      │  │ examples    │  │ advocate    │      │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘      │    │
│  │                                                          │    │
│  │  ┌─────────────┐  ┌─────────────┐                       │    │
│  │  │ FUTURE      │  │ HISTORICAL  │                       │    │
│  │  │ context:fork│  │ context:fork│                       │    │
│  │  │ Emerging    │  │ Past        │                       │    │
│  │  │ trends      │  │ lessons     │                       │    │
│  │  └─────────────┘  └─────────────┘                       │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   SYNTHESIS PHASE                        │    │
│  │  • Consolidate findings from all 5 perspectives         │    │
│  │  • Identify consensus vs. contrarian views              │    │
│  │  • Extract actionable insights                          │    │
│  │  • Note areas needing more research                     │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### When to Use

- Broad topic research requiring multiple angles
- Competitive analysis
- Technology evaluation
- Market research

### Key Benefit

Each forked agent explores independently without contaminating other contexts. Findings are synthesized at the end for comprehensive coverage.

---

## Pattern 2: Self-Improving Agent Mesh

**Scripts:** `expertise-watcher.sh`, `expertise-streamer.sh`

When one agent learns something, all agents learn it instantly.

### Architecture

```
┌──────────────────────────────────────────────────────────┐
│              SELF-IMPROVING AGENT MESH                    │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  Agent A learns:          ──┐                             │
│  "User prefers async/await" │                             │
│                             ▼                             │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ Updates .claude/expertise/javascript.yaml            │ │
│  └─────────────────────────────────────────────────────┘ │
│                             │                             │
│         expertise-watcher.sh detects change               │
│                             │                             │
│                             ▼                             │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ Broadcasts via systemMessage to ALL active agents    │ │
│  │ "🧠 [javascript] New: User prefers async/await"      │ │
│  └─────────────────────────────────────────────────────┘ │
│                             │                             │
│     ┌───────────────────────┼───────────────────────┐    │
│     ▼                       ▼                       ▼    │
│  ┌──────┐               ┌──────┐               ┌──────┐  │
│  │Agent │               │Agent │               │Agent │  │
│  │  B   │               │  C   │               │  D   │  │
│  │learns│               │learns│               │learns│  │
│  └──────┘               └──────┘               └──────┘  │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

### Setup

```bash
# Start the watcher (background process)
./scripts/expertise-watcher.sh start

# Check status
./scripts/expertise-watcher.sh status

# Stop when done
./scripts/expertise-watcher.sh stop
```

### Key Benefit

Enables Claude Code's skill hot-reload for expertise files. One agent's learning immediately available to all.

---

## Pattern 3: Teleport Memory Bridge

**Command:** `/teleport-sync`

Synchronize memory state when teleporting between local CLI and cloud.

### Use Case

1. Start work locally (filesystem access)
2. Need web-heavy research → teleport to cloud
3. Cloud has better web access but no filesystem
4. Return with results → sync memory back

### Commands

```bash
# Before teleporting to cloud
/teleport-sync export
# → Copies JSON blob to clipboard

# In cloud: paste the blob to restore context

# After returning from cloud
/teleport-sync import "<blob>"

# Check sync status
/teleport-sync status
```

### Key Benefit

Enables hybrid execution: local CLI for file operations, cloud for web research, seamless memory continuity.

---

## Pattern 4: Background Morning Orchestrator

Enhanced session start with layered background loading.

### Implementation

The session-start.sh script now:

1. Loads expertise files in background
2. Consumes agent mesh broadcasts
3. Shows clickable inbox items with OSC 8 links
4. Loads facts with clickable file paths

### Key Benefit

Faster session startup. Heavy loading happens in background while Claude is already responsive.

---

## Pattern 5: Wildcard Bash Permissions

**Config:** `config/bash-permissions.yaml`

Auto-approve safe command patterns for truly autonomous loops.

### Approved Patterns

```yaml
# Testing (always safe)
- pytest, npm test, vitest, jest

# Linting (read-only)
- eslint, prettier --check

# Type checking
- tsc --noEmit

# Git (read-only)
- status, diff, log, branch, show

# Our scripts
- bash .claude/scripts/*.sh
```

### Denied Patterns

```yaml
# Destructive
- rm -rf, rm -r, rmdir

# Dangerous git
- push --force, reset --hard

# System modification
- chmod 777, sudo

# Remote execution
- curl | bash, wget | bash

# Database
- DROP DATABASE, TRUNCATE
```

### Key Benefit

Neural Loops can run unattended without constant permission prompts for safe operations.

---

## Pattern 6: Parallel Multi-AI Verification Mesh

**Command:** `/pv-mesh <problem>`

Run Claude and Codex simultaneously in parallel forks.

### Speed Comparison

| Approach | Time | Method |
|----------|------|--------|
| Sequential `/ai-collab` | 45-60s | One AI at a time |
| **Parallel `/pv-mesh`** | **15-20s** | Both simultaneous |

### AI Strengths

- **Codex**: Terminal operations, DevOps, practical implementation
- **Claude**: Accuracy, architecture, edge case handling

### Key Benefit

2x faster than sequential while maintaining true cognitive diversity (not just prompt variations).

---

## Pattern 7: Expertise Streaming Pipeline

**Script:** `expertise-streamer.sh`

Real-time expertise injection during active sessions (vs. queuing for next session).

### Difference from Watcher

| Watcher | Streamer |
|---------|----------|
| Queues updates | Injects immediately |
| For next session | During current session |
| Batch processing | Real-time |

### Usage

```bash
# Start streaming
./scripts/expertise-streamer.sh start

# Manual injection
./scripts/expertise-streamer.sh inject "🧠 Just learned: User prefers TypeScript"

# Consume pending (for hooks)
./scripts/expertise-streamer.sh consume
```

---

## Pattern 8: Language-Aware Skill Router

Automatic Spanish/English detection in capture workflows.

### Implementation

Skills now include:

```yaml
language: auto  # Detect from input
```

### Detection Logic

- Detects Spanish articles (el, la, los, las, un, una)
- Detects Spanish verbs (es, son, está, están)
- Checks for Spanish characters (ñ, ¿, ¡)
- Routes to appropriate language template

### Key Benefit

Bilingual users get automatic language routing without explicit flags.

---

## Pattern 9: 10-Minute Research Hooks

**Script:** `deep-research-hook.sh`

Leverage 600s hook timeout for deep web scraping during loops.

### Queue Format

```
TOPIC|URL1,URL2,URL3
```

### Process

1. Loop iteration completes
2. Hook runs with 10-minute timeout
3. Scrapes full articles (50KB each, 5KB text extracted)
4. Cross-references multiple sources
5. Results saved to `.claude/loop/research-results.md`

### Key Benefit

Deep research that would normally timeout can run as post-iteration hooks.

---

## Pattern 10: Clickable Memory Navigation

OSC 8 hyperlinks for terminal file navigation.

### Implementation

```bash
# OSC 8 format for clickable links
printf '\033]8;;file://%s\033\\%s\033]8;;\033\\\n' "$full_path" "$display_name"
```

### Key Benefit

Click on inbox items or facts directly in terminal to open them. Faster navigation than typing paths.

---

## Requirements

These patterns require Claude Code v2.1.5 or later with:

- `context: fork` support
- 10-minute hook timeouts (600s)
- Wildcard bash permissions
- OSC 8 hyperlink support
- Skill hot-reload capability

Check your version:

```bash
claude --version
```
