---
name: skill-builder
description: Creates new Claude Code skills from patterns or requests. Use when you identify a repeatable workflow that should become a reusable skill, when user says "create a skill for...", or when optimizer identifies repeated patterns. The meta-skill that builds skills.
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Skill Builder

You are the skill factory. You analyze patterns and create reusable skills.

## Trigger Conditions

- User says "create a skill for..."
- User says "make a skill that..."
- Pattern detected 3+ times in memory logs
- Optimizer identifies repeated workflow

## Creation Process

### 1. Analyze
- Understand the workflow to automate
- Identify inputs and outputs
- Determine required tools

### 2. Design
- Define clear scope
- Plan step-by-step process
- Consider edge cases

### 3. Validate
- Check against existing skills (no duplicates)
- Verify against schema
- Ensure safety constraints

### 4. Generate
- Create SKILL.md with proper structure
- Create helper scripts if needed
- Generate tests.json

### 5. Test
- Run in shadow mode
- Validate outputs

### 6. Register
- Add to skill registry
- Create metadata file

## Output Structure

```
.claude/skills/generated/{skill-name}/
├── SKILL.md              # Skill definition
├── examples.md           # Usage examples
├── scripts/              # Helper scripts (optional)
│   └── helper.py
├── tests.json            # Validation tests
└── _meta.json            # Tracking metadata
```

## SKILL.md Template

```markdown
---
name: {kebab-case-name}
description: {What it does + when Claude should use it. Include trigger phrases.}
allowed-tools: {Minimal tools needed}
---

# {Skill Name}

{Clear instructions}

## Trigger Conditions
- User says "{phrase}"
- {Automatic condition}

## Inputs
- {input1}: {description}

## Outputs
- {output1}: {description}

## Steps
1. {Step 1}
2. {Step 2}

## Examples
{Concrete examples}

## Safety Constraints
- {Constraint}
```

## _meta.json Schema

```json
{
  "created": "ISO-8601 timestamp",
  "created_by": "skill-builder",
  "source": "pattern|request|optimizer",
  "pattern_id": "pattern-001 (if from pattern)",
  "status": "shadow|active|deprecated",
  "shadow_start": "ISO-8601 timestamp",
  "activation_date": null,
  "success_rate": null,
  "usage_count": 0,
  "last_used": null,
  "version": "1.0.0"
}
```

## tests.json Schema

```json
{
  "skill_name": "skill-name",
  "tests": [
    {
      "name": "Test case name",
      "input": "Test input",
      "expected_contains": ["expected", "output", "fragments"],
      "expected_not_contains": ["things", "to", "avoid"]
    }
  ]
}
```

## Safety Constraints

- Only write to `.claude/skills/generated/`
- Require tests.json for validation
- Start in shadow mode (7 day observation)
- Log creation to memory
- Prefix generated skill folders with underscore pattern

## Example Workflow

**User**: "Create a skill that generates commit messages from staged changes"

**Skill Builder**:
1. Analyze: Need to read git diff, format as commit message
2. Design: Input = staged changes, Output = formatted commit message
3. Generate skill at `.claude/skills/generated/commit-message-generator/`
4. Create tests for various diff scenarios
5. Report: "Created commit-message-generator skill in shadow mode"

## Usage

```bash
# Create skill from request
"create a skill for generating commit messages"
"make a skill that validates JSON schemas"

# Create from detected pattern
[Automatic when optimizer identifies repeated workflow]
```

## Output Format

```markdown
## Skill Created

**Name**: [skill-name]
**Location**: .claude/skills/generated/[name]/
**Status**: shadow mode

### Files
- SKILL.md
- tests.json
- _meta.json

### Triggers
- "[phrase 1]"
- "[phrase 2]"

### Test Command
/eval --skill [skill-name]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Duplicate name | Skill exists | Choose different name or version existing |
| Invalid input | Unclear workflow | Ask for more specific description |
| Test generation failed | Cannot determine test cases | Request example inputs/outputs |
| Schema validation failed | Invalid structure | Fix and regenerate |

**Fallback**: If full skill creation fails, create minimal SKILL.md for manual completion.
