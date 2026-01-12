# Changelog

All notable changes to the Neural Claude Code plugin will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [3.0.2] - 2026-01-11

### Fixed

#### CRISP-E Compliance for All Prompts
Comprehensive prompt improvement across all commands and skills:

**Commands (22 files)**:
- Added `## Usage` section with bash examples
- Added `## Error Handling` tables (Error | Cause | Resolution)
- Added `## Output Format` markdown templates
- Added **Fallback** behavior documentation

Files updated: `pv.md`, `question.md`, `recall.md`, `route.md`, `sync.md`,
`changelog-architect.md`, `gh-learn.md`, `loop-cancel.md`, `loop-coverage.md`,
`loop-entropy.md`, `loop-init.md`, `loop-lint.md`, `loop-plan.md`, `loop-start.md`,
`loop-status.md`, `loop.md`, `output-style.md`, `pdf-learn.md`, `plan-execute.md`,
`ralph.md`, `todo-check.md`, `todo-new.md`, `yt-learn.md`

**Skills (15 files)**:
- Added `## Usage` section to all skills
- Added `## Output Format` structured templates
- Added `## Error Handling` tables with fallback behaviors

Skills updated: `changelog-architect`, `content-creation`, `debugging`,
`deep-research`, `evaluator`, `memory-system`, `meta-skill`,
`parallel-verification`, `pattern-detector`, `plan-execute`,
`prompt-engineering`, `skill-builder`, `tdd`, `worktree-manager`, `youtube-learner`

**Total**: 37 files improved, +1,205 lines added

---

## [3.0.1] - 2026-01-11

### Fixed

#### YAML Frontmatter for All Prompts
Added proper YAML frontmatter to all commands and skills for linter compliance:

**Commands (19 files)**:
- `gh-learn.md`, `loop-cancel.md`, `loop-coverage.md`, `loop-entropy.md`
- `loop-init.md`, `loop-lint.md`, `loop-plan.md`, `loop-start.md`
- `loop-status.md`, `loop.md`, `pdf-learn.md`, `plan-execute.md`
- `pv.md`, `ralph.md`, `route.md`, `todo-check.md`, `todo-new.md`
- `yt-learn.md`, `changelog-architect.md`

**Skills (4 files)**:
- `changelog-architect/skill.md`
- `parallel-verification/skill.md`
- `plan-execute/skill.md`
- `prompt-engineering/skill.md`

All prompts now include:
- `description:` field for commands
- `name:`, `description:`, `trigger:` fields for skills
- `allowed-tools:` where applicable

**Linter Results**: 0 failed, 100% pass rate

---

## [3.0.0] - 2026-01-09

### Loop v3 - Unified Autonomous Coding Loop

Major unification of Ralph Wiggum and Neural Loop into a single system based on research from:
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) - 19.7k stars
- [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) - 100+ agents
- [obra/superpowers](https://github.com/obra/superpowers) - Battle-tested TDD patterns
- Claude Code Changelog v2.1.0+ features

### Added

#### Unified `/loop` Command
- **`/loop "task"`** - HITL mode (interactive, you watch)
- **`/loop "task" --afk`** - AFK mode (Docker sandbox, autonomous)
- **`/loop "task" --once`** - Single iteration (Ralph-style)
- **`--ai <cli>`** - Force Claude or Codex CLI
- **`--plan`** - Run planning phase first
- Auto-detect CLI (Claude vs Codex)

#### `/ralph` Alias (Backward Compatibility)
- `/ralph "task"` → `/loop "task" --once`
- `/ralph afk 10 "task"` → `/loop "task" --afk --max 10`
- `/ralph setup` → Initialize loop files

#### TDD Skill (`/tdd`)
Based on obra/superpowers RED-GREEN-REFACTOR:
- Strict test-first enforcement
- Task decomposition (2-5 min chunks)
- AAA pattern (Arrange-Act-Assert)
- Anti-pattern detection
- Integration with Loop and debugging

#### Debugging Skill (`/debug`)
Based on obra/superpowers systematic-debugging:
- 4-phase root cause analysis (Observe, Hypothesize, Test, Fix)
- Defense in depth strategies
- Condition-based waiting for async
- Structured output format

#### Code Reviewer Agent
Read-only quality guardian from VoltAgent patterns:
- Limited tools: Glob, Grep, Read (no edits)
- Review types: Quick, Deep, Security, PR
- Checklist templates per language
- Structured output format

### Changed

#### Skills with `context: fork`
- `deep-research` - Now runs in isolated sub-agent
- `content-creation` - Now runs in isolated sub-agent

#### Updated Commands
- `/loop-status` - Enhanced for v3 with mode display
- `/loop-cancel` - With reason tracking

### Migration

| Old Command | New Command |
|-------------|-------------|
| `/ralph once` | `/loop "task" --once` |
| `/ralph afk 10` | `/loop "task" --afk --max 10` |
| `/loop-start "task"` | `/loop "task"` |
| `/loop-start --sandbox` | `/loop "task" --afk` |

---

## [2.0.1] - 2026-01-08

### Added
- **`/pdf-learn`** - PDF document learning skill
  - Auto-installs PyMuPDF if not present
  - Extracts text, TOC, and metadata from PDFs
  - Generates structured learning notes in inbox/
  - Supports `--focus`, `--summary`, and `--pages` options
  - Handles large PDFs (50MB+) with strategic sampling

---

## [2.0.0] - 2026-01-08

### Neural Loop v2 - Major Upgrade

Neural Loop v2 incorporates learnings from three authoritative sources:
- **Ralph Wiggum** (Matt Pocock) - 11 tips for autonomous AI coding
- **Anthropic Engineering** - Effective harnesses for long-running agents
- **Vercel v0** - Multi-system pipeline architecture

### Added

#### Enhanced `/loop-start` with new options
- **`--sandbox`** - Run in Docker container for AFK safety
- **`--type <type>`** - Loop types: feature, coverage, lint, entropy
- **`--init`** - Auto-run /loop-init before starting

#### New Specialized Loop Commands
- **`/loop-init`** - Initialize features.json and progress.txt before loops
  - Breaks task into discrete features with passes: true/false tracking
  - Creates structured progress file for inter-iteration memory
  - Runs health checks before starting work

- **`/loop-coverage`** - Test coverage improvement loop
  - Targets specific coverage percentage
  - Prioritizes critical code paths
  - One test per iteration for quality

- **`/loop-lint`** - Linting cleanup loop
  - Fixes ONE error per iteration
  - Verifies fix before moving on
  - Auto-detects linter type

- **`/loop-entropy`** - Code smell cleanup loop
  - Fights software entropy
  - Focus areas: unused, dead, patterns
  - Leaves codebase better than found

#### Key Principles (from Ralph Wiggum)
1. **Agent picks the task** - Define end state, not steps
2. **Progress file for memory** - Cheaper than re-exploring codebase
3. **Promise-based exit** - `<promise>COMPLETE</promise>` pattern
4. **Single feature per iteration** - Prevents context exhaustion
5. **Small steps** - Context rot makes large tasks worse
6. **Prioritize risky tasks** - Architecture first, polish last
7. **Fight entropy** - Poor code leads to poorer code

#### New Files
- `commands/loop-init.md` - Initialize loop artifacts
- `commands/loop-coverage.md` - Coverage-focused loop
- `commands/loop-lint.md` - Linting-focused loop
- `commands/loop-entropy.md` - Entropy cleanup loop
- JSON schema for features.json tracking

### Changed
- `/loop-start` now supports v2 state format with loop_type, sandbox, features_file
- Progress file location moved to `.claude/loop/progress.txt`
- State file includes version field for compatibility

---

## [1.7.1] - 2026-01-04

### Added

- **`/loop-plan "<task>"`** - Safe autonomous execution with planning
  - Mandatory analysis phase before execution
  - Auto-generates structured todo.md with validations
  - Calculates max iterations based on complexity
  - Requires approval before starting loop
  - Built-in abort conditions for stuck loops

---

## [1.7.0] - 2026-01-04

### Added

#### Neural Loop - Autonomous Iteration System
- **`/loop-start "<task>"`** - Start autonomous iteration loops
  - Based on the [Ralph Wiggum pattern](https://ghuntley.com/ralph/)
  - Runs tasks for hours unattended using Stop hooks
  - Re-injects prompt with context when Claude tries to exit
  - Options: `--max <n>` (max iterations), `--promise "<text>"` (completion phrase)

- **`/loop-cancel`** - Stop active loops immediately
- **`/loop-status`** - Check current loop state and iteration count

- **Test-on-Stop Hook**
  - Automatically runs tests when Claude stops
  - Auto-detects project type (npm, cargo, pytest, go, make)
  - Feeds test failures back into next iteration
  - Telegram notifications on test failures

- **Todo-Driven Development**
  - **`/todo-new "<task>"`** - Generate structured todo.md from template
  - **`/todo-check`** - Check progress on current todo
  - Phased approach with validation steps between phases
  - Optimized for use with neural-loop

- **Scripts**
  - `scripts/neural-loop/neural-loop.sh` - Stop hook for iteration
  - `scripts/neural-loop/start.sh` - Start loop sessions
  - `scripts/neural-loop/cancel.sh` - Cancel active loops
  - `scripts/neural-loop/test-on-stop.sh` - Auto-test runner

- **Templates**
  - `templates/todo-workflow.md` - Structured todo template

### Best Use Cases
- Large refactors with tests
- Building features with TDD
- Batch operations with verification
- Complex implementations requiring iteration

---

## [1.6.0] - 2025-12-29

### Added

#### Parallel Verification Skill
- **`/pv <problem>`** - AlphaGo-style parallel hypothesis exploration
  - **Diverge Phase**: Generate 3-5 distinct hypotheses for any problem
  - **Explore Phase**: Spawn multiple agents in parallel to investigate each path
  - **Verify Phase**: Cross-check results for contradictions, test edge cases
  - **Converge Phase**: Synthesize the strongest solution from all paths
  - Inspired by DeepMind's approach that beat the world Go champion

- **Multi-AI Enhancement**
  - Route different hypotheses to different models (Opus, Codex, Gemini)
  - True cognitive diversity, not just prompt variations
  - Configurable: `num_hypotheses`, `agent_type`, `timeout_per_agent`

- **Best Use Cases**
  - Complex debugging (multiple possible root causes)
  - Architecture decisions (trade-offs need multi-angle analysis)
  - Mathematical proofs (one error ruins everything)
  - Strategic planning (decision trees need exploration)

#### Smart Task Router
- **`/route <task>`** - Intelligent multi-AI cost optimization
  - Analyzes tasks and recommends optimal AI routing
  - Decision matrix based on task characteristics

- **Routing Tiers**
  - **Qwen (Local)**: Boilerplate, syntax, examples → 100% savings
  - **Gemini**: Algorithms, data transforms → 89% savings
  - **Codex**: DevOps, terminal, long sessions → 65% savings
  - **Opus**: Architecture, security, critical code → Premium accuracy

- **Plan-Execute Pattern** recommendation for complex tasks
  - Opus plans (5-10% tokens) → Gemini executes (70-80%) → Opus reviews (10-20%)
  - 60-70% cost savings on multi-step implementations

#### Skill Telemetry System
- **`scripts/log-skill-execution.sh`** - Track skill performance
  - Logs: skill name, trigger type (manual/auto), outcome, duration
  - Updates `skill-performance.json` with metrics
  - Tracks: total executions, completion rate, dismissal rate, auto-trigger rate

- **Performance Metrics**
  - Enables data-driven skill improvement via `/evolve`
  - Identifies underperforming or over-triggered skills

#### Documentation
- **`docs/ROUTING_PLAYBOOK.md`** - Quick reference for multi-AI routing
  - 60-second decision tree
  - Quick commands table
  - Daily routing habits guide
  - Monthly savings estimates

### Usage

```bash
# Parallel verification for complex problems
/pv Why is our API returning 500 errors intermittently?

# Smart routing for cost optimization
/route implement binary search in Python
/route set up GitHub Actions CI/CD

# Log skill execution
./scripts/log-skill-execution.sh deep-research manual completed 120
```

---

## [1.5.0] - 2024-12-24

### Added

#### YouTube Learner Skill
- **`/yt-learn <url>`** - Transform YouTube videos into structured knowledge
  - Extracts transcripts via Python script (youtube-transcript-api)
  - Fetches video metadata via noembed API
  - Generates actionable insights and key takeaways
  - Creates organized knowledge notes with tags

- **Transcript Extraction Script** (`scripts/youtube-transcript.py`)
  - Supports multiple URL formats (youtube.com, youtu.be, embed)
  - Auto-installs dependencies on first run
  - Returns JSON with full transcript and timestamps
  - Multi-language support (EN, ES, PT, DE, FR, IT)

- **Knowledge Note Template**
  - Key Insights section (3-5 main points)
  - Main Concepts with explanations
  - Actionable Takeaways as checklist
  - Notable Quotes extraction
  - Automatic tagging

### Usage
```bash
# Basic usage
/yt-learn https://youtube.com/watch?v=abc123

# With focus area
/yt-learn https://youtu.be/xyz789 --focus "productivity"

# Quick summary only
/yt-learn https://youtube.com/watch?v=def456 --summary
```

---

## [1.4.0] - 2024-12-23

### Added

#### Prompt Engineering Skill
- **CRISP-E Framework** for prompt quality assessment
  - 6 dimensions: Clarity, Richness, Integrity, Structure, Precision, Executability
  - Weighted scoring (20%/20%/20%/20%/10%/10%)
  - Behavioral anchors for consistent evaluation

- **`/prompt-review <file>`** - Assess prompt quality
  - Generates detailed CRISP-E score report
  - Identifies critical issues with suggested fixes
  - Scoring guide with actionable recommendations

- **`/prompt-improve <file>`** - Multi-AI prompt improvement
  - Parallel review by Gemini + Codex
  - Synthesizes feedback into Critical/Important/Minor categories
  - Auto-applies fixes and creates versioned output
  - Before/after score comparison

- **`/prompt-validate <file>`** - Research verification
  - Extracts URLs, claims, organizations, stats
  - Verifies against official sources
  - Generates verification report ([V], [?], [X] markers)

- **Antipattern Documentation**
  - Oracle Assumption, Verification Lie, Scale Trap
  - Context Gap, Infinite Scope, Format Drift

---

## [1.3.0] - 2024-12-22

### Added

#### Plan-Execute Skill
- **Opus + Gemini Orchestration** for 60-70% cost savings
  - Claude Opus handles planning and review
  - Gemini Flash handles execution of simple steps
  - Intelligent routing based on task complexity

- **Learning Loop Improvements**
  - Enhanced pattern detection from 3-AI analysis
  - Better confidence score calculations

### Fixed
- **TTS Deduplication** - Hash-based prevention of duplicate playback
- **TTS Bilingual Support** - Improved text extraction reliability
- **Agent Names** - Consistent feminine names via shared utility

---

## [1.2.1] - 2024-12-21

### Added

#### Multi-Voice TTS
- Per-project voice assignment via `~/.claude/tts-voices.json`
- Agent identification in TTS announcements ("Dorothy reporting...")
- Voice pool with bilingual support (English + Spanish)

#### Meta Commands
- `/meta:agent <name>` - Create custom agents from description
- `/meta:skill <name>` - Create custom skills from workflow

### Fixed
- `mktemp` usage for audio file creation on macOS
- API key extraction from shell config
- Temp file cleanup after playback

---

## [1.2.0] - 2024-12-18

### Added

#### Output Styles System
- **7 Output Styles** for different response formats:
  - `default` - Standard conversational responses
  - `table` - Organized markdown tables
  - `yaml` - Highly structured YAML format (improves complex tasks)
  - `concise` - Minimal tokens, maximum signal
  - `tts` - Audio summary via ElevenLabs at response end
  - `html` - Generate HTML documents, open in browser
  - `genui` - Full generative UI with rich styling

- **`/output-style` Command** - Switch styles mid-session
  - Usage: `/output-style yaml`, `/output-style genui`

#### Status Lines
- **3 Status Line Versions** (`status-lines/`):
  - `v1.sh` - Simple: model, directory, git branch
  - `v2.sh` - + Last prompt with emoji indicators
  - `v3.sh` - + Agent name + trailing prompts

- **Emoji Indicators** for prompt types:
  - ❓ Questions
  - 💡 Create/build commands
  - 🔧 Fix/debug commands
  - 🗑️ Delete/remove commands
  - ✅ Test/verify commands

#### ElevenLabs TTS Integration
- **Text-to-Speech** on task completion
- **Stop Hook** extracts `---TTS_SUMMARY---` markers
- Automatic audio playback via `afplay` (macOS)

#### Session State Management
- **Session tracking** in `.claude/data/current-session.json`
- **Agent name generation** via Ollama (llama3.2:1b)
- **Prompt history** (last 5 prompts tracked)

#### Hooks System
- **SessionStart** - Initialize session, load output style, generate agent name
- **UserPromptSubmit** - Track prompts in session state
- **Stop** - TTS summary extraction and playback

### Infrastructure
- `output-styles/` - 7 output style prompt files
- `status-lines/` - 3 status line scripts
- `scripts/hooks/` - Hook scripts (session-start, user-prompt, stop-tts)
- `scripts/tts/elevenlabs.sh` - ElevenLabs API wrapper
- `scripts/utils/agent-name.sh` - Ollama agent name generator

### Dependencies
- **Required**: `jq` (JSON processing)
- **Optional**: Ollama (agent names), ElevenLabs API key (TTS)

---

## [1.1.0] - 2024-12-18

### Added

#### Expertise System Enhancements
- **JSON Schema Validation** (`schemas/expertise.schema.json`)
  - Required fields: `domain`, `version`, `last_updated`, `understanding`
  - Confidence scores validated in 0.0-1.0 range
  - Support for both simple and scored patterns/lessons

- **Confidence Scoring System**
  - Patterns now track `successes`, `failures`, `confidence`
  - Formula: `confidence = successes / (successes + failures + 1)`
  - Auto-pruning of low-confidence patterns (< 0.3)

- **Anti-Patterns Support**
  - New `anti_patterns` field for negative constraints
  - Severity levels: low, medium, high, critical

- **Metrics Tracking**
  - `total_invocations`, `successful_invocations`
  - `average_confidence`, `patterns_pruned`

#### New Commands
- `/meta/eval` - Automated testing against golden tasks
  - Run individual or all agent/skill tests
  - Generate detailed markdown reports
  - CI/CD integration support

- `/meta/brain` - System health dashboard
  - Expertise file health scores
  - Agent/skill activation status
  - Memory statistics (hot/warm/cold)
  - Actionable recommendations
  - JSON output for scripting

#### Enhanced Commands
- `/meta/improve` now includes:
  - Schema validation step
  - Confidence score updates
  - `--validate-only` mode
  - `--prune` flag for low-confidence cleanup

- `/meta/prompt` now includes:
  - `--dry-run` mode to preview without writing
  - `--global` flag for global commands

#### Memory System
- **Tiered Memory Architecture**
  - Global memory: `~/.claude/memory/` (cross-project)
  - Project memory: `.claude/memory/` (project-specific)
  - `/remember --global` for global facts

- **Temperature Tiers**
  - Hot: Context window (instant)
  - Warm: JSON files (seconds)
  - Cold: Archives (manual)

#### Multi-AI Routing
- **Intelligent Routing Strategy** in `multi-ai` agent
  - Task classification matrix (type, complexity, risk)
  - Decision tree for AI selection
  - Single vs Multi-AI routing rules

#### Infrastructure
- `schemas/expertise.schema.json` - Validation schema
- `templates/expertise.template.yaml` - New expertise template
- `hooks/post-commit-improve.md` - Git-triggered learning

### Changed
- Expertise files now support both simple strings and scored objects
- Memory system documents global + project architecture
- Multi-AI agent includes routing decision logic

### Fixed
- N/A (new features only)

## [1.0.0] - 2024-12-18

### Added

#### Meta-Agentics (Self-Improving System)
- `/meta/prompt` - Create new commands/prompts
- `/meta/improve` - Sync agent expertise with reality
- `meta-agent` - Agent that creates other agents
- `meta-skill` - Skill that creates other skills

#### Universal Commands
- `/question` - Answer any question (project, current events, general)

#### Multi-AI Collaboration
- `codex` agent - Route to OpenAI Codex for DevOps/terminal tasks
- `gemini` agent - Route to Google Gemini for algorithms
- `multi-ai` agent - Orchestrate all three AIs

#### Cognitive Agents
- `cognitive-amplifier` - Complex decisions, bias detection
- `insight-synthesizer` - Cross-domain pattern discovery
- `framework-architect` - Transform content into frameworks

#### Skills
- `deep-research` - Multi-source research with analysis
- `content-creation` - Create content from knowledge
- `project-setup` - Initialize projects with Agent Expert pattern
- `memory-system` - Persistent memory management
- `worktree-manager` - Git worktree management
- `pattern-detector` - Find automation opportunities
- `evaluator` - Run tests against golden tasks
- `skill-builder` - Create skills from patterns

### The Agent Expert Pattern
Agents now follow: READ expertise → VALIDATE → EXECUTE → IMPROVE

This enables self-improving agents that learn from each task.
