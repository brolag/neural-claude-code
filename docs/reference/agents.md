# Reference: Agents

Built-in specialized agents.

---

## Multi-AI Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `codex` | OpenAI Codex routing | DevOps, long sessions, terminal |
| `multi-ai` | Orchestrate both AIs | Critical decisions |
| `dispatcher` | Smart task routing | Optimal AI selection |

---

## Cognitive Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `cognitive-amplifier` | Enhanced decision-making | Complex problems, bias detection |
| `insight-synthesizer` | Cross-domain patterns | Breakthrough ideas |
| `framework-architect` | Transform content | Learning to frameworks |

---

## Development Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `code-reviewer` | Read-only QA | Code review without changes |
| `rapid-prototyper` | Quick MVPs | New projects, experiments |
| `mobile-app-builder` | iOS/Android | React Native, native features |
| `frontend-developer` | UI/UX | React, Vue, CSS |
| `backend-architect` | APIs/databases | Server-side design |
| `ai-engineer` | ML/AI features | LLM integration, ML pipelines |
| `devops-automator` | CI/CD | Deployments, infrastructure |
| `test-writer-fixer` | Testing | Write tests, fix failures |

---

## Research Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `trend-researcher` | Market opportunities | TikTok trends, App Store patterns |
| `feedback-synthesizer` | User feedback | Review analysis |

---

## Product Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `sprint-prioritizer` | Prioritization | 6-day cycle planning |
| `tiktok-strategist` | TikTok marketing | Viral content strategy |
| `project-shipper` | Launch coordination | Release management |
| `studio-producer` | Cross-team coordination | Resource allocation |
| `experiment-tracker` | A/B tests | Feature experiments |

---

## Meta Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `meta-architect` | Create agents | Dynamic agent generation |
| `optimizer` | System improvement | Performance analysis |

---

## Utility Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| `whimsy-injector` | Add delight | UI/UX playfulness |
| `studio-coach` | Team motivation | Complex projects |
| `joker` | Humor | Team morale |
| `neural-reviewer` | Spaced repetition | Knowledge retention |

---

## Using Agents

Agents are invoked via the `Task` tool with `subagent_type`:

```
Use the rapid-prototyper agent to build an MVP
```

Or Claude automatically routes based on task type.

---

## Creating Custom Agents

```bash
/meta:agent my-custom-agent
```

See: [How to: Create Custom Agents](../how-to/meta-agents.md)
