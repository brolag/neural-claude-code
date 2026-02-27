---
description: Parallel Dual-AI Verification Mesh - AlphaGo-style reasoning with cognitive diversity across Claude and Codex
allowed-tools: Task, Bash, Read, Write
---

# Parallel Dual-AI Verification Mesh

Combines AlphaGo-style parallel hypothesis exploration with cognitive diversity by running Claude and Codex simultaneously in forked contexts.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  PARALLEL DUAL-AI VERIFICATION MESH              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Problem: $ARGUMENTS                                             │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ONE MESSAGE - TWO PARALLEL FORKS            │    │
│  │                                                          │    │
│  │  ┌──────────────────┐       ┌──────────────────┐         │    │
│  │  │   CODEX FORK     │       │   CLAUDE FORK    │         │    │
│  │  │   context:fork   │       │   context:fork   │         │    │
│  │  │                  │       │                  │         │    │
│  │  │   Strength:      │       │   Strength:      │         │    │
│  │  │   Terminal       │       │   Accuracy       │         │    │
│  │  │   DevOps         │       │   Architecture   │         │    │
│  │  │   Action         │       │   Edge cases     │         │    │
│  │  └────────┬─────────┘       └────────┬─────────┘         │    │
│  │           │                          │                   │    │
│  │           ▼                          ▼                   │    │
│  │    [Implementation]          [Thorough Analysis]         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    SYNTHESIS PHASE                        │    │
│  │                                                          │    │
│  │  • Compare approaches from 2 genuinely different AIs     │    │
│  │  • Identify consensus (HIGH CONFIDENCE)                  │    │
│  │  • Extract specialty insights from each                  │    │
│  │  • Resolve contradictions with evidence                  │    │
│  │  • Build composite solution                              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   VERIFIED SOLUTION                       │    │
│  │  Dual-AI consensus with cognitive diversity              │    │
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

Launch both agents in a single message with multiple Task tool calls:

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
  5. What the other AI might miss"
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
  5. What Codex might miss"
)
```

### Step 2: Collect and Synthesize

After both return, provide Dual-AI Mesh Verification output with Parallel Perspectives, Consensus Analysis, and Synthesized Solution.

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
| Codex agent unavailable | CLI not installed or API issue | Run two Claude forks with different personas instead |
| Task timeout | Complex problem taking too long | Retry with simpler problem framing |
| Both agents agree completely | Either obvious answer or groupthink | Ask "what would a contrarian argue?" |
| Both agents disagree | Problem is genuinely ambiguous | Present both options to user for decision |

**Fallback**: If Codex fails, run two Claude forks with different personas (Implementer, Critic) to maintain diversity.

## Compared to Other Commands

| Command | Use Case | Speed | Diversity |
|---------|----------|-------|-----------|
| `/pv` | Single-AI parallel hypotheses | Medium | Prompt variations |
| `/ai-collab` | Sequential dual-AI | Slow | True, but serial |
| `/pv-mesh` | Parallel dual-AI | **Fast** | **True + parallel** |

Use `/pv-mesh` when you need both speed AND cognitive diversity.
