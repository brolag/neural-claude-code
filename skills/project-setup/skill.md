---
name: project-setup
description: Initialize Neural Claude Code architecture in any project
trigger: /setup, "setup claude", "init project", "initialize"
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Project Setup Skill

Initialize the Neural Claude Code architecture with Agent Expert capabilities.

## Usage

```bash
/setup                # Standard setup (default)
/setup --minimal      # Quick start with basics only
/setup --full         # Complete Neural architecture
/setup --dry-run      # Preview without creating files
/setup --force        # Overwrite existing files
```

## Trigger Conditions

- User says "setup claude", "init project", or "initialize"
- New project without `.claude/` directory
- Project with incomplete structure detected

## Setup Levels

### Minimal (`--minimal`)

```
.claude/
├── CLAUDE.md              # Project context
└── settings.json          # Basic config
```

### Standard (default)

```
.claude/
├── CLAUDE.md
├── settings.json
├── settings.local.json    # Personal (gitignored)
├── data/
│   └── current-session.json
├── memory/
│   ├── events/
│   └── active_context.md
├── expertise/
│   └── project.yaml
└── agents/
    └── project-expert.md
```

### Full (`--full`)

```
.claude/
├── CLAUDE.md
├── settings.json
├── settings.local.json
├── data/
│   └── current-session.json
├── memory/
│   ├── events/
│   ├── facts/
│   ├── active_context.md
│   └── context-cache.json
├── expertise/
│   ├── project.yaml
│   ├── codebase.yaml
│   └── domain.yaml
├── agents/
│   ├── project-expert.md
│   ├── code-expert.md
│   └── generated/
├── skills/
│   └── generated/
├── commands/
│   └── dynamic/
├── rules/
│   └── code-style.md
├── eval/
├── logs/
└── scripts/
```

## Execution Steps

1. **Detect project type** from package.json, Cargo.toml, etc.
2. **Check existing structure** - skip files that exist (unless --force)
3. **Create directories** in order
4. **Generate CLAUDE.md** with project-specific content
5. **Create expertise file** with detected patterns
6. **Initialize session** via session-start hook
7. **Update .gitignore** with local paths
8. **Display quick start guide**

## Project Type Detection

| File | Type | Customization |
|------|------|---------------|
| package.json | Node.js | npm scripts, modules |
| tsconfig.json | TypeScript | Type patterns |
| requirements.txt | Python | Package structure |
| Cargo.toml | Rust | Modules, traits |
| go.mod | Go | Package layout |
| .obsidian/ | Second Brain | PARA, MOCs |

## Generated Templates

### CLAUDE.md

```markdown
# {Project Name}

This project uses **Neural Claude Code** with Agent Experts.

## Project Overview
{Auto-detected or user description}

## Tech Stack
{Auto-detected}

## Quick Reference
| Need | Command |
|------|---------|
| Multi-AI input | `/ai-collab <problem>` |
| Sync expertise | `/meta:improve project` |
| System health | `/health` |
```

### project.yaml

```yaml
domain: {project_type}
version: 1
last_updated: {timestamp}

project:
  name: "{name}"
  type: "{type}"
  root: "{cwd}"

understanding:
  structure:
    src: "{src_location}"
    tests: "{tests_location}"
  key_files: []
  patterns: []
  conventions: {}

lessons_learned: []
```

### project-expert.md

```markdown
---
name: project-expert
description: Expert on THIS specific project
tools: Read, Write, Edit, Glob, Grep
model: sonnet
---

# Project Expert Agent

Expert on THIS specific project. Executes AND learns.

## Agent Expert Pattern

1. **READ** → Load `.claude/expertise/project.yaml`
2. **VALIDATE** → Check key_files exist, patterns apply
3. **EXECUTE** → Perform task with expertise
4. **IMPROVE** → Update expertise with learnings
```

## Post-Setup Actions

```bash
# 1. Add to .gitignore
echo ".claude/settings.local.json" >> .gitignore
echo ".claude/data/" >> .gitignore
echo ".claude/memory/events/" >> .gitignore
echo ".claude/logs/" >> .gitignore

# 2. Initialize session
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"
bash "$PLUGIN_ROOT/scripts/hooks/session-start.sh"

# 3. Run initial expertise scan
Task: "Scan project and populate expertise file" (subagent: project-expert)
```

## Output Format

```markdown
## Setup Complete

**Level**: {level}
**Project Type**: {type}
**Agent Name**: {agent_name}

### Created
- .claude/CLAUDE.md
- .claude/expertise/project.yaml
- .claude/agents/project-expert.md
- ...

### Next Steps
1. Review .claude/CLAUDE.md and customize
2. Run `/meta:improve project` after first task
3. Use `/ai-collab` for complex problems

### Commands Available
| Command | Purpose |
|---------|---------|
| `/evolve` | Self-improvement cycle |
| `/ai-collab` | Multi-AI collaboration |
| `/health` | System health check |
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Files exist | Previous setup | Use `--force` to overwrite |
| No write permission | Directory permissions | Check permissions |
| Plugin not found | Missing neural-claude-code-plugin | Install plugin globally |
| Invalid project type | Unrecognized structure | Defaults to generic setup |

## Safety Constraints

- Never overwrite existing files without `--force`
- Always create .gitignore entries for local files
- Validate JSON/YAML before writing
- Offer `--dry-run` for preview
