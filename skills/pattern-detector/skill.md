---
name: pattern-detector
description: Analyzes session logs and memory to identify repeated patterns that could become skills or agents. Use when running /evolve, during nightly optimization, or when user asks to find patterns.
allowed-tools: Read, Glob, Grep, Bash
---

# Pattern Detector

Analyze usage patterns to identify automation opportunities.

## Purpose

Find repeated workflows in session history that could be:
- New skills
- New agents
- Rule improvements
- Memory optimizations

## Trigger Conditions

- User runs `/evolve`
- Scheduled nightly optimization
- User says "find patterns" or "analyze usage"
- Memory threshold exceeded

## Data Sources

```
.claude/memory/events/*.jsonl        # Event logs
.claude/memory/session_logs/         # Session transcripts
~/.claude/memory/global_patterns.json # Cross-project patterns
```

## Pattern Types

### 1. Command Sequences
Repeated sequences of tool calls:
```
Edit -> Bash(test) -> Edit -> Bash(test) -> ...
```
→ Could become: auto-test skill

### 2. File Access Patterns
Same files accessed together:
```
config.ts + api.ts + types.ts (5x)
```
→ Could become: config change checklist

### 3. Prompt Patterns
Similar user requests:
```
"fix the type error in..." (7x)
```
→ Could become: type-fixer agent

### 4. Error Recovery Patterns
Common error → fix sequences:
```
ESLint error → specific fix pattern
```
→ Could become: auto-fix rule

## Detection Algorithm

```python
def detect_patterns(events):
    patterns = []

    # 1. Sliding window for command sequences
    for window in sliding_windows(events, size=5):
        if frequency(window) >= 3:
            patterns.append({"type": "sequence", "pattern": window})

    # 2. File co-occurrence
    file_groups = cluster_files_by_session(events)
    for group in file_groups:
        if len(group) >= 3 and frequency(group) >= 3:
            patterns.append({"type": "file_group", "pattern": group})

    # 3. Prompt similarity (semantic)
    similar_prompts = cluster_similar_prompts(events)
    for cluster in similar_prompts:
        if len(cluster) >= 3:
            patterns.append({"type": "prompt", "pattern": cluster})

    return patterns
```

## Output Format

```json
{
  "analyzed_period": "2025-12-01 to 2025-12-17",
  "events_analyzed": 1500,
  "patterns_found": [
    {
      "id": "pattern-001",
      "type": "sequence",
      "description": "Test-fix cycle repeated",
      "frequency": 7,
      "confidence": 0.85,
      "suggestion": "Create auto-test skill",
      "evidence": ["session-123", "session-456"]
    }
  ],
  "recommendations": [
    {
      "pattern_id": "pattern-001",
      "action": "create_skill",
      "priority": "high",
      "estimated_time_saved": "30 min/week"
    }
  ]
}
```

## Integration

After detecting patterns:
1. Log to `.claude/memory/patterns.json`
2. Notify optimizer agent
3. Queue for skill-builder if approved
4. Update active_context.md with insights

## Usage

```bash
# Run pattern detection
/evolve --detect-patterns

# Analyze specific period
/patterns --from "2025-12-01" --to "2025-12-17"

# Focus on specific pattern type
/patterns --type command_sequence
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No events found | Empty logs | Accumulate more usage data |
| Too few patterns | Low usage frequency | Lower threshold or wait longer |
| Pattern conflict | Overlapping patterns | Merge similar patterns |
| Memory parsing error | Corrupted JSONL | Repair or skip corrupted entries |

**Fallback**: If event logs unavailable, analyze current session only.

## Safety Constraints

- Read-only analysis (no modifications)
- Respect privacy (no logging of sensitive content)
- Require minimum 3 occurrences for pattern
- Human approval before creating skills
