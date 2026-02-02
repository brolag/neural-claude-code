# Reference: Skills

Reusable skills that extend Claude Code capabilities. Install with `/install-skills`, manage with `/manage-skills`.

---

## Core Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `memory-system` | `/remember`, `/recall`, `/forget` | Persistent memory |
| `project-setup` | `/setup`, "init project" | Initialize .claude structure |
| `evaluator` | `/eval` | Run evaluation tests |

---

## Development Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `debugging` | `/debug` | Systematic 4-phase root cause analysis |
| `tdd` | `/tdd` | RED-GREEN-REFACTOR cycle enforcement |
| `react-best-practices` | React code | 40+ optimization rules from Vercel Engineering |
| `parallel-verification` | `/pv` | AlphaGo-style verification |

---

## Code Quality Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `slop-scan` | `/slop-scan` | Detect technical debt and code smells |
| `slop-fix` | `/slop-fix` | Auto-fix safe issues (needs slop-scan) |
| `overseer` | `/overseer` | Review PRs/diffs before merge |
| `stop-slop` | Text editing | Remove AI writing patterns from prose |

---

## Research & Learning Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `deep-research` | `/research` | Multi-phase orchestrated research |
| `youtube-learner` | `/yt-learn <url>` | Extract from YouTube videos |
| `content-creation` | Content requests | Create from knowledge |
| `newsletter-launch` | `/newsletter` | Full content pack from research |

---

## Knowledge & Planning Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `knowledge-management` | `/capture`, `/connect` | PARA-based second brain |
| `planning` | Planning requests | GTD/PARA methodologies |
| `energy-system` | Energy mentions | Track energy levels |

---

## Workflow Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `worktree-manager` | `/wt-*` commands | Git worktree management |
| `pattern-detector` | `/evolve` | Find automation patterns |
| `skill-builder` | "create a skill" | Generate new skills |
| `meta-skill` | Meta requests | Create skills from patterns |

---

## AI Orchestration Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `plan-execute` | `/plan-execute` | Opus + Gemini orchestration |

---

## Installing Skills

```bash
# Interactive installer
/install-skills

# Or via CLI
bash $CLAUDE_PLUGIN_ROOT/scripts/install-skills.sh
```

## Managing Skills

```bash
# Enable/disable without uninstalling
/manage-skills

# Or via CLI
bash $CLAUDE_PLUGIN_ROOT/scripts/manage-skills.sh
```

Disabled skills are moved to `.claude/skills/.disabled/` and can be re-enabled anytime.

---

## Creating Custom Skills

```bash
/meta:skill my-custom-skill
```

See: [How to: Create Custom Skills](../how-to/meta-agents.md)
