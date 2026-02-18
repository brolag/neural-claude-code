---
description: AI Collaboration - Multi-AI problem solving with Claude, Codex, Gemini
allowed-tools: Bash, Task
---

# Triple-AI Collaboration

Collaborate with Codex (OpenAI) and Gemini (Google) to solve problems using three AI perspectives.

## Problem
$ARGUMENTS

## AI Capabilities (Updated February 2026)

| Model | SWE-bench | Special Strength | Best For |
|-------|-----------|------------------|----------|
| **Claude Opus 4.6** | **80.8%** | 65.4% Terminal-Bench, 1606 Elo GDPval | Complex enterprise, architecture |
| **Codex (GPT-5.2)** | 80.0% | 64.7% Terminal-Bench | Long sessions, DevOps, CLI |
| **Gemini 3 Pro** | 76.2% | 1501 Elo LMArena | Competitive coding, free tier |

## Quick Reference: When to Lead with Each AI

- **Need highest accuracy?** → Lead with Claude (80.8% SWE-bench)
- **Algorithmic problem?** → Lead with Gemini (1501 Elo)
- **Terminal/DevOps task?** → Lead with Codex (Terminal-Bench leader)
- **Budget-conscious?** → Use Gemini (1000 free req/day)
- **Long autonomous task?** → Use Codex (7+ hour sessions)

## Collaboration Protocol

### Step 1: Analyze the Problem
Identify which AI strengths are most relevant to this specific problem.

### Step 2: Query All Three AIs

**Codex (OpenAI) - Action-oriented, terminal master:**
```bash
codex exec "Problem: <description>. Provide a concise, implementable solution with code."
```

**Gemini (Google) - Algorithm king, best free tier:**
```bash
gemini -y "Problem: <description>. Focus on optimal algorithm and modern best practices."
```

**Claude (Anthropic) - Accuracy leader:**
Provide your own thorough analysis with focus on architecture and edge cases.

### Step 3: Compare Using Strengths

| Aspect | Codex (Terminal) | Gemini (Algorithms) | Claude (Accuracy) |
|--------|------------------|---------------------|-------------------|
| Approach | | | |
| Key Insight | | | |
| Unique Value | | | |

### Step 4: Synthesize Best Solution

- **Consensus points** = High confidence (all 3 agree)
- **Leverage specialties**: CLI from Codex, algorithms from Gemini, architecture from Claude
- **Flag disagreements** - they reveal important trade-offs

## Output Format

```markdown
# Multi-AI Analysis: [Problem Title]

## Task Analysis
- **Problem type**: [algorithmic/architecture/DevOps/etc.]
- **Expected leader**: [AI name based on strengths]

---

## AI Perspectives

### 🔵 Codex (OpenAI GPT-5.2)
**Strengths applied**: Terminal mastery, action-oriented
[Codex's response]

### 🔴 Gemini (Google Gemini 3 Pro)
**Strengths applied**: Algorithmic excellence, modern practices
[Gemini's response]

### 🟣 Claude (Anthropic Opus 4.6)
**Strengths applied**: Highest accuracy, thorough analysis
[Your analysis]

---

## Comparison Matrix
| Aspect | Codex | Gemini | Claude |
|--------|-------|--------|--------|
| Approach | | | |
| Strengths shown | | | |
| Unique insight | | | |

---

## Consensus (High Confidence)
[Points where all three AIs agree]

## Specialty Contributions
- **From Codex (DevOps/Terminal):** ...
- **From Gemini (Algorithms):** ...
- **From Claude (Architecture):** ...

---

## Synthesized Solution
[Combined best approach leveraging each AI's strengths]

## Implementation
[Final code/solution]

---

## Collaboration Insights
[What we learned from combining three perspectives]
```

## Cost & Speed Reference

| AI | Typical Cost | Speed | Free Tier |
|----|--------------|-------|-----------|
| Claude | ~$4.80/task | Fastest | No |
| Gemini | ~$7.06/task | Moderate | Yes (1000/day) |
| Codex | Variable | Best for long | No |

## Usage

```bash
# Basic multi-AI collaboration
/ai-collab How should I structure my microservices architecture?

# Algorithm optimization problem
/ai-collab What's the most efficient way to implement a rate limiter?

# DevOps and infrastructure question
/ai-collab How should I set up CI/CD for a monorepo with multiple services?

# Code review with multiple perspectives
/ai-collab Review this authentication implementation for security issues

# Architecture decision
/ai-collab Should I use GraphQL or REST for this real-time dashboard?
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `codex: command not found` | Codex CLI not installed | Install with `npm install -g @openai/codex` or skip Codex perspective |
| `gemini: command not found` | Gemini CLI not installed | Install Gemini CLI or skip Gemini perspective |
| API rate limit exceeded | Too many requests to external AI | Wait and retry, or use cached responses |
| Network timeout | Slow/unavailable API connection | Check internet connection, retry individual AI queries |
| Empty response from AI | API returned no content | Retry the specific AI query or proceed with available responses |

**Fallback**: If external AIs are unavailable, Claude will provide its own comprehensive analysis. You can also query AIs individually using `codex exec "..."` or `gemini -y "..."` commands directly.

## Sources

- Render Blog: https://render.com/blog/ai-coding-agents-benchmark
- Composio: https://composio.dev/blog/claude-4-5-opus-vs-gemini-3-pro-vs-gpt-5-codex-max-the-sota-coding-model
- CodeAnt: https://www.codeant.ai/blogs/claude-code-cli-vs-codex-cli-vs-gemini-cli-best-ai-cli-tool-for-developers-in-2025
