# Neural Claude Code Plugin

The master Claude Code framework - a self-improving plugin system with autonomous loops, multi-agent orchestration, and meta-agent creation.

## Context
- Owner: Alfredo Bonilla
- Role: Creator and maintainer
- Collaborators: Open source (MIT license)
- GitHub: github.com/brolag/neural-claude-code
- Version: 1.15.0

## Tech Stack
- **Languages**: Bash/Shell, Markdown, Python, JavaScript
- **Core**: Claude Code CLI plugin system
- **Hooks**: Shell scripts (stop hooks, session management)
- **Memory**: JSON/JSONL file-based persistence
- **Schemas**: JSON Schema validation
- **Skills**: Markdown-based skill definitions with YAML frontmatter
- **Docs**: GitHub Pages (Jekyll via _config.yml)

## Key Commands
```bash
# Installation
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash

# Setup
./scripts/setup-hooks.sh

# Skills management
bash scripts/install-skills.sh
bash scripts/manage-skills.sh

# Autonomous loops
bash scripts/loop-v3.sh

# Squad management
bash scripts/squad/*

# Memory and indexing
bash scripts/index-learnings.sh
node scripts/event-indexer.js

# TTS
bash scripts/tts-toggle.sh

# Plugin sync
bash scripts/sync-plugin.sh
```

## Architecture

```
neural-claude-code-plugin/
  agents/              # Agent definitions (Markdown)
  commands/            # Slash commands (Markdown with YAML frontmatter)
  config/              # Configuration files
  docs/                # Documentation (GitHub Pages)
    tutorials/         # Step-by-step guides
    how-to/            # Task-focused recipes
    reference/         # Command reference
    explanation/       # Architecture docs
  examples/            # Example configurations
  hooks/               # Git/session hooks
  output-styles/       # Response formatting templates
  rules/               # Behavioral rules and constraints
  schemas/             # JSON Schema definitions
  scripts/             # Automation scripts
    hooks/             # Stop hooks, session hooks
    neural-loop/       # Autonomous iteration system
    squad/             # Multi-agent squad scripts
    status-lines/      # Terminal status displays
    tts/               # Text-to-speech integration
    utils/             # Shared utilities
  skills/              # Skill definitions
  status-lines/        # Status line configurations
  templates/           # File templates for agents, skills, etc.
```

### Key Systems
- **Neural Loop**: Autonomous coding sessions with stop-hook test feedback
- **Neural Squad**: Multi-agent orchestration (2-agent system with standup, tasks)
- **CRAFT Framework**: Structured prompts for autonomous agents
- **Memory System**: Hot (context) / Warm (JSON files) / Cold (archives)
- **Skills Manager**: Install, enable/disable skills on demand
- **KPI Tracking**: Plan/Review Velocity, Autonomy, Loop State metrics
- **Slop Detection**: Anti-pattern scanning and auto-fix

## Current Status
Active development and maintenance - version 1.15.0.
Open source framework used across multiple projects.
Sister projects: neural-codex (Codex CLI) and neural-open-code-plugin (OpenCode CLI).
