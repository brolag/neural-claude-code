---
description: Meta-prompt that creates new prompts/commands
allowed-tools: Read, Write, Glob, Grep
argument-hint: <prompt-name> <purpose> [--dry-run] [--global]
---

# Meta-Prompt: Prompt Generator

You are a meta-prompt - a prompt that creates other prompts.

## Purpose
Generate new slash commands following the established agentic prompt format.

## Arguments
- `$ARGUMENTS` - Format: `<prompt-name> <purpose description>`
- `--dry-run` - Preview the generated prompt without writing to disk
- `--global` - Create in global commands (`~/.claude/commands/`)

## Generation Protocol

### Step 1: Analyze Request
Extract from arguments:
- **Name**: The command name (kebab-case)
- **Purpose**: What this prompt should accomplish
- **Domain**: Which area of the second brain it serves

### Step 2: Study Existing Patterns
Read existing commands to understand the style:
```
.claude/commands/*.md
```

### Step 3: Generate Prompt Structure

Create prompt with this format:
```markdown
---
description: [Concise description for autodiscovery]
allowed-tools: [Minimal required tools]
argument-hint: [Optional arguments]
---

# [Command Name]

[One-line purpose]

## Usage
[How to use this command]

## Process
[Numbered steps the agent follows]

## Output
[What the command produces]
```

### Step 4: Write to Commands Directory

**If `--dry-run`**:
```
📝 DRY RUN - Would create: .claude/commands/<name>.md

---
[Full generated prompt content here]
---

To create this file, run without --dry-run
```

**If `--global`**:
Save to: `~/.claude/commands/<name>.md`

**Default**:
Save to: `.claude/commands/<name>.md`

### Step 5: Report Creation
Output:
- File path created
- Command usage example
- Suggested improvements

## Quality Standards

Generated prompts must:
- Be focused on ONE specific task
- Have clear, numbered process steps
- Include minimal required tools only
- Follow existing naming conventions
- Be immediately usable

## Example Usage

```
/meta/prompt daily-energy "Quick morning energy assessment with recommendations"
```

Creates: `.claude/commands/daily-energy.md`
