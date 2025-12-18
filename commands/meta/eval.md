---
description: Evaluate agents/skills against golden test cases to measure effectiveness
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
argument-hint: [agent-or-skill-name] [--all] [--report]
---

# /meta/eval - Agent & Skill Evaluation

Run automated tests against agents and skills to measure their effectiveness.

## Arguments
- `$ARGUMENTS` - Name of agent/skill to evaluate, or `--all` to evaluate everything
- `--report` - Generate detailed markdown report

## Test Case Format

Test cases are stored in `.claude/tests/`:

```yaml
# .claude/tests/knowledge-management.tests.yaml
name: knowledge-management
type: skill

golden_tasks:
  - id: km-001
    description: "Capture a quick idea to inbox"
    input: "Remember to review API docs tomorrow"
    expected_behavior:
      - "Creates file in 00_inbox/"
      - "Includes timestamp"
      - "Contains the original text"
    success_criteria: file_created_in_inbox

  - id: km-002
    description: "Find notes about a topic"
    input: "Find all notes about AI"
    expected_behavior:
      - "Searches appropriate folders"
      - "Returns relevant results"
      - "Includes file paths"
    success_criteria: returns_relevant_results

  - id: km-003
    description: "Process inbox item"
    input: "Process the top inbox item"
    expected_behavior:
      - "Reads inbox"
      - "Categorizes correctly"
      - "Moves to appropriate location"
    success_criteria: file_moved_correctly

metrics_thresholds:
  min_success_rate: 0.8
  max_avg_latency_ms: 5000
```

## Evaluation Protocol

### Step 1: Load Test Suite

Find test file:
```
.claude/tests/<name>.tests.yaml
```

Or for global agents/skills:
```
~/.claude/tests/<name>.tests.yaml
```

### Step 2: Execute Each Golden Task

For each test case:
1. Record start time
2. Invoke the agent/skill with the input
3. Capture output and behavior
4. Record end time

### Step 3: Evaluate Results

Check against expected behavior:
```
✅ km-001: Capture quick idea
   - file_created_in_inbox: PASS
   - latency: 1200ms

❌ km-002: Find notes about topic
   - returns_relevant_results: FAIL
   - reason: Searched wrong folder
   - latency: 3400ms

✅ km-003: Process inbox item
   - file_moved_correctly: PASS
   - latency: 2100ms
```

### Step 4: Update Expertise Based on Results

For failed tests, add to `open_questions`:
```yaml
open_questions:
  - "Why did km-002 search wrong folder?"
```

For successful patterns, increase confidence:
```yaml
patterns:
  - pattern: "Check 00_inbox/ first for captures"
    confidence: 0.9  # Increased from 0.85
    successes: 18    # Incremented
```

### Step 5: Generate Report (if --report)

```markdown
# Evaluation Report: knowledge-management

**Date**: 2024-12-18
**Version**: 5
**Test Suite**: 3 golden tasks

## Summary

| Metric | Value | Threshold | Status |
|--------|-------|-----------|--------|
| Success Rate | 67% | 80% | ❌ FAIL |
| Avg Latency | 2233ms | 5000ms | ✅ PASS |

## Test Results

### ✅ km-001: Capture quick idea
- **Status**: PASS
- **Latency**: 1200ms
- **Behavior**: Created file in inbox with timestamp

### ❌ km-002: Find notes about topic
- **Status**: FAIL
- **Latency**: 3400ms
- **Expected**: Search 03_resources/ and 01_projects/
- **Actual**: Only searched 00_inbox/
- **Root Cause**: Missing search paths in expertise

### ✅ km-003: Process inbox item
- **Status**: PASS
- **Latency**: 2100ms
- **Behavior**: Correctly categorized and moved

## Recommendations

1. Update expertise file with correct search paths
2. Add test case for edge cases
3. Consider caching frequent searches

## Expertise Updates Applied

- Added open question about km-002 failure
- Increased confidence for inbox capture pattern
```

## Usage Examples

```bash
# Evaluate single skill
/meta/eval knowledge-management

# Evaluate with detailed report
/meta/eval cognitive-amplifier --report

# Evaluate all agents and skills
/meta/eval --all

# Evaluate and auto-update expertise
/meta/eval strategic-advisor
```

## Creating Test Cases

Create test file at `.claude/tests/<name>.tests.yaml`:

```yaml
name: <agent-or-skill-name>
type: agent|skill

golden_tasks:
  - id: unique-id
    description: "Human-readable description"
    input: "The prompt to test"
    expected_behavior:
      - "Expected behavior 1"
      - "Expected behavior 2"
    success_criteria: criterion_name

metrics_thresholds:
  min_success_rate: 0.8
  max_avg_latency_ms: 5000
```

## Integration with CI/CD

Add to your `.github/workflows/test.yml`:

```yaml
- name: Evaluate Claude Agents
  run: |
    claude "/meta/eval --all --report"
    cat .claude/reports/eval-*.md
```

## Quality Standards

- Tests must be deterministic where possible
- Each agent/skill should have 3+ golden tasks
- Thresholds should match real-world requirements
- Failed tests should update expertise open_questions
- Successful tests should boost pattern confidence
