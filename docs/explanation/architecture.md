# Explanation: Architecture

How Neural Claude Code works as a system.

---

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    NEURAL CLAUDE CODE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                     CLAUDE CODE CLI                        │   │
│  │  (The AI that runs commands and writes code)              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              │                                   │
│           ┌──────────────────┼──────────────────┐               │
│           ▼                  ▼                  ▼               │
│  ┌─────────────────┐ ┌─────────────┐ ┌─────────────────┐       │
│  │   EXPERTISE     │ │   MEMORY    │ │    HOOKS        │       │
│  │   (.yaml)       │ │   (.json)   │ │    (.sh)        │       │
│  │                 │ │             │ │                 │       │
│  │ Domain knowledge│ │ Facts       │ │ Session start   │       │
│  │ Patterns        │ │ Events      │ │ Stop actions    │       │
│  │ Lessons         │ │ Sessions    │ │ Auto-testing    │       │
│  └─────────────────┘ └─────────────┘ └─────────────────┘       │
│           │                  │                  │               │
│           └──────────────────┴──────────────────┘               │
│                              │                                   │
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    SKILLS & AGENTS                         │   │
│  │  (Reusable capabilities and specialized assistants)       │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    MULTI-AI LAYER                          │   │
│  │  Claude + Codex (optional)                                │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. Expertise System

**Purpose:** Domain knowledge that persists across sessions.

**How it works:**
- YAML files in `.claude/expertise/`
- Loaded at session start via hooks
- Updated automatically as Claude learns
- Versioned for tracking changes

**Key insight:** Without expertise, Claude forgets everything. With expertise, it accumulates knowledge over time.

### 2. Memory System

**Purpose:** Facts, events, and patterns that persist.

**Tiers:**

| Tier | Storage | Speed | Contents |
|------|---------|-------|----------|
| Hot | Context window | Instant | Current conversation |
| Warm | JSON files | Seconds | Facts, recent events |
| Cold | Archives | Manual | Old sessions, logs |

**Key insight:** Memory is separate from expertise. Facts are specific pieces of information; expertise is accumulated understanding.

### 3. Hooks System

**Purpose:** Execute scripts at key moments.

**Hooks available:**
- `SessionStart` - When Claude starts
- `UserPromptSubmit` - When user sends message
- `Stop` - When Claude stops responding

**Key insight:** Hooks enable automation without modifying Claude Code itself.

### 4. Skills & Agents

**Purpose:** Encapsulated capabilities.

| Type | Complexity | Example |
|------|------------|---------|
| Command | Simple | `/deploy` |
| Skill | Medium | `/tdd` workflow |
| Agent | Complex | Security reviewer |

**Key insight:** Skills are reusable workflows; agents are specialized personas with domain expertise.

---

## Data Flow

```
User Request
     │
     ▼
┌─────────────────┐
│  SessionStart   │ ← Load expertise, memory, context
│  Hook           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Claude Code    │ ← Process with loaded knowledge
│  Processing     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Task Execution │ ← May use skills, agents, or multi-AI
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Stop Hook      │ ← Run tests, TTS, logging
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Learning       │ ← Update expertise, log events
│  (if triggered) │
└─────────────────┘
```

---

## File Relationships

```
.claude/
│
├── expertise/manifest.yaml     ─── Controls ──▶ expertise/*.yaml
│
├── memory/facts/               ─── Queried by ──▶ /recall command
│
├── scripts/session-start.sh    ─── Loads ──▶ expertise, memory
│
├── skills/*/skill.md           ─── Triggered by ──▶ Commands
│
└── settings.json               ─── Configures ──▶ hooks
```

---

## Extension Points

### Adding Expertise
Create `.claude/expertise/new-domain.yaml` → Auto-loaded at session start

### Adding Memory
Use `/remember` → Creates `.claude/memory/facts/*.json`

### Adding Skills
Create `.claude/skills/new-skill/skill.md` → Available immediately

### Adding Hooks
Add to `.claude/scripts/` → Register in `settings.json`

---

## Design Principles

1. **Files over databases** - Everything is human-readable files
2. **Hooks over patches** - Extend via hooks, don't modify core
3. **Progressive enhancement** - Works without any configuration
4. **Explicit over implicit** - Knowledge is visible in YAML/JSON
