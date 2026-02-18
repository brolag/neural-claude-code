---
name: super-search
description: Triple-engine research orchestrator combining Perplexity Sonar Pro (deep web), Grok X Search (Twitter/X), and Grok YouTube Search for comprehensive multi-source investigation. Use when user needs thorough research from web + social media + video sources simultaneously.
trigger: /super-search
context: current
allowed-tools: Bash, Read, Write, WebSearch, WebFetch, Task, Glob, Grep
---

# Super Search - Triple-Engine Research Orchestrator

Three search engines running in parallel for maximum research coverage.

## Architecture

```
                         ┌─────────────────────┐
                         │     SUPER SEARCH     │
                         │   Query + Context    │
                         └──────────┬──────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
              ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐
              │ PERPLEXITY │  │  GROK X   │  │ GROK YT   │
              │ Sonar Pro  │  │ x_search  │  │ web_search│
              │            │  │           │  │ (youtube) │
              │ Deep web   │  │ Twitter/X │  │ Videos    │
              │ Citations  │  │ Posts     │  │ Tutorials │
              │ Analysis   │  │ Threads   │  │ Channels  │
              └─────┬─────┘  └─────┬─────┘  └─────┬─────┘
                    │               │               │
                    └───────────────┼───────────────┘
                                    │
                         ┌──────────▼──────────┐
                         │     SYNTHESIS        │
                         │  Merge + Dedupe +    │
                         │  Structured Report   │
                         └─────────────────────┘
```

## Engines

| Engine | Source | API | Best For |
|--------|--------|-----|----------|
| **Perplexity Sonar Pro** | Deep web + academic | OpenRouter | Facts, analysis, citations |
| **Grok X Search** | Twitter/X posts | xAI API | Opinions, trends, discussions |
| **Grok YouTube** | YouTube videos | xAI API (domain filter) | Tutorials, demos, talks |

## When to Use

- "Research X comprehensively" (needs all angles)
- "What are people saying about Y" (social + web)
- "Find tutorials and resources for Z" (YouTube + web)
- "Deep dive into [trending topic]" (real-time + analysis)
- Any research that benefits from web + social + video perspectives

## Usage

```bash
# Full search - all 3 engines in parallel
/super-search "latest developments in AI agent frameworks 2026"

# Specific engines only
/super-search "Claude Code tips" --engines perplexity grok_youtube

# X/Twitter focused with date range
/super-search "Claude Code reviews" --engines grok_x --x-from 2026-01-01

# X search filtered by handles
/super-search "AI agents" --engines grok_x --x-handles alexfinn swyx

# Save results
/super-search "topic" --output inbox/research-topic.md
```

## Execution Steps

When `/super-search "<query>"` is invoked:

### Step 1: Check Existing Knowledge (30 seconds)

Before searching externally, check if we already have relevant knowledge:

```python
# Search inbox and facts
grep -ri "<topic>" inbox/*.md
grep -ri "<topic>" .claude/memory/facts/*.json
```

If existing knowledge found, ask user:
1. Build on existing (focus on gaps/updates)
2. Full search (comprehensive, may overlap)
3. Cancel (existing knowledge sufficient)

### Step 2: Run Python Orchestrator

Execute the parallel search:

```bash
cd "$(git rev-parse --show-toplevel)"
python .claude/skills/super-search/scripts/super_search.py "<query>" [options]
```

**CLI Options:**

| Flag | Description | Default |
|------|-------------|---------|
| `--engines` | Which engines to use | perplexity grok_x grok_youtube |
| `--x-handles` | Filter X to specific accounts | None |
| `--x-from` | X search start date | None |
| `--x-to` | X search end date | None |
| `--max-tokens` | Perplexity response length | 4000 |
| `--output` / `-o` | Save to file | None |
| `--json` | Output as JSON | False |
| `--check` | Verify API keys | False |

### Step 3: Synthesize Results

After receiving results from all engines, create a unified synthesis:

```markdown
# Research: [Topic]

## Executive Summary
[2-3 sentences combining insights from ALL engines]

## Web Research (Perplexity)
[Key findings with citations]

## Social Pulse (X/Twitter)
[Key discussions, opinions, trends]
[Include @handles and engagement metrics]

## Video Resources (YouTube)
[Relevant videos with channels and descriptions]

## Cross-Source Insights
[Patterns that appear across multiple sources]
[Contradictions between sources]

## Sources
- [Web sources from Perplexity]
- [X posts/threads from Grok]
- [YouTube videos from Grok]

## Confidence Assessment
- **Web Coverage**: High/Medium/Low
- **Social Sentiment**: Positive/Mixed/Negative
- **Video Depth**: Comprehensive/Basic/Sparse
```

### Step 4: Save Results

- Deep research -> `inbox/research-{date}-{topic}.md`
- Quick lookup -> display only
- If user requests -> save as memory fact

## Engine Details

### Perplexity Sonar Pro

**Via**: OpenRouter (`OPEN_ROUTER_KEY`)
**Model**: `perplexity/sonar-pro`
**Strengths**: Deep web crawling, source citations, analytical synthesis
**Cost**: ~$0.002-0.005 per query
**Best for**: Factual research, comparisons, technical documentation

### Grok X Search

**Via**: xAI API directly (`XAI_API_KEY`)
**Model**: `grok-4-1-fast`
**Tool**: `x_search`
**Strengths**: Real-time X/Twitter content, trending topics, community sentiment
**Parameters**:
- `from_date` / `to_date`: Date range filtering
- `allowed_x_handles`: Filter to specific accounts (max 10)
**Best for**: Current discussions, opinions, breaking news, community sentiment

### Grok YouTube Search

**Via**: xAI API directly (`XAI_API_KEY`)
**Model**: `grok-4-1-fast`
**Tool**: `web_search` with `allowed_domains: ["youtube.com", "youtu.be"]`
**Strengths**: Video discovery, tutorial finding, expert talks
**Best for**: Learning resources, tutorials, conference talks, demonstrations

## Configuration

### Required Environment Variables

In project `.env`:

```
OPEN_ROUTER_KEY=sk-or-v1-...   # OpenRouter for Perplexity
XAI_API_KEY=xai-...             # xAI for Grok search tools
```

### Verify Setup

```bash
python .claude/skills/super-search/scripts/super_search.py --check "test"
```

## Cost Estimates

| Engine | Per Query | Notes |
|--------|-----------|-------|
| Perplexity Sonar Pro | $0.002-0.005 | Via OpenRouter |
| Grok X Search | ~$0.003-0.008 | xAI API pricing |
| Grok YouTube | ~$0.003-0.008 | Same as web search |
| **Total per /super-search** | **~$0.01-0.02** | All 3 engines |

## Examples

### Technology Research
```bash
/super-search "Cursor vs Windsurf AI coding assistant comparison 2026"
# Perplexity: Technical comparison, features, benchmarks
# Grok X: Developer opinions, adoption stories, complaints
# YouTube: Setup tutorials, reviews, demos
```

### Market Intelligence
```bash
/super-search "electric vehicle market trends 2026" --x-handles elonmusk
# Perplexity: Market data, competitor analysis
# Grok X: Industry chatter, customer feedback
# YouTube: Product demos, case studies
```

### Learning a New Tool
```bash
/super-search "Claude Code agent teams tutorial" --engines perplexity grok_youtube
# Perplexity: Documentation, best practices
# YouTube: Video tutorials, walkthroughs
```

### Trend Monitoring
```bash
/super-search "viral TikTok app trends February 2026" --engines grok_x perplexity
# Perplexity: Trend analysis articles
# Grok X: Real-time viral content, creator discussions
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `OPEN_ROUTER_KEY not set` | Missing env var | Add to `.env` or `export OPEN_ROUTER_KEY=...` |
| `XAI_API_KEY not set` | Missing env var | Add to `.env` or `export XAI_API_KEY=...` |
| Perplexity timeout | Query too complex or API slow | Retry with simpler query or `--max-tokens 2000` |
| Grok 429 rate limit | Too many requests | Wait 30s and retry |
| Empty X results | Topic not discussed on X | Normal - not everything trends on Twitter |
| Empty YouTube results | No videos on topic | Normal - switch to `--engines perplexity grok_web` |

**Fallback**: If an engine fails, the others still return results. The skill degrades gracefully - even one engine provides value. If ALL fail, fall back to built-in `WebSearch` tool.

## Integration with Other Skills

- **`/research`** (deep-research): Use super-search as Phase 3 executor for richer source diversity
- **`/learn`**: Feed super-search results into the learning pipeline
- **`/remember`**: Save key findings as facts
- **`/content`**: Transform research into social media content
