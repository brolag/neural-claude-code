# Neural Claude Code Plugin

A self-improving agentic system for Claude Code that implements the **Agent Expert** pattern - agents that execute AND learn.

## Installation

```bash
# From GitHub
claude plugin install github:brolag/neural-claude-code-plugin --scope user

# From local path
claude plugin install ~/Sites/neural-claude-code-plugin --scope user
```

## Features

### Meta-Agentics (The System That Builds The System)

| Component | Command/Agent | Purpose |
|-----------|---------------|---------|
| Meta-Prompt | `/meta/prompt` | Creates new commands |
| Meta-Improve | `/meta/improve` | Syncs expertise files with schema validation |
| Meta-Eval | `/meta/eval` | Test agents against golden tasks |
| Meta-Brain | `/meta/brain` | System health dashboard |
| Meta-Agent | `meta-agent` | Creates new agents |
| Meta-Skill | `meta-skill` | Creates new skills |

### Universal Commands

| Command | Purpose |
|---------|---------|
| `/question <anything>` | Answer any question (project, web, general) |
| `/meta/prompt <name> <purpose>` | Create a new command |
| `/meta/improve <name>` | Sync agent expertise with reality |
| `/meta/eval <name>` | Run automated tests |
| `/meta/brain` | View system health and status |

### Multi-AI Collaboration

| Agent | Strength | Best For |
|-------|----------|----------|
| `codex` | Terminal-Bench #1 | DevOps, long sessions, CLI |
| `gemini` | 1501 Elo | Algorithms, free tier |
| `multi-ai` | All three | Consensus, high-stakes decisions |

#### Intelligent Routing

The `multi-ai` agent uses intelligent routing to pick the best AI:

```yaml
task_classification:
  type: [algorithm|architecture|devops|review|debug|explain]
  complexity: [simple|moderate|complex]
  risk_level: [low|medium|high|critical]
```

| Condition | Routes To | Reason |
|-----------|-----------|--------|
| Algorithm problems | Gemini | 1501 Elo (highest) |
| Architecture decisions | Claude | 80.9% SWE-bench |
| DevOps/CLI tasks | Codex | Terminal-Bench leader |
| Critical decisions | ALL | Maximum validation |

### Cognitive Agents

| Agent | Purpose |
|-------|---------|
| `cognitive-amplifier` | Complex decisions, bias detection |
| `insight-synthesizer` | Cross-domain pattern discovery |
| `framework-architect` | Transform content → frameworks |

### Skills

| Skill | Triggers |
|-------|----------|
| `deep-research` | "research", "investigate", "deep dive" |
| `content-creation` | "create content", "write post" |
| `project-setup` | "setup claude", "init project" |
| `memory-system` | "remember", "recall", "forget" |
| `worktree-manager` | "/wt-new", "/wt-list", "/wt-merge" |
| `pattern-detector` | "/evolve", "find patterns" |

## The Agent Expert Pattern

Traditional agents forget. Agent Experts learn.

```
┌─────────────────────────────────────┐
│       AGENT EXPERT CYCLE            │
│                                     │
│  1. READ    → Load expertise file   │
│  2. VALIDATE → Check against code   │
│  3. EXECUTE  → Perform task         │
│  4. IMPROVE  → Update expertise     │
│                                     │
└─────────────────────────────────────┘
```

### How It Works

1. **Expertise Files** (`.claude/expertise/*.yaml`) store an agent's "mental model"
2. **Before tasks**, agents read their expertise file first
3. **After tasks**, agents update their expertise with learnings
4. **Over time**, agents become true experts on your codebase

### Confidence Scoring

Patterns track their effectiveness:

```yaml
patterns:
  - pattern: "Use PARA methodology for organization"
    confidence: 0.85  # (successes / (successes + failures + 1))
    successes: 17
    failures: 3
    last_used: "2024-12-18"
```

Low-confidence patterns (< 0.3) are auto-pruned with `--prune`.

### Schema Validation

All expertise files are validated against `schemas/expertise.schema.json`:
- Required fields: `domain`, `version`, `last_updated`, `understanding`
- Confidence scores: 0.0-1.0 range
- Valid date formats

## Tiered Memory Architecture

### Scope Tiers

```
┌─────────────────────────────────────────────────┐
│                 GLOBAL MEMORY                    │
│            ~/.claude/memory/                     │
│  - User preferences across all projects          │
│  - Universal patterns and learnings              │
└─────────────────────────────────────────────────┘
                      ↓ inherits
┌─────────────────────────────────────────────────┐
│                PROJECT MEMORY                    │
│           .claude/memory/                        │
│  - Project-specific facts                        │
│  - Codebase patterns                             │
└─────────────────────────────────────────────────┘
```

### Temperature Tiers

| Tier | Location | Access Speed | Use For |
|------|----------|--------------|---------|
| Hot | Context window | Instant | Current session |
| Warm | `.claude/memory/` | Seconds | Recent facts/events |
| Cold | Archives, CLAUDE.md | Manual | Historical data |

## Project Setup

After installing, run in any project:

```
"setup claude" or "init project"
```

This creates:
- `.claude/` directory structure
- Project-specific agents
- Expertise files for your codebase

## Quick Start

```bash
# Install the plugin
claude plugin install github:brolag/neural-claude-code-plugin --scope user

# In any project, initialize
> setup claude

# Check system health
> /meta/brain

# Ask questions
> /question where is the authentication logic?

# Create new agents
> Create an agent for reviewing database schemas

# Sync expertise after changes
> /meta/improve project

# Run tests
> /meta/eval knowledge-management
```

## Architecture

```
neural-claude-code-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── meta/
│   │   ├── prompt.md        # Create prompts (--dry-run)
│   │   ├── improve.md       # Sync expertise (--prune)
│   │   ├── eval.md          # Run tests
│   │   └── brain.md         # System status
│   └── question.md          # Universal Q&A
├── agents/
│   ├── meta-agent.md        # Creates agents
│   ├── cognitive-amplifier.md
│   ├── insight-synthesizer.md
│   ├── framework-architect.md
│   ├── codex.md             # OpenAI Codex
│   ├── gemini.md            # Google Gemini
│   └── multi-ai.md          # Orchestrator + routing
├── skills/
│   ├── meta-skill/          # Creates skills
│   ├── deep-research/
│   ├── content-creation/
│   ├── project-setup/
│   ├── memory-system/       # Tiered memory
│   ├── worktree-manager/
│   └── pattern-detector/
├── schemas/
│   └── expertise.schema.json # Validation schema
├── templates/
│   └── expertise.template.yaml
├── hooks/
│   └── post-commit-improve.md
├── LICENSE
├── CHANGELOG.md
└── README.md
```

## New in v1.1.0

- **Expertise Schema Validation**: JSON Schema for expertise files
- **Confidence Scoring**: Track pattern effectiveness (0.0-1.0)
- **Auto-Pruning**: Remove low-confidence patterns with `--prune`
- **`/meta/eval`**: Automated testing against golden tasks
- **`/meta/brain`**: System health dashboard
- **Git-triggered learning**: Auto-improve on commits
- **Tiered Memory**: Global + project memory hierarchy
- **Intelligent AI Routing**: Task-based routing matrix
- **`--dry-run` mode**: Preview changes before writing

## Requirements

- Claude Code CLI
- Optional: Codex CLI (`codex`) for multi-AI
- Optional: Gemini CLI (`gemini`) for multi-AI

## License

MIT

## Author

Alfredo Bonilla ([@brolag](https://github.com/brolag))
