---
description: Launch parallel forked research agents on multiple topics simultaneously
allowed-tools: Task, WebSearch, WebFetch, Write, Read
---

# Research Swarm

Launch multiple research agents in parallel, each in a forked context, to research different topics simultaneously.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ Main Session (Clean Context)                                │
│                                                             │
│   /research-swarm "topic1" "topic2" "topic3"               │
│                                                             │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│   │ Fork A       │  │ Fork B       │  │ Fork C       │     │
│   │ context:fork │  │ context:fork │  │ context:fork │     │
│   │ [Background] │  │ [Background] │  │ [Background] │     │
│   └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│          │                 │                 │              │
│          ▼                 ▼                 ▼              │
│   ┌──────────────────────────────────────────────────┐     │
│   │ WebSearch + WebFetch (10 min each, parallel)      │     │
│   └──────────────────────────────────────────────────┘     │
│                                                             │
│   Meanwhile: You keep working in clean main session         │
│                                                             │
│   ┌──────────────────────────────────────────────────┐     │
│   │ Results → inbox/research-swarm-{timestamp}/       │     │
│   │ Synthesis → swarm-synthesis.md                    │     │
│   │ Notify → Telegram when complete                   │     │
│   └──────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## When to Use

- Research multiple related topics in parallel
- Comparative analysis from different angles
- Gathering information on a topic from multiple perspectives
- Any multi-topic research where independence allows parallelization

## Behavior

1. Parse topics from arguments (space-separated quoted strings)
2. For EACH topic, spawn a Task with:
   - `subagent_type: general-purpose`
   - `run_in_background: true`
   - Research prompt using deep-research methodology
3. Each agent:
   - WebSearch the topic
   - WebFetch top 3-5 results
   - Synthesize findings
   - Write to `inbox/research-swarm-{timestamp}/{topic-slug}.md`
4. After all complete, synthesize results
5. Notify via Telegram

## Execution

When this command is invoked with topics, do the following:

1. **Parse topics** from the arguments
2. **Create output directory**: `inbox/research-swarm-{YYYY-MM-DD-HHMM}/`
3. **Launch parallel Task agents** - ALL in ONE message (critical for parallelism):

```
For each topic, use Task tool with:
- subagent_type: general-purpose
- run_in_background: true
- prompt: "Research '{topic}' comprehensively. Use WebSearch and WebFetch.
          Write findings to inbox/research-swarm-{timestamp}/{topic-slug}.md
          Include: Executive Summary, Key Findings (3-5), Sources (3+), Confidence Level"
```

4. **Monitor completion** by reading output files
5. **Synthesize** all findings into `swarm-synthesis.md`
6. **Notify** user via Telegram when complete

## Usage

```bash
# Research 3 topics in parallel
/research-swarm "AI coding agents" "MCP server architecture" "prompt engineering 2025"

# Comparative research
/research-swarm "GraphQL best practices" "REST API design" "gRPC patterns"

# Market research
/research-swarm "indie hacker tools" "solo founder trends" "micro SaaS pricing"

# Technical deep dive
/research-swarm "Claude Code features" "Cursor AI capabilities" "GitHub Copilot updates"
```

## Output Format

Each topic creates a file in the swarm directory:

```markdown
# Research: [Topic]

## Executive Summary
[2-3 sentences, main finding first]

## Key Findings
1. [Finding with evidence]
2. [Finding with source]
3. [Finding with data]

## Sources
- [Source 1](url) - [contribution]
- [Source 2](url) - [contribution]
- [Source 3](url) - [contribution]

## Confidence
**Level**: High/Medium/Low
**Reasoning**: [Why this confidence level]
```

The synthesis file combines all:

```markdown
# Research Swarm Synthesis

**Topics**: [list]
**Date**: [timestamp]
**Duration**: [how long]

## Cross-Topic Insights
[Patterns across all topics]

## Per-Topic Summaries
### [Topic 1]
[Key takeaway]

### [Topic 2]
[Key takeaway]

## Connections Discovered
[How topics relate]

## Recommended Actions
[What to do with this knowledge]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Task agent times out | Topic too broad or sources slow | Narrow the topic scope, retry with simpler phrasing |
| WebSearch returns nothing | Niche topic or bad query | Rephrase topic, use alternative keywords |
| Parallel tasks fail | Too many concurrent requests | Reduce swarm size, stagger launches |
| Output file not created | Agent finished without writing | Check agent output file for errors |
| Synthesis incomplete | Some topics didn't complete | Partial synthesis with notes on missing topics |

**Fallback**: If swarm fails to complete, provide partial results with clear indication of what succeeded and what needs manual research.

## Limits

- Maximum 5 topics per swarm (to avoid rate limits)
- Each agent has 10-minute timeout (v2.1.x hook timeout)
- Recommended: 2-3 topics for best quality
