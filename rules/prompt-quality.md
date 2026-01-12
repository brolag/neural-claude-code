# Prompt Quality Standards

All new commands, skills, and agents MUST follow CRISP-E framework standards.

## Required Sections

### For Commands (`.claude/commands/*.md`)

```markdown
---
description: Brief description of what the command does
allowed-tools: Tool1, Tool2, Tool3
---

# Command Name

[Main content explaining the command]

## Usage

```bash
# Primary usage
/command-name <required-arg> [optional-arg]

# With options
/command-name --flag value

# Example
/command-name "actual example"
```

## Output Format

```markdown
## Command: [action]

**Result**: [description]

### Details
[structured output]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Error 1 | Why it happens | How to fix |
| Error 2 | Why it happens | How to fix |
| Error 3 | Why it happens | How to fix |

**Fallback**: What to do if the command fails completely.
```

### For Skills (`.claude/skills/*/skill.md`)

```markdown
---
name: skill-name
description: What the skill does and when Claude should use it
trigger: /command, "trigger phrase"
allowed-tools: Tool1, Tool2
---

# Skill Name

[Main content]

## Usage

```bash
/skill-command "argument"
/skill-command --option value
```

## Output Format

```markdown
## Skill: [action]

**Status**: [result]

### Details
[structured output]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Error 1 | Why it happens | How to fix |

**Fallback**: Alternative approach if skill fails.
```

## Quality Checklist

Before committing any new prompt, verify:

- [ ] Has YAML frontmatter with `description:`
- [ ] Has `## Usage` with bash code examples
- [ ] Has `## Output Format` with markdown template
- [ ] Has `## Error Handling` table with 3-5 common errors
- [ ] Has `**Fallback**` behavior documented
- [ ] Examples use realistic values (not placeholders)
- [ ] Error resolutions are actionable

## Anti-Patterns to Avoid

1. **Vague descriptions** - Be specific about what and when
2. **Missing examples** - Always show real usage
3. **No error handling** - Every command can fail
4. **Placeholder text** - Use actual examples
5. **Missing fallback** - What if it completely fails?

## Enforcement

The `/evolve` command includes prompt linting that checks for these standards.

Run `/prompt-review <file>` to validate a prompt before committing.
