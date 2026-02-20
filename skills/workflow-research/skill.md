---
name: workflow-research
description: Research and knowledge capture workflow. Use when: investigating a topic, learning something new, doing competitive analysis, gathering information before a decision. Don't use when: topic is already in memory and recent (< 7 days) — use /recall instead. Don't use when: question is simple enough to answer from general knowledge.
trigger: research, learn about, investigate, find out, what is, deep dive, competitive analysis
---

# Workflow: Research

Check memory first, search if needed, always save findings.

## Chain

```
1. recall                    → ALWAYS FIRST — check memory before hitting APIs
2. super-search?             → SKIP if: memory hit found AND memory_age < 7 days
3. knowledge-management?     → SKIP if: single quick fact (not a full topic)
4. memory-system (remember)  → ALWAYS — save at least one key fact
```

## Skip Gates

| Step | Skip When |
|---|---|
| `super-search` | Topic already in memory AND saved < 7 days ago |
| `knowledge-management` | Single quick lookup, not a topic worth indexing |
| `remember` | Never skip — always persist something |

## Recency Policy

| Topic Type | Memory Considered Fresh |
|---|---|
| AI/tech news | < 2 days |
| Market/crypto data | < 1 day |
| Architecture patterns | < 30 days |
| Evergreen concepts | < 90 days |

## Done When

- [ ] Question answered with sources
- [ ] Key insights saved to memory-system
- [ ] Connections to existing knowledge noted

## Entry Signals

"research X", "what do you know about...", "find out about...", "competitive analysis of...", "what's the latest on...", "deep dive into..."
