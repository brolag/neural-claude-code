# Explanation: Advanced Patterns

Hidden patterns that emerge from combining Neural Claude Code features.

---

## Pattern Overview

These patterns leverage Claude Code v2.1.x features:

| Pattern | Feature Used | Benefit |
|---------|--------------|---------|
| Research Swarm | `context: fork` | Parallel isolated research |
| Self-Improving Mesh | Skill hot-reload | Live expertise updates |
| Teleport Memory | `/teleport` | Local ↔ cloud sync |
| PV-Mesh | Fork + Multi-AI | 2x faster consensus |
| Deep Research Hook | 10-min timeout | Full article scraping |
| Wildcard Bash | Permission patterns | Autonomous loops |

---

## Pattern 1: Research Swarm

**Problem:** Research requires multiple perspectives but sequential exploration contaminates context.

**Solution:** Launch parallel agents, each in isolated `context: fork`.

```
Topic ─┬─▶ Academic Agent (isolated)
       ├─▶ Practical Agent (isolated)
       ├─▶ Contrarian Agent (isolated)
       └─▶ Synthesis
```

**Why it works:** Each agent explores independently without seeing others' findings. Synthesis happens only at the end.

---

## Pattern 2: Self-Improving Mesh

**Problem:** When one agent learns something, other agents don't know.

**Solution:** Watch expertise files, broadcast changes to all active agents.

```
Agent A learns → Updates expertise.yaml
                         ↓
              expertise-watcher.sh detects
                         ↓
              Broadcasts to Agents B, C, D
```

**Why it works:** Claude Code's skill hot-reload means agents can receive updates during sessions.

---

## Pattern 3: Teleport Memory Bridge

**Problem:** Cloud Claude has better web access but no filesystem. Local Claude has filesystem but limited web.

**Solution:** Export memory before teleporting, import after returning.

```
Local (filesystem) ──export──▶ Cloud (web access) ──import──▶ Local
```

**Why it works:** Memory packaged as JSON blob fits in clipboard, carries context across environments.

---

## Pattern 4: Parallel Multi-AI (PV-Mesh)

**Problem:** Sequential AI collaboration is slow (45-60s).

**Solution:** Run all AIs simultaneously in parallel forks.

```
Problem ─┬─▶ Claude (fork)  ─┐
         └─▶ Codex (fork)   ─┘─▶ Synthesis
```

**Time:** 15-20 seconds (2x faster)

**Why it works:** `context: fork` ensures each AI works independently. Single message launches both.

---

## Pattern 5: Wildcard Bash Permissions

**Problem:** Neural Loops require constant permission approval for safe commands.

**Solution:** Pre-approve safe patterns with wildcards.

```yaml
wildcards:
  - pattern: "pytest **/*.py"
    auto_approve: true
  - pattern: "git status*"
    auto_approve: true

deny_patterns:
  - "rm -rf *"
  - "git push --force*"
```

**Why it works:** Loops run unattended. Safe patterns (tests, read-only git) don't need human approval.

---

## Pattern 6: Deep Research Hooks

**Problem:** Web research times out after 30 seconds.

**Solution:** Use 10-minute hook timeout for deep scraping.

```
Loop iteration completes
         ↓
deep-research-hook.sh runs (600s timeout)
         ↓
Full articles scraped → research-results.md
```

**Why it works:** Claude Code v2.1.x allows 10-minute hook timeouts. Deep research happens between iterations.

---

## Combining Patterns

These patterns compound:

1. **Research + PV-Mesh:** Research swarm with multi-AI diversity
2. **Teleport + Deep Research:** Cloud web research, local deep analysis
3. **Wildcard + Loops:** Truly autonomous multi-hour sessions
4. **Mesh + Learning:** System-wide knowledge accumulation

---

## Technical Requirements

These patterns require:
- Claude Code v2.1.5+
- `context: fork` support
- 600s hook timeouts
- Wildcard bash permissions

Verify your version:
```bash
claude --version
```

---

## Detailed Documentation

For implementation details of each pattern:

**[Full Pattern Documentation →](PATTERNS_v3.1.md)**

---

## Related

- [How to: Research](../how-to/research.md) - Research swarm guide
- [How to: Multi-AI](../how-to/multi-ai.md) - PV-Mesh guide
- [How to: Loops](../how-to/neural-loops.md) - Autonomous sessions
