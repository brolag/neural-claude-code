---
description: Test prompts for quality and correctness
allowed-tools: Read, Bash, Glob, Grep, Write
---

# Prompt Testing

Run quality tests on prompts (commands, skills, agents).

## Usage

```
/prompt-test                    # Run all tests
/prompt-test lint               # Static analysis only
/prompt-test lint --verbose     # Detailed output
/prompt-test score <path>       # Score a specific prompt
/prompt-test golden             # Run golden tests (input/output validation)
```

## Test Types

### 1. Lint (Static Analysis)

Checks structural requirements without executing prompts.

**Required (fail if missing):**
- YAML frontmatter (`---` block)
- `description:` field
- Clear process/steps

**Recommended (warning if missing):**
- `## Usage` section
- `## Output Format` section
- `## Examples` section
- `## Error Handling` section
- `## Related` commands

**Anti-patterns detected:**
- Vague language ("you should", "consider")
- Incomplete lists ("etc.", "and more")
- Undefined quality terms ("properly", "correctly")
- Very short prompts (< 20 lines)

### 2. Score (Quality Evaluation)

Score prompts on 8 dimensions (1-10 each):

| Dimension | Weight | Question |
|-----------|--------|----------|
| Clarity | 1.5x | Are instructions unambiguous? |
| Structure | 1.0x | Is it well-organized? |
| Specificity | 1.5x | Are expectations precise? |
| Output Format | 1.2x | Is output structure defined? |
| Examples | 1.0x | Are examples provided? |
| Error Handling | 0.8x | Are edge cases covered? |
| Actionability | 1.0x | Can Claude execute this? |
| Conciseness | 0.5x | Is it appropriately sized? |

**Score interpretation:**
- 70-80: Excellent
- 55-69: Good
- 40-54: Needs work
- <40: Major rewrite needed

### 3. Golden Tests (Behavioral)

Verify prompts produce expected outputs:

```json
{
  "prompt": "/remember",
  "input": "The API uses REST",
  "expected_contains": ["Remembered", "fact-"],
  "expected_not_contains": ["error"]
}
```

## Process

### Step 1: Run Linter

Check if the lint script exists first:
```bash
if [ -f .claude/eval/runners/lint-prompts.sh ]; then
  bash .claude/eval/runners/lint-prompts.sh
else
  echo "Lint script not found — using inline analysis"
fi
```

If the script is missing, perform inline linting by reading each `.claude/commands/*.md` and `.claude/skills/*/skill.md` and checking for the required fields (frontmatter, description, usage, output format).

Parse output and report:
- Files checked
- Pass/warning/fail counts
- Specific issues found

> **Note**: `.claude/eval/` is optional. The lint and score steps work without it using inline analysis. Golden tests require `.claude/eval/prompt-tests.json` — skip that step gracefully if missing.

### Step 2: Score Prompts (if requested)

For each prompt:
1. Read content
2. Check each dimension
3. Calculate weighted score
4. Flag if below threshold (55)

### Step 3: Run Golden Tests (if requested)

For each golden test:
1. Simulate prompt execution
2. Check output contains expected
3. Check output doesn't contain forbidden
4. Record pass/fail

### Step 4: Generate Report

## Output Format

```markdown
# Prompt Test Report

**Date**: {date}
**Prompts Tested**: {n}

## Lint Results

| Status | Count |
|--------|-------|
| Passed | {n} |
| Warnings | {n} |
| Failed | {n} |

### Issues Found
{List of issues by file}

## Score Results (if --score)

| Prompt | Score | Status |
|--------|-------|--------|
| /remember | 72/80 | Excellent |
| /capture | 65/80 | Good |
| /health | 68/80 | Good |

### Lowest Scores
{Prompts needing attention}

## Golden Test Results (if --golden)

| Test | Status |
|------|--------|
| prompt-remember-format | PASS |
| prompt-health-output | PASS |

## Recommendations
1. {Action item}
2. {Action item}
```

## Examples

### Example 1: Quick Lint

**Input**: `/prompt-test lint`

**Output**:
```markdown
# Prompt Lint Report

**Files Checked**: 39
**Pass Rate**: 92%

## Summary
| Status | Count |
|--------|-------|
| Passed | 32 |
| Warnings | 5 |
| Failed | 2 |

## Failed
- /deploy.md: Missing frontmatter, missing output format
- /analyze.md: Missing examples

## Warnings
- /specs.md: Missing error handling
- /route.md: Very long (237 lines)
```

### Example 2: Score Specific Prompt

**Input**: `/prompt-test score .claude/commands/remember.md`

**Output**:
```markdown
# Score: /remember

**Total**: 68/80 (Good)

| Dimension | Score | Notes |
|-----------|-------|-------|
| Clarity | 9/10 | Clear steps |
| Structure | 9/10 | Well organized |
| Specificity | 8/10 | Good JSON schema |
| Output Format | 7/10 | Could show exact output |
| Examples | 8/10 | 3 examples provided |
| Error Handling | 6/10 | Missing duplicate handling |
| Actionability | 9/10 | Very executable |
| Conciseness | 8/10 | Appropriate length |

## Recommendations
- Add duplicate detection handling
- Show exact confirmation message format
```

## Integration with /evolve

This command is automatically run during `/evolve`:

```
/evolve
  → Phase 4: Run Prompt Tests
    → Lint all prompts
    → Flag regressions from baseline
    → Add issues to evolution report
```

## Test Configuration

Tests defined in: `.claude/eval/prompt-tests.json`

Add custom tests:
```json
{
  "golden_tests": {
    "tests": [
      {
        "id": "my-test",
        "prompt": "/my-command",
        "input": "test input",
        "expected_contains": ["expected", "output"]
      }
    ]
  }
}
```

## Error Handling

- If prompt file not found: Skip with warning
- If lint script fails: Report error, continue
- If golden test can't run: Mark as SKIP

## Related Commands

- `/evolve` - Full system evolution (includes prompt tests)
- `/health` - System health (doesn't include prompt quality)
