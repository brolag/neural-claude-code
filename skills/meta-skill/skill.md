---
description: Skill that creates other skills. Use when a repeatable workflow should become a skill, when user says "create a skill for...", or when pattern-detector identifies a common workflow.
allowed-tools: Read, Write, Glob, Grep
---

# Meta-Skill: Skill Generator

Create new skills from patterns, requests, or identified workflows.

## When Claude Should Use This

- User mentions "create a skill for...", "make this a skill"
- Pattern-detector identifies repeatable workflow
- A complex process should be autodiscovered
- Converting a command to a more powerful skill

## Skill Creation Protocol

### Step 1: Analyze the Workflow
Understand:
- **Purpose**: What does this skill accomplish?
- **Triggers**: What phrases should activate it?
- **Process**: What are the steps?
- **Files**: What supporting files are needed?

### Step 2: Study Existing Skills
Read existing skills for patterns:
```
.claude/skills/*/SKILL.md
```

### Step 3: Create Skill Directory Structure

```
.claude/skills/<skill-name>/
├── SKILL.md           # Main skill definition
├── expertise.yaml     # Mental model (for self-improvement)
├── templates/         # Reusable templates (optional)
└── scripts/           # Helper scripts (optional)
```

### Step 4: Generate SKILL.md

```markdown
---
description: [Specific triggers for autodiscovery]
allowed-tools: [Minimal required tools]
---

# [Skill Name] Skill

[One-line purpose]

## When Claude Should Use This

- [Trigger phrase 1]
- [Trigger phrase 2]
- [Context when relevant]

## Expertise File
This skill maintains a mental model at:
`expertise.yaml` (in this directory)

Read first, validate, then execute.

## Capabilities

### [Capability 1]
[Process steps]

### [Capability 2]
[Process steps]

## Self-Improvement

After using this skill, update expertise.yaml with:
- Patterns that worked well
- Edge cases discovered
- Improved approaches
- User preferences learned

## Output Locations
[Where results are stored]
```

### Step 5: Generate Expertise File

```yaml
# [Skill Name] Expertise
# Mental model - auto-updated

domain: [skill domain]
version: 1
last_updated: [timestamp]

patterns:
  successful: []
  failed: []

user_preferences: []

optimizations_discovered: []

common_requests: []
```

### Step 6: Report Creation
Output:
- Skill directory path
- Files created
- Trigger phrases
- Usage examples

## Usage

```bash
# Create skill from request
"create a skill for generating commit messages"

# Create skill from pattern
"make this workflow a skill"

# Triggered by pattern-detector
[Automatic when patterns identified]
```

## Output Format

```markdown
## Skill Created

**Name**: [skill-name]
**Location**: .claude/skills/[name]/
**Status**: shadow mode (7 days)

### Files Created
- SKILL.md - Main definition
- expertise.yaml - Learning model

### Trigger Phrases
- "[phrase 1]"
- "[phrase 2]"

### Usage Examples
```
/[command] [args]
```

### Next Steps
1. Test the skill manually
2. Review after shadow period
3. Activate when confident
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Duplicate skill | Name already exists | Choose different name or update existing |
| Invalid workflow | Cannot parse process | Ask for clearer workflow description |
| Missing tools | Required tools not available | Adjust skill to use available tools |
| Schema violation | Invalid SKILL.md format | Fix format and regenerate |

**Fallback**: If skill generation fails, create command instead (simpler structure).

## Quality Standards

Generated skills must:
- Have specific autodiscovery triggers
- Include expertise file for learning
- Be immediately functional
- Follow existing skill patterns
- Support self-improvement
