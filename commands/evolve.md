---
description: Self-improvement cycle - analyze patterns, run evaluations, and evolve the system
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, Task
---

# System Evolution

Run the self-improvement cycle to analyze usage patterns and evolve the Neural Claude Code system.

## Usage

```bash
/evolve                    # Full evolution cycle
/evolve --dry-run          # Preview changes without applying
/evolve --phase <n>        # Run specific phase (1-5)
/evolve --report-only      # Generate report without changes
```

## What This Does

1. **Analyze Event Logs** - Review `.claude/memory/events/` for usage patterns
2. **Detect Patterns** - Find repeated workflows that could be automated
3. **Run Evaluations** - Test system against golden tasks
4. **Update Expertise** - Refine agent mental models based on learnings
5. **Suggest Improvements** - Recommend new skills, commands, or agents

## Process

### Phase 1: Gather Data

```bash
# Read event logs
Read .claude/memory/events/*.jsonl

# If no events exist, check for older format
Glob .claude/memory/events/**/*.json

# Aggregate statistics
- Count tool usage frequency
- Identify command patterns
- Track session durations
```

**Output**: Event summary with tool counts and command frequency.

### Phase 2: Pattern Analysis

```bash
# Use pattern-detector skill
Task: "Analyze event logs for repeated patterns" (subagent: pattern-detector)

# Or manually search for sequences
Grep: "tool.*tool.*tool" in event logs
```

**Look for**:
- Repeated tool sequences (3+ occurrences)
- Common workflows that could become skills
- Manual tasks that could be automated

**Output**: List of detected patterns with occurrence counts.

### Phase 3: Evaluation

```bash
# Check if golden tasks exist
Read .claude/eval/golden-tasks.json

# Run evaluations
Task: "Run evaluation suite" (subagent: evaluator)

# Or run manually
Bash: bash .claude/eval/runners/run-eval.sh
```

**Tests**:
- Memory system (remember/recall/forget)
- Multi-AI collaboration
- Worktree management
- Project setup

**Output**: Pass/fail results with timing.

### Phase 4: Expertise Update

```bash
# For each expertise file
Glob .claude/expertise/*.yaml

# Validate and update
Read each file
- Check patterns against actual usage
- Update confidence scores: confidence = successes / (successes + failures + 1)
- Prune patterns with confidence < 0.3
- Add newly discovered patterns

Write updated expertise files
```

**Output**: Updated expertise files with confidence scores.

### Phase 5: Generate Report

```bash
# Create evolution report
Write .claude/memory/evolution-report-{date}.md

# Save results to eval
Write .claude/eval/results/{date}-evolution.json
```

## Output Format

```markdown
# Evolution Report - {DATE}

## Session Analysis
- Sessions analyzed: {n}
- Total events: {n}
- Tools used: {tool} ({count}), ...

## Patterns Detected
1. {pattern_name} ({count}x) - {description}
2. ...

## Automation Opportunities
- [ ] Create skill: "{name}" for pattern #{n}
- [ ] Create command: "/{name}" for pattern #{n}

## Evaluation Results
| Task | Status | Duration |
|------|--------|----------|
| {task} | PASS/FAIL/SKIP | {time} |

## Expertise Updates
- {file}: +{n} patterns, confidence avg {score}

## Health Score: {score}/100
- Memory capture: {status}
- Event logging: {status}
- Pattern detection: {status}
- Skill creation: {status}

## Recommendations
1. {recommendation}
2. ...
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No events found | Empty `.claude/memory/events/` | Run some sessions first, or check path |
| No golden tasks | Missing `.claude/eval/golden-tasks.json` | Create golden tasks or skip Phase 3 |
| Expertise validation failed | Invalid YAML | Fix syntax in expertise file |
| Low event count | < 50 events | Accumulate more usage data |

**Fallback behavior**:
- Missing events → Skip Phase 1, report "insufficient data"
- Missing golden tasks → Skip Phase 3, note in report
- Invalid expertise → Log error, continue with other files

## Example Output

```markdown
# Evolution Report - 2026-01-11

## Session Analysis
- Sessions analyzed: 5
- Total events: 127
- Tools used: Read (45), Edit (32), Bash (28), Grep (22)

## Patterns Detected
1. Read → Edit → Write (23x) - Code modification pattern
2. Glob → Grep → Read (18x) - Code search pattern
3. Bash(git) → Write (12x) - Git workflow pattern

## Automation Opportunities
- [ ] Create skill: "code-search" for pattern #2
- [ ] Create command: "/refactor" for pattern #1

## Evaluation Results
| Task | Status | Duration |
|------|--------|----------|
| Memory Remember | PASS | 0.8s |
| Multi-AI Collab | SKIP | No API keys |
| Worktree Create | PASS | 1.2s |
| Project Setup | PASS | 0.5s |

## Expertise Updates
- knowledge-management.yaml: +2 patterns, confidence avg 0.78
- second-brain.yaml: +1 lesson learned

## Health Score: 76/100
- Memory capture: Active ✓
- Event logging: Active ✓
- Pattern detection: Needs data (< 100 events)
- Skill creation: Ready ✓
```

## Frequency

- **Recommended**: Weekly or after major work sessions
- **Minimum data**: 50+ events for meaningful patterns
- **Trigger**: Can be automated via cron or session count threshold

## Related Commands

| Command | Purpose |
|---------|---------|
| `/eval` | Run evaluation tests only |
| `/meta:improve <agent>` | Sync single agent's expertise |
| `/health` | View system health dashboard |

## Tips

- Run after accumulating 50+ events for meaningful patterns
- Review suggestions before auto-creating skills
- Use `--dry-run` to preview changes without applying
- Check `.claude/eval/results/` for historical evolution data
