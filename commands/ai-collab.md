---
description: AI Collaboration - Dual-AI problem solving with Claude + Codex
allowed-tools: Bash, Task
---

# Dual-AI Collaboration

Collaborate with Codex (OpenAI GPT-5.2) to solve problems using two complementary AI perspectives.

## Problem
$ARGUMENTS

<context>
## AI Capabilities (February 2026)

| Model | SWE-bench | Special Strength | Best For |
|-------|-----------|------------------|----------|
| **Claude Opus 4.6** | **80.8%** | 65.4% Terminal-Bench, 1606 Elo GDPval | Architecture, accuracy, planning |
| **Codex (GPT-5.2)** | 80.0% | 64.7% Terminal-Bench | Long sessions, DevOps, implementation |

**Routing**: Accuracy/architecture → Claude leads. Terminal/DevOps/long sessions → Codex leads. High-stakes → both.
</context>

<instructions>
## Collaboration Protocol

### Step 1: Analyze the Problem
Identify which AI strengths are most relevant to this specific problem.

### Step 2: Query Both AIs

**Codex** — action-oriented, terminal master:
```bash
codex exec "Problem: <description>. Provide a concise, implementable solution with code."
```

**Claude** — accuracy leader:
Provide your own thorough analysis with focus on architecture and edge cases.

### Step 3: Synthesize

- **Consensus** = high confidence (both agree)
- **Use specialties**: CLI/implementation from Codex, architecture/accuracy from Claude
- **Disagreements** reveal important trade-offs — present them

### Output Structure

1. **Task Analysis** — problem type and expected leader
2. **Codex Perspective** — strengths applied + response
3. **Claude Perspective** — strengths applied + your analysis
4. **Consensus** — where both agree
5. **Specialty Contributions** — unique insights from each
6. **Synthesized Solution** — combined best approach with implementation
</instructions>

## Usage

```bash
/ai-collab How should I structure my microservices architecture?
/ai-collab What's the most efficient way to implement a rate limiter?
/ai-collab How should I set up CI/CD for a monorepo with multiple services?
/ai-collab Review this authentication implementation for security issues
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `codex: command not found` | CLI not installed | Install with `npm install -g @openai/codex` or skip Codex |
| API rate limit / timeout | Too many requests or slow connection | Wait and retry |
| Empty response | API returned no content | Retry or proceed with available responses |

**Fallback**: If Codex is unavailable, provide comprehensive single-AI analysis.
