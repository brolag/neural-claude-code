---
description: Self-improve command - sync agent/skill expertise with reality, validate schema, update confidence scores
allowed-tools: Read, Write, Edit, Glob, Grep
argument-hint: [agent-or-skill-name] [--validate-only] [--prune]
---

# Self-Improve: Expertise Synchronization

Sync an agent or skill's mental model (expertise file) with the actual codebase/vault state.

## Arguments
- `$ARGUMENTS` - Name of agent or skill to improve (e.g., "knowledge-management", "cognitive-amplifier")
- `--validate-only` - Only validate schema, don't update
- `--prune` - Remove patterns with confidence < 0.3

## Self-Improvement Protocol

### Step 1: Load Current Expertise
Read the expertise file:
```
.claude/expertise/<name>.yaml
```

### Step 2: Schema Validation

Validate against `schemas/expertise.schema.json`:
- ✅ Required fields: `domain`, `version`, `last_updated`, `understanding`
- ✅ Confidence scores in range 0.0-1.0
- ✅ Valid date formats
- ✅ Pattern structure (string or scored object)

If validation fails:
```
❌ Schema Validation Failed
   - Missing required field: understanding
   - Invalid confidence: 1.5 (must be 0.0-1.0)
```

### Step 3: Validate Against Reality

For each element in the expertise file:
1. **File locations**: Verify files still exist at documented paths
2. **Patterns**: Check if patterns are still accurate
3. **Understanding**: Validate assumptions against current state

### Step 4: Update Confidence Scores

For patterns with tracking:
```yaml
patterns:
  - pattern: "Use PARA methodology"
    confidence: 0.85  # (successes / (successes + failures))
    successes: 17
    failures: 3
```

**Confidence Formula**: `confidence = successes / (successes + failures + 1)`

### Step 5: Prune Low-Confidence Patterns (if --prune)

Remove patterns where:
- `confidence < 0.3`
- `failures > successes * 2`
- Not used in 90+ days

Log pruned patterns:
```
🗑️ Pruned 3 low-confidence patterns:
   - "Pattern X" (confidence: 0.2)
   - "Pattern Y" (confidence: 0.15)
```

### Step 6: Discover New Information

Scan the relevant domain for:
- New files that should be tracked
- Changed patterns
- New user preferences (from recent usage)
- Updated relationships

### Step 7: Update Expertise File

Modify the YAML file with:
```yaml
# Updated fields
last_updated: [today's date]
version: [increment]

# New discoveries
understanding:
  key_files: [updated list]
  patterns: [refined patterns with scores]

lessons_learned:
  - lesson: "[New insight from this sync]"
    confidence: 0.5  # Start at 0.5 for new lessons
    learned_on: "[today's date]"

# Update metrics
metrics:
  total_invocations: [increment]
  average_confidence: [recalculate]
  patterns_pruned: [count if --prune]

# Resolved questions
open_questions: [remaining questions only]
```

### Step 8: Report Changes

Output:
```
📊 Expertise Sync Complete: <name>

Schema: ✅ Valid
Files Validated: 5/5 exist
Patterns: 12 active, 3 pruned

Changes:
+ Added 2 new patterns
~ Updated 3 confidence scores
- Removed 1 outdated file reference
✓ Resolved 1 question

New Lessons:
- "[Insight discovered]"

Metrics:
  Version: 4 → 5
  Avg Confidence: 0.72 → 0.75
  Next Review: [7 days]
```

## Usage Examples

```bash
# Improve knowledge management skill
/meta/improve knowledge-management

# Validate only (no changes)
/meta/improve cognitive-amplifier --validate-only

# Prune low-confidence patterns
/meta/improve strategic-advisor --prune

# Improve entire second brain understanding
/meta/improve second-brain
```

## Quality Standards

Updates must:
- Pass schema validation
- Be based on actual evidence, not assumptions
- Preserve valuable historical insights
- Add concrete, actionable learnings with confidence 0.5
- Remove outdated information
- Maintain YAML validity
- Update metrics accurately
