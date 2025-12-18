---
description: Display brain status - expertise health, memory state, agent metrics
allowed-tools: Read, Glob, Grep
argument-hint: [--detailed] [--json]
---

# /meta/brain - System Status Dashboard

View the health and status of your neural second brain system.

## Arguments
- `--detailed` - Show full expertise file contents
- `--json` - Output as JSON for programmatic use

## Status Display

### Default View

```
🧠 Neural Second Brain Status
═══════════════════════════════════════════

📊 System Health: ██████████░░ 83%

┌─────────────────────────────────────────┐
│ EXPERTISE FILES                         │
├─────────────────────────────────────────┤
│ ✅ knowledge-management  v5   0.85 conf │
│ ✅ cognitive-amplifier   v3   0.78 conf │
│ ⚠️  strategic-advisor    v2   0.45 conf │
│ ✅ second-brain          v4   0.82 conf │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ AGENTS                                  │
├─────────────────────────────────────────┤
│ cognitive-amplifier    ● Active         │
│ insight-synthesizer    ● Active         │
│ framework-architect    ● Active         │
│ strategic-advisor      ○ Needs improve  │
│ codex                  ● Active         │
│ gemini                 ● Active         │
│ multi-ai               ● Active         │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ SKILLS                                  │
├─────────────────────────────────────────┤
│ knowledge-management   ● Active    12 uses │
│ content-creation       ● Active     8 uses │
│ deep-research          ● Active     5 uses │
│ project-setup          ● Active     3 uses │
│ memory-system          ● Active    22 uses │
│ pattern-detector       ○ Shadow     0 uses │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ MEMORY                                  │
├─────────────────────────────────────────┤
│ Hot:   Current context                  │
│ Warm:  47 facts, 128 events             │
│ Cold:  12 session archives              │
│ Total: ~2.3 MB                          │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ RECENT ACTIVITY                         │
├─────────────────────────────────────────┤
│ 10:30  /meta/improve knowledge-mgmt     │
│ 10:25  knowledge-management skill       │
│ 10:20  cognitive-amplifier agent        │
│ 09:45  /question codebase structure     │
└─────────────────────────────────────────┘

⚠️  RECOMMENDATIONS
─────────────────────────────────────────
• strategic-advisor has low confidence (0.45)
  → Run: /meta/improve strategic-advisor

• pattern-detector still in shadow mode
  → Review and activate if ready

• 3 expertise files not synced in 7+ days
  → Run: /meta/improve --all
```

## Protocol

### Step 1: Gather Expertise Status

Read all expertise files:
```
.claude/expertise/*.yaml
~/.claude/expertise/*.yaml (global)
```

Calculate health metrics:
- Average confidence across all files
- Files with confidence < 0.5 = warning
- Files not updated in 7+ days = stale

### Step 2: Inventory Agents & Skills

Scan:
```
.claude/agents/*.md
~/.claude/agents/*.md
.claude/skills/*/SKILL.md
~/.claude/skills/*/SKILL.md
```

Check activation status:
- Active: Has expertise file with confidence > 0.5
- Shadow: New, not yet validated
- Needs Improve: confidence < 0.5 or stale

### Step 3: Memory Statistics

Count:
```
.claude/memory/facts/*.json   → fact count
.claude/memory/events/*.json  → event count
.claude/memory/archives/      → archive count
```

Calculate total size.

### Step 4: Recent Activity

Read activity log:
```
.claude/logs/activity.log
```

Show last 5-10 activities.

### Step 5: Generate Recommendations

Based on:
- Low confidence expertise files
- Shadow mode components
- Stale files (7+ days)
- Failed test cases
- High failure rate patterns

## JSON Output (--json)

```json
{
  "health_score": 0.83,
  "expertise": {
    "knowledge-management": {
      "version": 5,
      "confidence": 0.85,
      "last_updated": "2024-12-18",
      "status": "healthy"
    }
  },
  "agents": {
    "cognitive-amplifier": {
      "status": "active",
      "expertise_linked": true
    }
  },
  "skills": {
    "knowledge-management": {
      "status": "active",
      "invocations": 12
    }
  },
  "memory": {
    "facts": 47,
    "events": 128,
    "archives": 12,
    "total_bytes": 2411724
  },
  "recommendations": [
    "Run /meta/improve strategic-advisor"
  ]
}
```

## Usage Examples

```bash
# Quick status check
/meta/brain

# Full details
/meta/brain --detailed

# For scripting
/meta/brain --json
```

## Health Score Calculation

```
health_score = (
  avg_expertise_confidence * 0.4 +
  (active_agents / total_agents) * 0.2 +
  (active_skills / total_skills) * 0.2 +
  freshness_score * 0.2
)

freshness_score = files_updated_within_7_days / total_files
```

## Integration

Use in daily workflow:
```bash
# Morning check
/meta/brain

# If issues found
/meta/improve <problem-area>

# Verify fix
/meta/brain
```
