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

## Files

- `review.md` - CRISP-E assessment logic
- `improve.md` - Multi-AI review automation
- `validate.md` - Research verification
