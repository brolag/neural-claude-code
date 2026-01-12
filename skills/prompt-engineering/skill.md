---
name: prompt-engineering
description: Review, improve, and validate AI prompts using CRISP-E framework
trigger: /prompt-review, /prompt-improve, /prompt-validate
---

# Prompt Engineering Skill

Tools for reviewing, improving, and validating AI prompts.

## Commands

| Command | Description |
|---------|-------------|
| `/prompt-review <file>` | Assess prompt quality using CRISP-E framework |
| `/prompt-improve <file>` | Improve prompt using multi-AI review (Gemini + Codex) |
| `/prompt-validate <file>` | Verify research results and links |

## Quick Start

```bash
# Review a prompt's quality
/prompt-review prompts/my-prompt.md

# Get AI feedback and auto-improve
/prompt-improve prompts/my-prompt.md

# Verify research results
/prompt-validate results/research-output.md
```

## The CRISP-E Framework

Six dimensions for evaluating prompts:

| Dimension | Weight | Question |
|-----------|--------|----------|
| **C**larity | 20% | Can the AI understand exactly what to do? |
| **R**ichness | 20% | Does the AI have enough context? |
| **I**ntegrity | 20% | Will the output be trustworthy? |
| **S**tructure | 20% | Is the format clear and consistent? |
| **P**recision | 10% | Are measurements/evaluations defined? |
| **E**xecutability | 10% | Can the AI actually perform this? |

## Common Antipatterns

1. **Oracle Assumption** - Asking AI to predict unknowable things
2. **Verification Lie** - Asking AI to "verify" things it cannot check
3. **Scale Trap** - Using 1-5 scales without behavioral anchors
4. **Context Gap** - Expecting AI to know org-specific details not provided
5. **Infinite Scope** - "Be comprehensive" without limits
6. **Format Drift** - Not providing explicit output templates

## Workflow

```
┌─────────────────┐
│  Write Prompt   │
└────────┬────────┘
         ↓
┌─────────────────┐
│ /prompt-review  │  ← CRISP-E assessment
└────────┬────────┘
         ↓
    Score < 4.0?
         ↓ Yes
┌─────────────────┐
│ /prompt-improve │  ← Multi-AI feedback
└────────┬────────┘
         ↓
┌─────────────────┐
│  Apply Fixes    │
└────────┬────────┘
         ↓
    Run prompt
         ↓
┌─────────────────┐
│/prompt-validate │  ← Verify outputs
└─────────────────┘
```

## Usage

```bash
# Review a prompt's quality
/prompt-review prompts/my-prompt.md

# Get AI feedback and auto-improve
/prompt-improve prompts/my-prompt.md

# Verify research results
/prompt-validate results/research-output.md

# Review all prompts in directory
/prompt-review commands/*.md --batch
```

## Output Format

```markdown
## Prompt Review: [filename]

**Overall Score**: [X.X]/5.0

### CRISP-E Breakdown
| Dimension | Score | Notes |
|-----------|-------|-------|
| Clarity | X/5 | [notes] |
| Richness | X/5 | [notes] |
| Integrity | X/5 | [notes] |
| Structure | X/5 | [notes] |
| Precision | X/5 | [notes] |
| Executability | X/5 | [notes] |

### Issues Found
- [Issue 1]
- [Issue 2]

### Recommendations
- [Recommendation 1]
- [Recommendation 2]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| File not found | Invalid path | Check file path |
| Not a prompt file | Wrong file type | Provide .md prompt file |
| Parse error | Malformed prompt | Fix YAML frontmatter |
| External AI unavailable | Gemini/Codex offline | Continue with single-AI review |

**Fallback**: If multi-AI review fails, use single-model CRISP-E assessment.

## Files

- `review.md` - CRISP-E assessment logic
- `improve.md` - Multi-AI review automation
- `validate.md` - Research verification
