# Reference: Configuration

All configuration options.

---

## Environment Variables

### Required

```bash
export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code"
```

### Optional

```bash
# Text-to-Speech
export ELEVENLABS_API_KEY="your-key"

# Multi-AI (CLI must be installed separately)
# codex CLI
```

---

## Expertise Manifest

Control expertise loading in `.claude/expertise/manifest.yaml`:

```yaml
version: 1
last_updated: 2026-01-12

load_order:
  - project      # Load first
  - frontend
  - backend
  - shared       # Load last

confidence:
  promotion_threshold: 0.7    # Patterns above → shared
  deprecation_threshold: 0.3  # Patterns below → pruned
  decay_rate: 0.05            # Weekly decay for unused

auto_update:
  enabled: true
  triggers:
    - task_completion
    - evolve_command
```

---

## Bash Permissions

Auto-approve safe commands in `config/bash-permissions.yaml`:

```yaml
wildcards:
  - pattern: "pytest **/*.py"
    auto_approve: true

  - pattern: "git status*"
    auto_approve: true

deny_patterns:
  - "rm -rf *"
  - "git push --force*"

contexts:
  neural-loop:
    extra_patterns:
      - pattern: "git add ."
        auto_approve: true
```

---

## Settings Files

### Project Settings

`.claude/settings.json`:

```json
{
  "hooks": {
    "session-start": ".claude/scripts/session-start.sh",
    "stop": ".claude/scripts/stop.sh"
  }
}
```

### Local Settings (not committed)

`.claude/settings.local.json`:

```json
{
  "hookTimeouts": {
    "test-on-stop": 120000,
    "deep-research": 600000
  }
}
```

---

## TTS Voices

Per-project voice assignment in `~/.claude/tts-voices.json`:

```json
{
  "projects": {
    "/Users/me/project-a": "Rachel",
    "/Users/me/project-b": "Dorothy"
  },
  "default": "Rachel"
}
```

---

## Expertise Files

Structure for `.claude/expertise/*.yaml`:

```yaml
domain: project_name
version: 1
last_updated: 2026-01-12

understanding:
  project_type: "web-app"
  tech_stack:
    - typescript
    - react
  structure:
    frontend: "src/"
    backend: "api/"

patterns:
  - "Use functional components"
  - "API routes in api/routes/"

lessons_learned:
  - "User prefers async/await"

user_preferences:
  - "Conventional commits with emoji"
```

---

## Hook Timeouts

Default timeouts (milliseconds):

| Hook | Default | Max |
|------|---------|-----|
| session-start | 30000 | 60000 |
| stop | 30000 | 120000 |
| deep-research | 60000 | 600000 |
| neural-loop | 10000 | 60000 |

Configure in `settings.local.json`:

```json
{
  "hookTimeouts": {
    "deep-research": 600000
  }
}
```

---

## Memory Limits

Teleport sync limits:

| Item | Limit |
|------|-------|
| Max blob size | 50KB |
| Max facts | 20 |
| Context | 5KB |
| Learnings | 10 |
