---
description: Parallel Multi-AI Verification Mesh - AlphaGo-style reasoning with cognitive diversity across Claude, Codex, and Gemini
allowed-tools: Task, Bash, Read, Write
---

# Parallel Multi-AI Verification Mesh

Combines AlphaGo-style parallel hypothesis exploration with true cognitive diversity by running Claude, Codex, and Gemini simultaneously in forked contexts.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  PARALLEL MULTI-AI VERIFICATION MESH             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Problem: $ARGUMENTS                                             │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ONE MESSAGE - THREE PARALLEL FORKS          │    │
│  │                                                          │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │    │
│  │  │ CODEX FORK  │  │ GEMINI FORK │  │ CLAUDE FORK │      │    │
│  │  │ context:fork│  │ context:fork│  │ context:fork│      │    │
│  │  │             │  │             │  │             │      │    │
│  │  │ Strength:   │  │ Strength:   │  │ Strength:   │      │    │
│  │  │ Terminal    │  │ Algorithms  │  │ Accuracy    │      │    │
│  │  │ DevOps      │  │ Performance │  │ Architecture│      │    │
│  │  │ Action      │  │ Elegance    │  │ Edge cases  │      │    │
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘      │    │
│  │         │                │                │              │    │
│  │         ▼                ▼                ▼              │    │
│  │  [Implementation] [Optimal Algo] [Thorough Analysis]    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    SYNTHESIS PHASE                        │    │
│  │                                                          │    │
│  │  • Compare approaches from 3 genuinely different AIs     │    │
│  │  • Identify consensus (HIGH CONFIDENCE)                  │    │
│  │  • Extract specialty insights from each                  │    │
│  │  • Resolve contradictions with evidence                  │    │
│  │  • Build composite solution                              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   VERIFIED SOLUTION                       │    │
│  │  Multi-AI consensus with cognitive diversity             │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Why This Is Powerful

| Sequential `/ai-collab` | Parallel `/pv-mesh` |
|------------------------|---------------------|
| 45-60 seconds (serial) | 15-20 seconds (parallel) |
| Context contamination | Isolated forks |
| Same framing for all | AI-specific prompts |
| Prompt variations only | True cognitive diversity |

## Execution Protocol

When invoked with a problem:

### Step 1: Launch Parallel Forks (ONE MESSAGE)

You MUST launch all three agents in a SINGLE message with multiple Task tool calls:

**Codex Fork**:
```
Task(
  subagent_type: "codex",
  prompt: "Problem: $ARGUMENTS

  You are Codex, excelling at terminal operations and practical implementation.

  Approach this with your strengths:
  - Focus on actionable implementation
  - Consider DevOps and deployment aspects
  - Think about CLI and terminal solutions
  - Prioritize getting something working

  Output:
  1. Your approach (2-3 sentences)
  2. Key implementation insight
  3. Code or commands
  4. Confidence (1-10)
  5. What Claude/Gemini might miss"
)
```

**Gemini Fork**:
```
Task(
  subagent_type: "gemini",
  prompt: "Problem: $ARGUMENTS

  You are Gemini, excelling at algorithms and optimal solutions.

  Approach this with your strengths:
  - Focus on algorithmic efficiency
  - Consider performance implications
  - Think about elegant, modern solutions
  - Prioritize optimal approach

  Output:
  1. Your approach (2-3 sentences)
  2. Key algorithmic insight
  3. Code or solution
  4. Confidence (1-10)
  5. What Claude/Codex might miss"
)
```

**Claude Fork**:
```
Task(
  subagent_type: "general-purpose",
  prompt: "Problem: $ARGUMENTS

  You are a Claude instance, excelling at accuracy and thorough analysis.

  Approach this with your strengths:
  - Focus on correctness and edge cases
  - Consider architectural implications
  - Think about maintainability and clarity
  - Prioritize getting it right

  Output:
  1. Your approach (2-3 sentences)
  2. Key insight others might miss
  3. Solution with edge case handling
  4. Confidence (1-10)
  5. What Codex/Gemini might miss"
)
```

### Step 2: Collect and Synthesize

After all three return, provide Multi-AI Mesh Verification output with Parallel Perspectives, Consensus Analysis, and Synthesized Solution.

## Usage

```bash
# Architecture decision
/pv-mesh Should we use GraphQL or REST for this real-time dashboard?

# Algorithm optimization
/pv-mesh What's the optimal way to implement a rate limiter?

# Debugging complex issues
/pv-mesh Why does our API return 500 errors intermittently under load?

# Code review
/pv-mesh Is this authentication implementation secure?

# Strategic technical decision
/pv-mesh Microservices or monolith for our 3-person startup?
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Codex agent unavailable | CLI not installed or API issue | Continue with Gemini + Claude only, note reduced diversity |
| Gemini agent unavailable | CLI not installed or API issue | Continue with Codex + Claude only, note reduced diversity |
| Task timeout | Complex problem taking too long | Retry with simpler problem framing |
| All agents agree completely | Either obvious answer or groupthink | Ask "what would a contrarian argue?" |
| All agents disagree | Problem is genuinely ambiguous | Present all three options to user for decision |

**Fallback**: If external AIs fail, run three Claude forks with different personas (Implementer, Optimizer, Critic) to maintain diversity.

## Compared to Other Commands

| Command | Use Case | Speed | Diversity |
|---------|----------|-------|-----------|
| `/pv` | Single-AI parallel hypotheses | Medium | Prompt variations |
| `/ai-collab` | Sequential multi-AI | Slow | True, but serial |
| `/pv-mesh` | Parallel multi-AI | **Fast** | **True + parallel** |

Use `/pv-mesh` when you need both speed AND cognitive diversity.
