---
name: deep-research
description: Conduct comprehensive multi-source research with systematic analysis and knowledge integration. Use when user needs thorough investigation, deep dive analysis, or research on complex topics.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, Task
---

# Deep Research Skill

Comprehensive research using four-phase orchestration with parallel execution and dependency-aware task management.

## Architecture

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  UNDERSTAND  │ -> │    PLAN      │ -> │   EXECUTE    │ -> │  SYNTHESIZE  │
│  Extract     │    │  Create task │    │  Parallel    │    │  Compile     │
│  intent &    │    │  list with   │    │  execution   │    │  findings    │
│  scope       │    │  dependencies│    │  of tasks    │    │              │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
```

## When to Use

- "Research X thoroughly"
- "Deep dive into Y"
- "Investigate Z from multiple angles"
- "Compare different approaches to..."
- Complex topics requiring multiple source validation
- Technical evaluation or comparison tasks

## Phase 0: Check Existing Knowledge (REQUIRED)

**Before any research, check if knowledge already exists:**

1. Review learnings summary (loaded at session start)
2. Use `/recall <topic>` to search existing learnings
3. Check `inbox/*.md` for previous research on this topic

If relevant knowledge exists:
- Build on it, don't duplicate
- Reference existing findings
- Focus on gaps or updates needed

**Never re-research what's already learned.**

## Phase 1: Understand

Extract intent and scope from the research question:

```yaml
understanding:
  intent: "What the user wants to know"
  entities:
    - type: topic | comparison | person | company | technology
      value: "extracted entity"
  scope: narrow | medium | broad
  domain: business | technology | finance | health | general
```

**Output**: Clear statement of what we're researching and why.

## Phase 2: Plan

Create 3-6 research tasks with dependencies:

```yaml
tasks:
  - id: "task-1"
    description: "MAX 10 words - what to find"
    type: web_search | source_fetch | ai_consult | analyze
    dependsOn: []  # or ["task-1", "task-2"]

# Task types:
# - web_search: Use WebSearch tool
# - source_fetch: Use WebFetch on specific URL
# - ai_consult: Get perspective from other AI (Gemini/Codex)
# - analyze: Synthesize gathered data
```

**Constraints**:
- Maximum 6 tasks (prevents over-planning)
- Task descriptions under 10 words
- `analyze` tasks must depend on data-gathering tasks
- Tools selected at execution time, not planning time

**Search Query Patterns**:
1. Broad overview: `"{topic} comprehensive guide 2025"`
2. Expert analysis: `"{topic} research expert analysis"`
3. Current trends: `"{topic} latest developments 2025"`
4. Practical: `"{topic} implementation case studies"`
5. Critical: `"{topic} challenges limitations"`

## Phase 3: Execute

Run tasks respecting dependencies:

```
1. Identify tasks with satisfied dependencies
2. Execute them in parallel (use Task tool for agents)
3. Store results keyed by task ID
4. Repeat until all tasks complete
```

**Parallel Execution Rules**:
- Independent `web_search` tasks run simultaneously
- `analyze` waits for its dependencies
- `ai_consult` can run parallel to searches

**Just-in-Time Tool Selection**:
| Task Type | Tools Selected |
|-----------|----------------|
| web_search | WebSearch |
| source_fetch | WebFetch |
| ai_consult | Task (gemini/codex agent) |
| analyze | Read gathered data, synthesize |

## Phase 4: Synthesize

Compile findings into structured output:

```markdown
# Research Report: [Topic]

## Executive Summary
[2-3 sentences - FIRST SENTENCE IS THE MAIN FINDING]

## Key Findings
1. Finding with specific data/numbers
2. Finding with source attribution
3. Finding with confidence level

## Detailed Analysis
### [Theme 1]
[Analysis with citations]

### [Theme 2]
[Analysis with citations]

## Sources
- [Source Title](url) - [what it contributed]

## Confidence Assessment
- **Overall**: High/Medium/Low
- **Data Quality**: [assessment]
- **Source Agreement**: [how well sources align]

## Connections
- Links to existing vault content
- Related projects or notes

## Open Questions
- Unanswered question 1
- Area needing more research
```

## Output Validation

Research outputs must include:

```yaml
required:
  - executive_summary: "2-3 sentences, main finding first"
  - key_findings: "3-5 findings with evidence"
  - sources: "minimum 3, with URLs"
  - confidence: "high | medium | low with reasoning"

optional:
  - detailed_analysis: "organized by theme"
  - connections: "links to vault content"
  - open_questions: "what remains unknown"
  - next_steps: "actionable recommendations"
```

## Multi-AI Integration

For complex topics, plan includes `ai_consult` tasks:

| AI | Strength | Use For |
|----|----------|---------|
| Claude | Nuanced analysis | Synthesis, edge cases |
| Gemini | Fast, algorithmic | Quick facts, alternatives |
| Codex | Implementation | Technical details, code |

## Output Locations

- Quick research → Memory fact
- Deep research → `inbox/research-{date}-{topic}.md`
- Vault integration → `03_resources/Research/`
- Project-specific → `research/` directory in project

## Quality Criteria

- Minimum 3 independent sources
- Cross-verified key facts
- Specific numbers/data where available
- Clear confidence levels
- Main finding in first sentence
- Explicit uncertainty acknowledgment

## Usage

```bash
# Basic research - 3-4 tasks
/research "best practices for micro SaaS pricing 2025"

# Comparative - 4-5 tasks with parallel searches
/research "compare Stripe vs Lemon Squeezy for indie developers"

# Technical deep dive - 5-6 tasks with AI consultation
/research "agentic coding patterns 2025"

# Research with output location
/research "topic" --save-to inbox/

# Quick research (fewer sources)
/research "topic" --quick
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No search results | Query too specific | Broaden search terms |
| Rate limited | Too many WebSearch calls | Wait and retry with fewer tasks |
| Source unreachable | WebFetch failed | Skip source, note in report |
| Conflicting sources | Disagreement between sources | Note conflict, assess credibility |
| AI consultation failed | External AI unavailable | Continue without that perspective |

**Fallback**: If web search fails, attempt research using only local vault knowledge.
