# Prompt Review

Assess prompt quality using the CRISP-E framework.

## Trigger
- `/prompt-review <file-path>`
- "review this prompt"
- "analyze my prompt"
- "assess prompt quality"

## Process

### 1. Read the Prompt
Read the file at the specified path.

### 2. CRISP-E Analysis

Evaluate each dimension:

#### C - Clarity (20%)
- [ ] Role is explicitly defined
- [ ] Objective is specific and measurable
- [ ] Ambiguous terms are defined
- [ ] Scope boundaries are clear

#### R - Richness (20%)
- [ ] Sufficient context provided
- [ ] Examples included (few-shot)
- [ ] Edge cases addressed
- [ ] Domain knowledge embedded

#### I - Integrity (20%)
- [ ] Anti-hallucination guardrails present
- [ ] Verification requirements realistic
- [ ] Source attribution required
- [ ] Uncertainty handling specified

#### S - Structure (20%)
- [ ] Clear section hierarchy
- [ ] Consistent formatting
- [ ] Output template provided
- [ ] Logical flow (context → task → output)

#### P - Precision (10%)
- [ ] Scoring/evaluation criteria defined
- [ ] Behavioral anchors for scales (not just 1-5)
- [ ] Specific not vague language
- [ ] Quantifiable where possible

#### E - Executability (10%)
- [ ] AI can actually perform all tasks
- [ ] No impossible verification requests
- [ ] Realistic scope for single execution
- [ ] Clear success criteria

### 3. Generate Report

```markdown
# Prompt Review Report

## Overview
- **File:** [path]
- **Purpose:** [detected purpose]
- **Word Count:** [count]
- **CRISP-E Score:** X.X/5

## Dimension Scores

| Dimension | Score | Key Issue |
|-----------|-------|-----------|
| Clarity | X/5 | [issue or "Good"] |
| Richness | X/5 | [issue or "Good"] |
| Integrity | X/5 | [issue or "Good"] |
| Structure | X/5 | [issue or "Good"] |
| Precision | X/5 | [issue or "Good"] |
| Executability | X/5 | [issue or "Good"] |

## Critical Issues
1. [Issue] - [Impact] - [Suggested Fix]

## Quick Fixes (High Priority)
[Before/after edits]

## Recommendation
- Score >= 4.0: Ready to use
- Score 3.0-4.0: Apply quick fixes
- Score < 3.0: Run `/prompt-improve` for multi-AI review
```

### 4. Offer Next Steps

- Apply fixes automatically
- Create improved version
- Run `/prompt-improve` for deeper analysis

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 5 | Excellent - no issues |
| 4 | Good - minor improvements possible |
| 3 | Adequate - notable gaps |
| 2 | Weak - significant issues |
| 1 | Poor - fundamental problems |
