---
description: Parallel Dual-AI Verification Mesh - parallel reasoning with cognitive diversity across Claude and Codex
allowed-tools: Task, Bash, Read, Write
---

# Parallel Dual-AI Verification Mesh

Run Claude and Codex simultaneously in isolated forked contexts, then synthesize a verified solution from both perspectives.

## Why Parallel Beats Sequential

| Sequential `/ai-collab` | Parallel `/pv-mesh` |
|------------------------|---------------------|
| 45-60 seconds (serial) | 15-20 seconds (parallel) |
| Context contamination | Isolated forks |
| Same framing for all | AI-specific prompts |
| Prompt variations only | True cognitive diversity |

<instructions>
## Execution Protocol

### Step 1: Launch Parallel Forks

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
  4. Confidence: High (would bet on this) / Medium (reasonable) / Low (speculative) — with brief justification
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
  4. Confidence: High (would bet on this) / Medium (reasonable) / Low (speculative) — with brief justification
  5. What Codex might miss"
)
```

### Step 2: Synthesize

After both return, structure your output as:

1. **Parallel Perspectives** — each AI's approach and key insight
2. **Consensus Analysis** — where both agree (high confidence) vs disagree (trade-offs)
3. **Synthesized Solution** — combined best approach using each AI's specialty contributions
</instructions>

## Usage

```bash
/pv-mesh Should we use GraphQL or REST for this real-time dashboard?
/pv-mesh What's the optimal way to implement a rate limiter?
/pv-mesh Why does our API return 500 errors intermittently under load?
/pv-mesh Is this authentication implementation secure?
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Codex agent unavailable | CLI not installed or API issue | Run two Claude forks with different personas (Implementer, Critic) |
| Task timeout | Complex problem | Retry with simpler problem framing |
| Both agree completely | Obvious answer or groupthink | Ask "what would a contrarian argue?" |
| Both disagree | Genuinely ambiguous | Present both options to user for decision |

## Compared to Other Commands

| Command | Use Case | Speed | Diversity |
|---------|----------|-------|-----------|
| `/pv` | Single-AI parallel hypotheses | Medium | Prompt variations |
| `/ai-collab` | Sequential dual-AI | Slow | True, but serial |
| `/pv-mesh` | Parallel dual-AI | **Fast** | **True + parallel** |
