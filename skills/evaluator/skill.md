---
name: evaluator
description: Run evaluation tests against golden tasks to measure system performance. Use when user says "evaluate", "run tests", "check performance", or during scheduled optimization.
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Evaluator

Measure system performance against golden test cases.

## Purpose

- Validate skills and agents work correctly
- Track performance over time
- Identify regressions
- Compare different approaches

## Golden Tasks

Test cases stored in `.claude/eval/golden-tasks.json`:

```json
{
  "version": "1.0.0",
  "tasks": [
    {
      "id": "task-001",
      "name": "Simple file edit",
      "description": "Edit a TypeScript file to add a function",
      "input": {
        "prompt": "Add a function called greet that returns 'Hello'",
        "context": {"file": "test/fixtures/simple.ts"}
      },
      "expected": {
        "contains": ["function greet", "return", "Hello"],
        "file_modified": "test/fixtures/simple.ts"
      },
      "tags": ["basic", "edit"],
      "difficulty": "easy"
    },
    {
      "id": "task-002",
      "name": "Multi-AI collaboration",
      "description": "Use /ai-collab to solve a problem",
      "input": {
        "prompt": "/ai-collab Optimize this sorting function"
      },
      "expected": {
        "contains": ["Claude", "Codex", "Consensus"],
        "format": "comparison table"
      },
      "tags": ["multi-ai", "collaboration"],
      "difficulty": "medium"
    }
  ]
}
```

## Evaluation Process

### 1. Load Golden Tasks
```bash
cat .claude/eval/golden-tasks.json
```

### 2. Run Tasks
For each task:
- Set up test environment
- Execute task
- Capture output
- Compare against expected

### 3. Score Results
```json
{
  "task_id": "task-001",
  "passed": true,
  "score": 1.0,
  "execution_time": 2.5,
  "output_matches": ["function greet", "return", "Hello"],
  "output_missing": [],
  "notes": ""
}
```

### 4. Generate Report
```markdown
# Evaluation Report

**Date**: 2025-12-17
**Version**: 1.2.0
**Tasks Run**: 10

## Summary
- Passed: 8/10 (80%)
- Average Score: 0.85
- Average Time: 3.2s

## Results by Category
| Category | Passed | Failed | Score |
|----------|--------|--------|-------|
| basic | 5/5 | 0 | 1.0 |
| multi-ai | 2/3 | 1 | 0.67 |
| skills | 1/2 | 1 | 0.5 |

## Failed Tasks
### task-007: Skill Creation
- Expected: SKILL.md created
- Actual: Missing tests.json
- Suggestion: Update skill-builder to always create tests

## Trends
- Performance improved 5% from last week
- Multi-AI tasks showing variability
```

## Commands

### `/eval`
Run full evaluation suite.

### `/eval --quick`
Run only "easy" difficulty tasks.

### `/eval --tag <tag>`
Run tasks with specific tag.

### `/eval --task <id>`
Run single task by ID.

## Result Storage

Results saved to `.claude/eval/results/{date}.json`:

```json
{
  "date": "2025-12-17",
  "version": "1.2.0",
  "duration": 45.2,
  "summary": {
    "total": 10,
    "passed": 8,
    "failed": 2,
    "score": 0.85
  },
  "results": [...]
}
```

## Metrics Tracking

Track over time in `.claude/eval/metrics.json`:

```json
{
  "history": [
    {"date": "2025-12-10", "score": 0.80},
    {"date": "2025-12-17", "score": 0.85}
  ],
  "best_score": 0.85,
  "trend": "improving"
}
```

## Integration

- Run automatically during `/evolve`
- Results feed into optimizer
- Alerts on regression (score drop > 10%)

## Usage

```bash
# Run full evaluation suite
/eval

# Quick evaluation (easy tasks only)
/eval --quick

# Filter by tag
/eval --tag multi-ai

# Run single task
/eval --task task-001
```

## Output Format

```markdown
## Evaluation Complete

**Date**: [date]
**Tasks**: [n] run
**Score**: [x]% ([passed]/[total])

### Results
| Task | Status | Score | Time |
|------|--------|-------|------|
| task-001 | ✅ | 1.0 | 2.5s |
| task-002 | ❌ | 0.0 | 3.1s |

### Failed Tasks
- **task-002**: Expected X, got Y

### Trend
[improving/declining/stable] vs last run
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Golden tasks not found | Missing file | Run `/setup` to create template |
| Task timeout | Execution too slow | Increase timeout or simplify task |
| Invalid expected format | Schema mismatch | Validate against schema |
| Fixture missing | Test file not found | Create fixture or skip task |

**Fallback**: If evaluation fails completely, run subset of basic tasks.

## Safety Constraints

- Run in isolated test environment
- Don't modify production files
- Clean up test artifacts
- Log all evaluation runs
