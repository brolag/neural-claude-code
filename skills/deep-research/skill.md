---
name: deep-research
description: Conduct comprehensive multi-source research with systematic analysis and knowledge integration. Use when user needs thorough investigation, deep dive analysis, or research on complex topics.
trigger: /research
context: fork
agent: general-purpose
---

# Deep Research Skill

Comprehensive research using four-phase orchestration with parallel execution.

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
- Any topic requiring multiple sources and synthesis

## Phase 0: Check Existing Knowledge (AUTO-EXECUTED)

**This phase runs AUTOMATICALLY before research begins. Do not skip.**

### Execution Steps

1. **Extract topic keywords** from the research question
2. **Search learnings index**:
   ```bash
   # Conceptual - executed by Claude
   grep -i "<topic>" .claude/memory/learnings/index.json
   grep -ri "<topic>" inbox/*.md
   ```
3. **Present findings to user**:
   ```
   📚 Found existing knowledge on '<topic>':
   - [Learning 1]: [summary]
   - [Learning 2]: [summary]
   - [Related inbox file]: inbox/research-YYYY-MM-DD-topic.md
   ```

4. **Ask user how to proceed**:
   ```
   Options:
   1. Build on existing (focus on gaps)
   2. Full research (comprehensive, may overlap)
   3. Cancel (existing knowledge sufficient)
   ```

### If Existing Knowledge Found

- **Build on it**: Set Phase 2 tasks to focus on gaps only
- **Reference it**: Include existing findings in synthesis
- **Link it**: Connect new research to old

### If No Existing Knowledge

- Proceed directly to Phase 1
- Note in synthesis: "First research on this topic"

### Implementation

When `/research <topic>` is invoked:

```python
# Pseudo-code for Phase 0
def auto_recall(topic):
    # 1. Search learnings
    index = read(".claude/memory/learnings/index.json")
    matches = [e for e in index["entries"] if topic.lower() in e["tags"]]

    # 2. Search inbox
    inbox_files = glob("inbox/*.md")
    inbox_matches = [f for f in inbox_files if topic.lower() in read(f).lower()]

    # 3. Present findings
    if matches or inbox_matches:
        show_existing_knowledge(matches, inbox_matches)
        choice = ask_user("Build on existing, Full research, or Cancel?")
        return choice
    else:
        print("No existing knowledge found. Proceeding with full research.")
        return "full"
```

**This prevents duplicate research and compounds knowledge over time.**

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
# - ai_consult: Get perspective from Codex
# - analyze: Synthesize gathered data
```

**Constraints**:
- Maximum 6 tasks (prevents over-planning)
- Task descriptions under 10 words
- `analyze` tasks must depend on data-gathering tasks
- Tools selected at execution time, not planning time

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
| ai_consult | Task (codex agent) |
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

## Open Questions
- Unanswered question 1
- Area needing more research
```

## Output Validation Schema

Research outputs must include:

```yaml
required:
  - executive_summary: "2-3 sentences, main finding first"
  - key_findings: "3-5 findings with evidence"
  - sources: "minimum 3, with URLs"
  - confidence: "high | medium | low with reasoning"

optional:
  - detailed_analysis: "organized by theme"
  - open_questions: "what remains unknown"
  - next_steps: "actionable recommendations"
```

## Multi-AI Integration

For complex topics, plan includes `ai_consult` tasks:

| AI | Strength | Use For |
|----|----------|---------|
| Claude | Nuanced analysis | Synthesis, edge cases |
| Codex | Implementation | Technical details, code |

## Examples

```bash
# Basic research - 3-4 tasks
/research "best practices for micro SaaS pricing 2025"

# Comparative - 4-5 tasks with parallel searches
/research "compare Stripe vs Lemon Squeezy for indie developers"

# Technical deep dive - 5-6 tasks with AI consultation
/research "agentic coding patterns with Claude Code"
```

## Output Locations

- Quick research → Memory fact
- Deep research → `inbox/research-{date}-{topic}.md`
- Project-specific → `research/` directory

## Quality Criteria

- Minimum 3 independent sources
- Cross-verified key facts
- Specific numbers/data where available
- Clear confidence levels
- Main finding in first sentence

## Usage

```bash
# Basic research on a topic
/research "best practices for micro SaaS pricing 2025"

# Comparative analysis
/research "compare Stripe vs Lemon Squeezy for indie developers"

# Technical deep dive
/research "agentic coding patterns with Claude Code"

# Research with existing knowledge check
/research "effective AI prompting techniques"

# Domain-specific research
/research "GDPR compliance requirements for SaaS startups"
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| WebSearch returns no results | Query too specific or topic too niche | Broaden search terms, use alternative phrasing, try related concepts |
| WebFetch timeout | Target URL is slow or blocking requests | Try alternative sources, use cached versions, or summarize from search snippets |
| Conflicting source information | Sources disagree on facts | Note discrepancy in report, weight by source authority, mark confidence as medium/low |
| Existing knowledge outdated | Cached learnings from old research | Proceed with full research, update existing learnings with new findings |
| AI consultation fails | External AI service unavailable | Continue with available tools, note limitation in confidence assessment |

**Fallback**: If research cannot proceed due to tool failures, provide a partial report clearly marking which phases completed, what information was gathered, and recommend manual research steps for missing data.
