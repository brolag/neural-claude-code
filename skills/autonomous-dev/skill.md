---
name: autonomous-dev
description: "Autonomous development system with scanner-executor architecture. Use when: user wants to set up autonomous coding agents, run scanners against a project, or manage the executor pipeline. Don't use when: user wants manual code review or one-off fixes."
trigger: /autodev, "autonomous dev", "scanner executor", "run scanners"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, WebSearch
---

# Autonomous Development System

Scanner-Executor architecture for autonomous software development. Inspired by Antonio Leiva's system (6 scanners, triage, executor, smoke tests).

## Architecture

```
    SCANNERS (detect)          TRIAGE (prioritize)       EXECUTOR (implement)
  ┌──────────────────┐     ┌───────────────────┐     ┌──────────────────────┐
  │ Security    09:00│     │                   │     │ Pick #1 priority     │
  │ Tests       11:00│     │ Classify issues   │     │ Implement fix        │
  │ Architecture13:00│ ──▶ │ as p1/p2/p3       │ ──▶ │ Run checks           │
  │ Feature     14:00│     │ Daily at 10:00    │     │ Commit + close issue │
  │ Performance 15:00│     │                   │     │ Every 1 hour         │
  │ DX          17:00│     └───────────────────┘     └──────────────────────┘
  └──────────────────┘
         │                         SMOKE TESTS (verify)
         │                     ┌───────────────────────┐
         └────────────────────▶│ Build + Test + Lint    │
                               │ Every 4 hours          │
                               │ Creates p1 on failure  │
                               └───────────────────────┘
```

**Key design principle**: The agent that detects a problem NEVER fixes it. Scanners create issues. The executor implements fixes. This prevents bias.

## Usage

### Initial setup
```bash
# Point at a project with a GitHub repo
/autodev setup /path/to/my-project your-github-username/my-project
```
This creates `config.sh`, GitHub labels, and verifies prerequisites.

### Run individual components
```bash
/autodev scan security      # Run one scanner
/autodev scan all            # Run all 6 scanners
/autodev triage              # Prioritize open issues
/autodev execute             # Pick and implement top issue
/autodev smoke               # Run verification checks
```

### Install automated crons
```bash
/autodev crons install       # Install all launchd jobs
/autodev crons uninstall     # Remove all launchd jobs
/autodev crons status        # Check what's running
```

### Monitor
```bash
/autodev status              # Show issue counts, recent activity
/autodev logs <component>    # View recent logs
```

## Models (cost optimization)

| Component | Model | Why |
|-----------|-------|-----|
| Scanners | Sonnet | Detection only, no implementation |
| Triage | Haiku | Simple classification task |
| Executor | Opus | Needs best quality for implementation |
| Smoke | Haiku | Pass/fail checks only |

## Files

```
.claude/scripts/autonomous-dev/
  config.sh.example       # Configuration template
  config.sh               # Active config (gitignored)
  setup-project.sh        # Project initialization
  run-scanner.sh          # Run a single scanner
  run-all-scanners.sh     # Run all 6 scanners
  triage.sh               # Auto-prioritize issues
  executor.sh             # Implement highest priority issue
  smoke-test.sh           # Verification checks
  install-crons.sh        # Install/uninstall launchd jobs
  scanners/
    security.md           # Security scanner prompt
    tests.md              # Test coverage scanner prompt
    architecture.md       # Architecture scanner prompt
    feature.md            # Feature completeness scanner prompt
    performance.md        # Performance scanner prompt
    dx.md                 # DX friction scanner prompt
  logs/                   # Runtime logs
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `config.sh not found` | Setup not run | Run `/autodev setup` first |
| `gh: not authenticated` | GitHub CLI not logged in | Run `gh auth login` |
| `claude: not found` | Claude CLI not in PATH | Install Claude Code |
| Scanner creates 0 issues | Throttle limit hit | Check open issue count |
| Executor abandons issue | Checks fail after 3 retries | Review issue manually |

**Fallback**: All components can be run manually. If crons fail, run scripts directly from terminal.

## Output Format

```markdown
## Autonomous Dev: [action]

**Status**: [result]
**Project**: [name] ([repo])

### Details
[component-specific output]

### Issues
- Created: N
- Closed: N
- Open (p1/p2/p3): N/N/N
```
