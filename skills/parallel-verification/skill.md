---
name: parallel-verification
description: AlphaGo-style parallel hypothesis exploration and verification
trigger: /pv, "parallel verify", "explore hypotheses", "multi-path reasoning"
---

# Parallel Verification Skill

Implements AlphaGo-style parallel hypothesis exploration and verification.
Instead of sequential chain-of-thought, explores multiple reasoning paths simultaneously and lets the best solution emerge through cross-verification.

## Trigger

- User says "parallel verify", "explore hypotheses", "multi-path reasoning"
- Complex problems where correctness matters more than speed
- Mathematical proofs, debugging, strategic planning, scientific reasoning
- Command: `/pv <problem>`

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     PARALLEL VERIFICATION                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────┐                                                   │
│  │  PROBLEM │                                                   │
│  └────┬─────┘                                                   │
│       │                                                         │
│       ▼                                                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    1. DIVERGE PHASE                       │  │
│  │         Generate 3-5 distinct hypotheses/approaches       │  │
│  └──────────────────────────────────────────────────────────┘  │
│       │                                                         │
│       ▼                                                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    2. EXPLORE PHASE                       │  │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      │  │
│  │  │ Agent 1 │  │ Agent 2 │  │ Agent 3 │  │ Agent N │      │  │
│  │  │ Path A  │  │ Path B  │  │ Path C  │  │ Path N  │      │  │
│  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘      │  │
│  │       │            │            │            │            │  │
│  │       ▼            ▼            ▼            ▼            │  │
│  │  [Result A]   [Result B]   [Result C]   [Result N]       │  │
│  └──────────────────────────────────────────────────────────┘  │
│       │                                                         │
│       ▼                                                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    3. VERIFY PHASE                        │  │
│  │  • Cross-check results for contradictions                 │  │
│  │  • Test each solution against edge cases                  │  │
│  │  • Identify reasoning errors in failing paths             │  │
│  │  • Build confidence scores                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│       │                                                         │
│       ▼                                                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    4. CONVERGE PHASE                      │  │
│  │  • Synthesize strongest elements from all paths           │  │
│  │  • Explain why winning solution is correct                │  │
│  │  • Document pruned paths and why they failed              │  │
│  └──────────────────────────────────────────────────────────┘  │
│       │                                                         │
│       ▼                                                         │
│  ┌──────────┐                                                   │
│  │ SOLUTION │                                                   │
│  └──────────┘                                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Execution

### Phase 1: Diverge

Before exploring, generate distinct hypotheses:

```markdown
## Hypothesis Generation

Given the problem: $PROBLEM

Generate 3-5 fundamentally different approaches:

1. **Hypothesis A** (Conservative): [Most straightforward interpretation]
2. **Hypothesis B** (Alternative): [Different angle or assumption]
3. **Hypothesis C** (Contrarian): [Challenge the obvious approach]
4. **Hypothesis D** (Edge case): [What if a key assumption is wrong?]
5. **Hypothesis E** (Synthesis): [Combine elements unexpectedly]

Each hypothesis should be:
- Distinct (not minor variations)
- Testable (can be proven right or wrong)
- Complete (a full approach, not partial)
```

### Phase 2: Explore (Parallel)

Launch parallel agents using the Task tool:

```markdown
## Parallel Exploration

For each hypothesis, spawn an agent with:

**Agent Prompt Template:**
"""
You are exploring ONE specific hypothesis for this problem:

**Problem**: $PROBLEM

**Your Hypothesis**: $HYPOTHESIS_N

**Your Mission**:
1. Fully develop this approach as if it's correct
2. Work through the solution completely
3. Note any difficulties or contradictions you encounter
4. Rate your confidence (1-10) with justification
5. Identify the strongest and weakest points

**Output Format**:
- Solution: [Your complete solution]
- Confidence: [1-10]
- Strengths: [What works well about this approach]
- Weaknesses: [Potential issues or gaps]
- Key Insight: [The core idea that makes this work or fail]
"""

Launch ALL agents in parallel (single message, multiple Task calls).
Use subagent_type: "general-purpose" or "cognitive-amplifier" for complex reasoning.
```

### Phase 3: Verify

Cross-check all results:

```markdown
## Verification Protocol

With all parallel results collected:

1. **Contradiction Check**
   - Do any solutions directly contradict each other?
   - If yes, at least one is wrong - identify which

2. **Edge Case Testing**
   - Test each solution against extreme cases
   - Does the solution hold under stress?

3. **Reasoning Audit**
   - Trace the logic of each path
   - Identify any logical fallacies or gaps

4. **Confidence Calibration**
   - Compare self-reported confidence vs actual quality
   - Overconfident paths often have hidden flaws

5. **Consensus Analysis**
   - Where do multiple paths agree? (Higher confidence)
   - Where do they diverge? (Needs investigation)
```

### Phase 4: Converge

Synthesize the final answer:

```markdown
## Convergence Synthesis

**Winning Solution**: [The best approach, possibly combining elements]

**Why This Wins**:
- [Evidence from verification]
- [Strengths over alternatives]

**Pruned Paths**:
- Path X failed because: [specific reason]
- Path Y was close but: [what was missing]

**Confidence Level**: [High/Medium/Low with justification]

**Remaining Uncertainties**: [What we're still not 100% sure about]
```

## Best For

| Domain | Why Parallel Verification Helps |
|--------|--------------------------------|
| Mathematical proofs | One error ruins everything - multiple paths catch errors |
| Code debugging | Multiple possible bugs - parallel exploration finds root cause |
| Strategic planning | Decision trees need exploration before commitment |
| Scientific reasoning | Hypothesis testing is inherently parallel |
| Architecture decisions | Trade-offs need multi-angle analysis |
| Complex debugging | Unknown cause needs hypothesis elimination |

## Configuration

```yaml
# Default settings
num_hypotheses: 4      # How many parallel paths
agent_type: general-purpose  # Or cognitive-amplifier for hard problems
timeout_per_agent: 120s
require_consensus: false  # If true, all paths must agree
min_confidence: 7      # Threshold for accepting a solution
```

## Example Usage

**Input**:
```
/pv Why is our API returning 500 errors intermittently?
```

**Diverge Output**:
1. Database connection pool exhaustion
2. Memory leak causing OOM
3. Race condition in concurrent requests
4. External service timeout cascading
5. Log rotation causing file descriptor issues

**Explore**: 5 agents investigate in parallel

**Verify**: Cross-check findings, test hypotheses

**Converge**: "Database connection pool exhaustion confirmed. Evidence: [details]. Other hypotheses ruled out because: [reasons]."

## Multi-AI Enhancement

For maximum verification power, use different AI models per path:

| Path | Model | Strength |
|------|-------|----------|
| Path A | Claude Opus | Accuracy, nuance |
| Path B | Codex | Implementation, terminal |
| Path C | Gemini | Algorithms, speed |
| Path D | Claude Opus | Cross-verification |

This creates true cognitive diversity, not just prompt variations.

## Integration

Works with:
- `/ai-collab` - Can be used as the reasoning engine
- `cognitive-amplifier` agent - Enhanced for complex problems
- `multi-ai` agent - For cross-model verification

## Usage

```bash
# Basic parallel verification
/pv "Why is our API returning 500 errors intermittently?"

# With custom hypothesis count
/pv "Debug the flaky test" --paths 5

# Multi-AI mode (different models per path)
/pv "Architecture decision" --multi-ai

# Quick mode (3 paths, faster convergence)
/pv "Simple problem" --quick
```

## Output Format

```markdown
## Parallel Verification Complete

**Problem**: [statement]
**Hypotheses Explored**: [n]
**Winner**: Hypothesis [X]

### Hypothesis Summary
| Path | Approach | Confidence | Status |
|------|----------|------------|--------|
| A | [approach] | 8/10 | ✅ Winner |
| B | [approach] | 4/10 | ❌ Ruled out |
| C | [approach] | 6/10 | ⚠️ Partial |

### Solution
[Detailed winning solution]

### Evidence
- [Evidence 1]
- [Evidence 2]

### Pruned Paths
- Path B failed because: [reason]
- Path C was close but: [missing element]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| All paths low confidence | Problem too ambiguous | Rephrase with more context |
| Agent timeout | Complex hypothesis | Increase timeout or simplify |
| No consensus | Genuinely uncertain | Report uncertainty, suggest more data |
| Contradictory results | Flawed hypotheses | Re-diverge with better framing |

**Fallback**: If parallel execution fails, run hypotheses sequentially.

## Metrics

Track:
- Hypothesis coverage (did we consider the right paths?)
- Pruning accuracy (did we correctly eliminate wrong paths?)
- Convergence time (how quickly did we reach consensus?)
- Solution correctness (was the final answer right?)
