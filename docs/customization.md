# Customization

## Adding Your Own Hooks

Create a script in `~/.claude/hooks/` (not in neural/):

```bash
#!/bin/bash
# ~/.claude/hooks/my-custom-hook.sh
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
# Your logic here
exit 0  # allow, exit 2 = block
```

Add to settings.json:
```json
{
  "matcher": "Bash",
  "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/my-custom-hook.sh", "timeout": 3000 }]
}
```

## Adding Your Own Skills

Create a directory in `~/.claude/skills/your-skill/`:

```markdown
---
name: your-skill
description: "What it does in one line"
allowed-tools: Read, Write, Edit, Bash
---

# /your-skill

Instructions for Claude to follow when this skill is invoked.
```

## Adding Your Own Rules

Create a file in `~/.claude/rules/`:

```markdown
---
name: your-rule
---
One to three lines describing the rule. Keep it short — every line costs tokens.
```

## Modifying Neural Defaults

- **Edit hooks**: `~/.claude/hooks/neural/*.sh` — modify patterns, add exceptions
- **Edit rules**: `~/.claude/rules/neural/*.md` — adjust wording or add constraints
- **Edit skills**: `~/.claude/skills/forge/SKILL.md` — customize the pipeline

## Removing Neural Components

To remove specific parts without full uninstall:
- Remove a hook: delete its .sh file from `~/.claude/hooks/neural/` and its entry from settings.json
- Remove a skill: delete its directory from `~/.claude/skills/`
- Remove a rule: delete its .md file from `~/.claude/rules/neural/`
