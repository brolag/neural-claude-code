---
description: Parallel Verification - AlphaGo-style multi-path reasoning
allowed-tools: Task, Read, Glob, Grep
---

# Parallel Verification Command

AlphaGo-style parallel hypothesis exploration for complex problems.

## Usage

```bash
/pv <problem>                    # Run parallel verification
/pv <problem> --paths 5          # Use 5 hypotheses (default: 4)
/pv <problem> --multi-ai         # Use different AI models per path
```

## Description

AlphaGo-style parallel hypothesis exploration. Instead of sequential chain-of-thought, this command:

1. **Diverges** into 3-5 distinct hypotheses
2. **Explores** each path in parallel using multiple agents
3. **Verifies** results against each other
4. **Converges** on the strongest solution

## Prompt

You are executing the Parallel Verification skill. The user has a problem that requires multi-path reasoning.

**Problem**: $ARGUMENTS

---

## PHASE 1: DIVERGE

Generate 4 fundamentally different hypotheses or approaches to this problem. Each must be:
- Distinct (not minor variations)
- Testable (can be proven right or wrong)
- Complete (a full approach)

Format:
```
### Hypothesis 1: [Name]
**Approach**: [Description]
**Key Assumption**: [What this assumes to be true]

### Hypothesis 2: [Name]
...
```

Present these hypotheses to the user, then proceed to Phase 2.

---

## PHASE 2: EXPLORE (Parallel)

Launch 4 agents in parallel using the Task tool. Each agent explores ONE hypothesis deeply.

Use a single message with 4 Task tool calls to run them in parallel.

For each agent, use this prompt:
"""
You are exploring ONE hypothesis for this problem.

**Problem**: [THE PROBLEM]
**Your Hypothesis**: [HYPOTHESIS N]

Fully develop this approach:
1. Work through the solution completely
2. Note difficulties or contradictions
3. Rate confidence (1-10) with justification
4. Identify strongest and weakest points

Output:
- **Solution**: [Complete solution]
- **Confidence**: [1-10]
- **Strengths**: [What works]
- **Weaknesses**: [Potential issues]
- **Key Insight**: [Core idea]
"""

Use `subagent_type: "general-purpose"` for each.

---

## PHASE 3: VERIFY

After collecting all parallel results, cross-check:

1. **Contradictions**: Do solutions contradict? At least one is wrong.
2. **Edge Cases**: Test each against extreme scenarios
3. **Logic Audit**: Trace reasoning for fallacies
4. **Consensus**: Where do paths agree? (Higher confidence)

---

## PHASE 4: CONVERGE

Synthesize the final answer:

```markdown
## Solution

**Winning Approach**: [Best solution, possibly combining elements]

**Why This Wins**:
- [Evidence]
- [Strengths over alternatives]

**Pruned Paths**:
- [Path X failed because...]
- [Path Y was close but...]

**Confidence**: [High/Medium/Low]

**Remaining Uncertainties**: [What we're not 100% sure about]
```

---

## Multi-AI Enhancement (Optional)

For maximum verification, suggest using different models:
- Path 1: Claude Opus (accuracy)
- Path 2: Codex (implementation)
- Path 3: Claude Opus (cross-check)
- Path 4: Claude Opus (contrarian)

Use `/ai-collab` integration if the user wants multi-model verification.

## Output Format

```markdown
## Parallel Verification Results

**Problem**: [Original problem]
**Hypotheses Explored**: 4
**Winning Approach**: [Name]

### Solution
[Complete solution with reasoning]

### Confidence: [High/Medium/Low]

### Why This Wins
- [Evidence from verification]
- [Strengths over alternatives]

### Pruned Paths
| Path | Reason for Elimination |
|------|------------------------|
| [Name] | [Why it failed] |

### Remaining Uncertainties
- [What we're not 100% sure about]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No hypotheses generated | Problem too vague | Rephrase with specific context |
| All paths fail | Problem unsolvable with current info | Gather more data, retry |
| Agents timeout | Complex exploration | Increase timeout or simplify |
| Contradictory results | Ambiguous problem | Run verification phase again |

**Fallback**: If parallel agents fail, fall back to sequential exploration.
