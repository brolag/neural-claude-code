---
description: AI Collaboration - Dual-AI problem solving with Claude + Codex
allowed-tools: Bash, Task
---

# Dual-AI Collaboration

Collaborate with Codex (OpenAI GPT-5.2) to solve problems using two complementary AI perspectives.

## Problem
$ARGUMENTS

## AI Capabilities (Updated February 2026)

| Model | SWE-bench | Special Strength | Best For |
|-------|-----------|------------------|----------|
| **Claude Opus 4.6** | **80.8%** | 65.4% Terminal-Bench, 1606 Elo GDPval | Architecture, accuracy, planning |
| **Codex (GPT-5.2)** | 80.0% | 64.7% Terminal-Bench | Long sessions, DevOps, implementation |

## Quick Reference: When to Lead with Each AI

- **Need highest accuracy?** → Lead with Claude (80.8% SWE-bench)
- **Terminal/DevOps task?** → Lead with Codex (Terminal-Bench leader)
- **Long autonomous task?** → Use Codex (7+ hour sessions)
- **Architecture/security?** → Lead with Claude
- **Implementation/refactor?** → Lead with Codex

## Collaboration Protocol

### Step 1: Analyze the Problem
Identify which AI strengths are most relevant to this specific problem.

### Step 2: Query Both AIs

**Codex (OpenAI) - Action-oriented, terminal master:**
```bash
codex exec "Problem: <description>. Provide a concise, implementable solution with code."
```

**Claude (Anthropic) - Accuracy leader:**
Provide your own thorough analysis with focus on architecture and edge cases.

### Step 3: Compare Using Strengths

| Aspect | Codex (Implementation) | Claude (Architecture) |
|--------|------------------------|----------------------|
| Approach | | |
| Key Insight | | |
| Unique Value | | |

### Step 4: Synthesize Best Solution

- **Consensus points** = High confidence (both agree)
- **Leverage specialties**: CLI/implementation from Codex, architecture/accuracy from Claude
- **Flag disagreements** - they reveal important trade-offs

## Output Format

```markdown
# Dual-AI Analysis: [Problem Title]

## Task Analysis
- **Problem type**: [algorithmic/architecture/DevOps/etc.]
- **Expected leader**: [AI name based on strengths]

---

## AI Perspectives

### Codex (OpenAI GPT-5.2)
**Strengths applied**: Terminal mastery, action-oriented implementation
[Codex's response]

### Claude (Anthropic Opus 4.6)
**Strengths applied**: Highest accuracy, thorough analysis
[Your analysis]

---

## Comparison Matrix
| Aspect | Codex | Claude |
|--------|-------|--------|
| Approach | | |
| Strengths shown | | |
| Unique insight | | |

---

## Consensus (High Confidence)
[Points where both AIs agree]

## Specialty Contributions
- **From Codex (Implementation/DevOps):** ...
- **From Claude (Architecture/Security):** ...

---

## Synthesized Solution
[Combined best approach leveraging each AI's strengths]

## Implementation
[Final code/solution]
```

## Usage

```bash
# Basic dual-AI collaboration
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
| API rate limit exceeded | Too many requests to external AI | Wait and retry, or use cached responses |
| Network timeout | Slow/unavailable API connection | Check internet connection, retry individual AI queries |
| Empty response from AI | API returned no content | Retry the specific AI query or proceed with available responses |

**Fallback**: If Codex is unavailable, Claude will provide its own comprehensive analysis.
