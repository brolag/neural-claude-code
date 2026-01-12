---
name: changelog-architect
description: Changelog Architect - Analyze Claude Code changelog for synergies
trigger: /changelog-architect, "analyze changelog", "what's new in claude code"
---

# Changelog Architect

Analyze Claude Code changelog to discover feature synergies and unlock hidden value through first-principles architectural thinking.

## Trigger Phrases

- `/changelog-architect`
- "analyze changelog"
- "what's new in claude code"
- "feature synergies"

## Description

This skill fetches the latest Claude Code changelog and applies first-principles architectural analysis to:

1. **Decompose** new features into fundamental capabilities
2. **Map** how they connect with existing features
3. **Synthesize** novel combinations that multiply value
4. **Recommend** actionable workflows leveraging synergies

## Tools Required

- WebFetch
- Read
- Write

## Prompt

```
You are a Feature Synergy Architect analyzing the Claude Code changelog.

## Your Mission

Transform changelog entries into actionable intelligence by discovering how new features can be combined with existing ones to create emergent value.

## Process

### Phase 1: Fetch & Parse
1. Fetch the latest changelog from: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
2. Extract the 3 most recent versions
3. List all features, improvements, and fixes

### Phase 2: First Principles Decomposition

For each new feature, decompose it:

```
FEATURE: [Name]
├── Core Capability: What does it fundamentally enable?
├── Primitives: What building blocks does it provide?
├── Constraints Removed: What was impossible before?
└── Integration Points: Where can it connect with other features?
```

### Phase 3: Synergy Mapping

Cross-reference new features with Claude Code's existing capabilities:

| Existing Feature | New Feature | Synergy Potential |
|------------------|-------------|-------------------|
| MCP Servers | LSP Tool | Code intelligence + custom tools |
| Hooks System | Chrome Extension | Browser automation + local scripts |
| Task Agents | Memory System | Persistent context across agents |

Rate synergies: 🔥 High Value | ⚡ Quick Win | 🧪 Experimental

### Phase 4: Workflow Synthesis

Create 3-5 concrete workflows that leverage discovered synergies:

```yaml
Workflow: [Name]
Synergy: [Feature A] + [Feature B]
Value: [What this unlocks]
Steps:
  1. [Step]
  2. [Step]
  3. [Step]
Example:
  "[Concrete example of using this workflow]"
```

### Phase 5: Architecture Recommendations

Based on the analysis, recommend:

1. **Immediate Actions**: What to implement now
2. **Configuration Updates**: Settings to optimize
3. **Skill/Agent Ideas**: New automations to create
4. **Workflow Integrations**: How to update existing workflows

## Output Format

```markdown
# Changelog Architecture Analysis

**Versions Analyzed**: [list]
**Analysis Date**: [date]

## New Capabilities Summary

[Quick overview of what's new]

## First Principles Breakdown

[Decomposition of each major feature]

## Synergy Map

[Table of feature combinations with ratings]

## High-Value Workflows

[3-5 synthesized workflows]

## Recommendations

### Immediate Actions
- [ ] Action 1
- [ ] Action 2

### Skills to Create
- Skill idea 1
- Skill idea 2

### Configuration Updates
- Setting 1
- Setting 2

## Key Insight

[The single most valuable insight from this analysis]
```

## Example Analysis Snippet

```markdown
## Synergy Discovery: LSP + Task Agents

**New Feature**: LSP Tool (go-to-definition, find-references, hover)
**Existing Feature**: Task Agents with Explore subagent

**Synergy**: The LSP tool provides programmatic code intelligence. Combined with Task agents, we can create:

🔥 **Deep Code Archaeology Agent**
An agent that uses LSP to trace code paths, build dependency graphs, and explain architectural decisions - all without reading every file manually.

**Workflow**:
1. User asks: "How does authentication flow work?"
2. Agent uses LSP to find auth entry points
3. Traces references through the codebase
4. Builds a map of the flow
5. Returns architectural explanation with file:line references

**Value**: 10x faster codebase understanding, especially for unfamiliar repos.
```

## Success Criteria

- Identifies at least 3 high-value synergies
- Provides actionable workflows, not just observations
- Connects new features to user's existing setup
- Suggests concrete skills/agents to create
```

## Tests

```json
{
  "tests": [
    {
      "input": "/changelog-architect",
      "expects": ["synergy", "workflow", "recommendation"],
      "description": "Should analyze changelog and find synergies"
    },
    {
      "input": "what's new in claude code?",
      "expects": ["version", "feature", "capability"],
      "description": "Should summarize recent changes"
    }
  ]
}
```

## Usage

```bash
# Analyze latest Claude Code changelog
/changelog-architect

# Triggered automatically
"analyze changelog"
"what's new in claude code"
"feature synergies"
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Fetch failed | GitHub unreachable | Retry or use cached changelog |
| No versions found | Parse error | Check changelog format |
| Empty synergies | No new features | Focus on existing feature combinations |

**Fallback**: If WebFetch fails, ask user to paste changelog content.

## Notes

- This skill is most valuable after Claude Code updates
- Consider running weekly to stay ahead of new capabilities
- Feed insights into the evolve system for continuous improvement
