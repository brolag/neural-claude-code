---
description: Smart Task Router - Optimize AI routing for cost/quality
allowed-tools: Bash, Read, Write
---

# Smart Task Router

Analyze tasks and recommend the optimal AI model for cost/quality optimization.

## Usage

```bash
/route <task description>        # Get routing recommendation
/route implement sorting algo    # Example: routes to Codex
/route review auth security      # Example: stays in Opus
```

## Prompt

Analyze the following task and recommend the optimal AI routing:

**Task**: $ARGUMENTS

---

## Decision Matrix

### Route to LOCAL (Qwen) - FREE

**Keywords**: boilerplate, example, explain, syntax, simple, quick
**Characteristics**:
- Input < 5K tokens expected
- No file writes required
- Explanation or generation of simple code
- Syntax questions

**Command**: `ollama run qwen2.5-coder:7b "<task>"`

**Savings**: 100% (vs Opus)

---

### Route to CODEX - 65% savings

**Keywords**: algorithm, implement, execute, prototype, parse, transform, deploy, CI/CD, terminal, script, devops, bash, shell
**Characteristics**:
- Clear, well-defined implementation task
- Algorithmic problems
- Requires Bash/terminal operations
- DevOps automation
- Long-running task (>30 min)
- CLI tool creation
- Code review
- Data transformation or parsing
- Repetitive multi-step tasks
- Part of /plan-execute workflow

**Command**: `codex exec "<task>"`

**Savings**: 65-75% (vs Opus)

---

### Keep in OPUS - Premium accuracy

**Keywords**: architecture, design, security, critical, complex, multi-file
**Characteristics**:
- Security-sensitive code
- Complex architectural decisions
- Multi-file coordination with dependencies
- First-time implementation of novel patterns
- Financial/legal logic
- User explicitly requests accuracy

**Command**: Stay in current context

**When bugs cost more than token savings, use Opus.**

---

## Output Format

```markdown
## Routing Recommendation

**Task**: [Analyzed task]

**Recommended**: [Qwen | Codex | Opus]

**Reasoning**: [Why this is optimal]

**Cost Comparison**:
- Opus: ~$X.XX (estimated)
- Recommended: ~$X.XX
- **Savings**: XX%

**Command to Run**:
```
[Ready-to-execute command]
```

**Confidence**: [High | Medium | Low]
- High: Clear match to routing rules
- Medium: Could go either way
- Low: Edge case, consider Opus
```

---

## Plan-Execute Pattern

For complex multi-step tasks, recommend the full pattern:

```
1. OPUS plans (5-10% of tokens)
2. CODEX executes (70-80% of tokens)
3. OPUS reviews (10-20% of tokens)

Total savings: 50-60%
```

**Trigger**: Task has 3+ distinct steps, well-defined goal

---

## Examples

### Example 1: Algorithm Task

**Input**: `/route implement binary search in Python`

**Output**:
```
## Routing Recommendation

**Task**: Implement binary search in Python

**Recommended**: Codex

**Reasoning**: Clear algorithm implementation, well-defined output.
Codex (GPT-5.2) excels at implementation tasks.

**Cost Comparison**:
- Opus: ~$0.15
- Codex: ~$0.05
- **Savings**: 67%

**Command to Run**:
codex exec "Implement binary search in Python with edge case handling"

**Confidence**: High
```

### Example 2: Security Task

**Input**: `/route review authentication flow for vulnerabilities`

**Output**:
```
## Routing Recommendation

**Task**: Review authentication flow for vulnerabilities

**Recommended**: Opus (stay in context)

**Reasoning**: Security-sensitive analysis. Bugs here are expensive.
Opus 4.6 achieves 80.8% SWE-bench - accuracy matters for security code.

**Cost Comparison**:
- Opus: ~$0.40
- Alternative: Not recommended for security

**Confidence**: High - Security tasks always use Opus
```

### Example 3: DevOps Task

**Input**: `/route set up GitHub Actions CI/CD pipeline`

**Output**:
```
## Routing Recommendation

**Task**: Set up GitHub Actions CI/CD pipeline

**Recommended**: Codex

**Reasoning**: Terminal-heavy, DevOps automation, likely requires
multiple bash commands. Codex is Terminal-Bench leader.

**Cost Comparison**:
- Opus: ~$0.80
- Codex: ~$0.28
- **Savings**: 65%

**Command to Run**:
codex exec "Set up GitHub Actions CI/CD pipeline with test, build, and deploy stages"

**Confidence**: High
```

---

## Quick Reference

| Task Type | Route | Savings |
|-----------|-------|---------|
| Boilerplate/examples | Qwen | 100% |
| Algorithms | Codex | 65% |
| Data parsing | Codex | 65% |
| DevOps/terminal | Codex | 65% |
| Code review | Codex | 65% |
| Long sessions | Codex | 65% |
| Implementation | Codex | 65% |
| Architecture | Opus | 0% |
| Security | Opus | 0% |
| Multi-file complex | Opus | 0% |

---

## Cost Tracking

After routing, log the decision:

```json
{
  "timestamp": "2026-02-22T10:00:00Z",
  "task": "implement binary search",
  "routed_to": "codex",
  "estimated_savings": 0.10,
  "confidence": "high"
}
```

Append to: `.claude/memory/costs.json`

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| CLI not found | Codex not installed | Install CLI or stay in Opus |
| Task unclear | Ambiguous description | Rephrase with specific action verbs |
| API unavailable | External service down | Fall back to Opus |
| Low confidence | Edge case task | Default to Opus for safety |

**Fallback**: When uncertain, always recommend Opus (accuracy over savings).
