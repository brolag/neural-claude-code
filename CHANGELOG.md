# Changelog

All notable changes to the Neural Claude Code plugin will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.13.1] - 2026-02-20

### Enhanced `/update` — Auto-Sync Global Skills

The `/update` command now automatically syncs new skills to `~/.claude/skills/` after every `git pull`, with no flags required.

#### What's new
- **Step 4b: Sync Global Skills** — runs automatically post-pull
- Copies `SKILLS_MAP.md` to `~/.claude/SKILLS_MAP.md` (always — it's an index, not customizable)
- Copies new skill directories to `~/.claude/skills/<name>/` (NEW skills always; existing skills only if plugin version is newer)
- Timestamp check protects locally-customized skills from being overwritten
- Output shows per-skill sync status: ✓ NEW / ✓ UPDATED / N skipped

**Impact**: Existing users on any version get the 8 new workflow skills and SKILLS_MAP with a single `/update` — no manual copying needed.

---

## [1.13.0] - 2026-02-20

### Skill Orchestration System — Workflows + SKILLS_MAP

Complete skill orchestration layer: a lightweight routing index, 5 workflow chains, and 3 agent-invocable command wrappers.

#### Skills Added (8)

**Workflow Orchestrators**
- `workflow-frontend-design` — Full design chain: `discover-standards → craft? → frontend-design → react-best-practices? → stop-slop? → playwright-browser? → visual-compare? → overseer`. Trigger: new component, page build, redesign, mockup implementation.
- `workflow-frontend-maintenance` — Lightweight chain for minor UI changes: `discover-standards → stop-slop? → playwright-browser? → overseer?`. Trigger: CSS fix, spacing, copy edit.
- `workflow-engineering` — Three modes (feature / bugfix / hotfix) with explicit skip gates. Feature chain: `spec? → discover-standards → craft? → tdd → slop-scan? → overseer → git-save?`
- `workflow-research` — Memory-first research chain: `recall → super-search? → knowledge-management? → memory-system`. Skips web search if memory is fresh.
- `workflow-content` — Public content chain: `craft? → content-creation → stop-slop`. `stop-slop` never skipped on public content.

**Command Wrappers** (agent-invocable wrappers for commands)
- `git-save` — Wraps the git-save command for use inside workflow chains
- `spec` — Wraps the spec command; creates CRAFT-structured spec at `specs/{project}-{task-slug}.md`
- `todo-new` — Wraps todo-new; creates structured `todo.md` with phases for loop execution

#### SKILLS_MAP
- `SKILLS_MAP.md` — Lightweight ~2KB routing index covering all 35+ skills in 7 categories
- Replaces loading 324KB of full skill files; Claude reads the map, picks the skill, loads the file only on invocation
- Includes Workflow Router table (task type → workflow name) and Global Skip Rules with measurable conditions (`loc_delta <= 25`, `has_mockup = false`)

### Stats
- **Skills**: 27 → 35 (+30%)

---

## [1.12.0] - 2026-02-17

### Added 14 Dev Skills and Commands

#### Skills (4 added)
- `autonomous-dev` — Scanner-executor architecture for autonomous coding (6 scanners → triage → executor → smoke tests)
- `parallel-verification` — AlphaGo-style multi-path hypothesis exploration with configurable confidence thresholds
- `playwright-browser` — Agentic browser automation via Playwright CLI with headless parallel sessions and screenshot trails
- `super-search` — Triple-engine research orchestrator (Perplexity Sonar Pro + Grok X + Grok YouTube) running in parallel

#### Commands (10 added)
- `ai-collab` — Route problems to Claude, Codex, and Gemini in parallel; synthesize three AI perspectives
- `gh-learn` — Analyze GitHub repositories and extract architecture patterns via `gh` CLI
- `git-save` — Professional Conventional Commits with emoji, intelligent type detection, and SemVer tracking
- `learn` — Universal learning from YouTube, GitHub, X, PDF, and web with auto source detection
- `prompt-test` — Prompt quality linting and scoring across 8 dimensions with optional golden tests
- `pv-mesh` — Parallel multi-AI verification mesh (Claude + Codex + Gemini) with synthesis phase
- `specs` — Feature specification development with 3-phase workflow (Requirements → Design → Tasks)
- `ui-review` — Parallel browser QA agents against a URL via Playwright CLI with consolidated report
- `forget` — Remove stored facts from the memory system by ID
- `remember` — Save facts to persistent memory with timestamp, category, and confidence metadata

### Stats
- **Skills**: 23 → 27 (+17%)
- **Commands**: 21 → 31 (+48%)

---

## [1.11.0] - 2026-02-09

### Skill & Command Purge

Removed unused, redundant, and dead-weight skills and commands to reduce noise and improve discoverability.

### Removed

#### Skills (7 removed)
- `browser-usage-prompt-guide` - Reference doc, not executable skill
- `compute-advantage` - Theoretical metric, never invoked
- `cost-tracker` - Redundant with `/kpi`
- `feature` - Generic placeholder, never used
- `newsletter-launch` - Covered by `content-creation`
- `parallel-verification` - Redundant with `/pv` command
- `youtube-learner` - Replaced by unified `/learn` command

#### Commands (5 removed)
- `feature.md` - Generic placeholder
- `pv-mesh.md` - Rarely used, expensive (3x AI calls)
- `secure-api.md` - One-time reference, not a command
- `status.md` - Redundant with `/dashboard`
- `teleport-sync.md` - Rarely used cloud sync

### Stats
- **Skills**: 30 → 23 (-23%)
- **Commands**: 26 → 21 (-19%)
- **Remaining skills**: agentic-course, changelog-architect, content-creation, debugging, deep-research, evaluator, knowledge-management, kpi, memory-system, meta-skill, overseer, pattern-detector, plan-execute, project-setup, prompt-engineering, react-best-practices, skill-builder, slop-fix, slop-scan, squad, stop-slop, tdd, worktree-manager

---

## [1.10.0] - 2026-02-05

### Claude Opus 4.6 Migration

Updated all model references from Claude Opus 4.5 to Claude Opus 4.6 across the entire plugin.

### Changed

#### Model References Updated
All Opus 4.5 references migrated to Opus 4.6 with updated benchmarks:
- **SWE-bench Verified**: 80.8% (slight decrease from 80.9%, but gains elsewhere)
- **Terminal-Bench 2.0**: 65.4% (up from 59.8%)
- **Humanity's Last Exam (HLE)**: 53.1% with tools, 40.0% without tools
- **GDPval-AA**: 1606 Elo (+144 vs GPT-5.2, +190 vs Opus 4.5)
- **BrowseComp**: 84.0%
- **BigLaw Bench**: 90.2%, 40% perfect scores
- **Cybersecurity**: Best on 38 of 40 investigations
- **Computational biology**: ~2x better than Opus 4.5

#### Pricing Updated
- Standard: $5/$25 per 1M tokens (input/output) - corrected from incorrect $15/$75 listing (was Opus 4.0/4.1 pricing)
- Premium (>200k tokens): $10/$37.50 per 1M tokens
- Prompt caching: Write $6.25 (5min TTL), $10.00 (1hr TTL), Hits $0.50
- Batch API: $2.50/$12.50 (50% discount)

#### New Opus 4.6 Features Noted
- 1M token context window (beta)
- Adaptive thinking (auto-decides when to think deeper)
- Context compaction (beta, auto-summarizes old context)
- Effort parameter: low, medium, high (default), max
- 128K output tokens
- Agent teams in Claude Code
- Model ID: `claude-opus-4-6`

#### Competitor Benchmarks Updated
- GPT-5.1-Codex-Max renamed to GPT-5.2-Codex (80.0% SWE-bench, 64.7% Terminal-Bench 2.0, 50.0% HLE)
- Gemini 3 Pro Terminal-Bench corrected to 56.2%

#### Files Updated
- `agents/multi-ai.md` - Benchmark table, routing rules, response template
- `agents/dispatcher.md` - AI capabilities, routing matrix, Plan-Execute diagram
- `agents/codex.md` - GPT-5.1 to GPT-5.2 migration, all benchmarks updated
- `agents/gemini.md` - Claude comparison reference, Terminal-Bench corrected
- `skills/plan-execute/skill.md` - Planner/Reviewer diagram labels
- `skills/cost-tracker/skill.md` - Pricing table, dashboard examples
- `skills/slop-fix/skill.md` - Co-Author reference
- `docs/ROUTING_PLAYBOOK.md` - Model strengths table
- `docs/how-to/multi-ai.md` - Plan-Execute description, AI table
- `docs/explanation/multi-ai.md` - Benchmark table, Plan-Execute diagram
- `docs/index.html` - AI comparison table, model badges
- `commands/route.md` - Security routing example
- `README.md` - Version badge to 1.10.0

---

## [1.9.0] - 2026-02-03

### Interactive Agentic Coding Course

Added a comprehensive 13-lesson terminal course for mastering autonomous AI-assisted development.

### Added

#### Agentic Course (`/course`)
Complete interactive course covering:

**Fundamentals (Lessons 1-3)**
- The Reality Check (70% Problem)
- Mental Models (Conductor → Orchestrator)
- Your First Autonomous Task

**Structured Prompts (Lessons 4-6)**
- CRAFT Framework
- 6 Core Areas
- 3-Tier Boundaries

**Autonomous Operations (Lessons 7-9)**
- Loop Fundamentals
- Circuit Breakers
- State Management

**Advanced Patterns (Lessons 10-12)**
- Multi-Agent Orchestration (Neural Squad)
- Context Engineering
- Compute Advantage

**Mastery (Lesson 13)**
- Building Your System

Features:
- Progress tracking across sessions
- Quick reference cards (`/course ref craft`)
- Hands-on exercises in each lesson
- Modular - take any lesson independently

```bash
/course              # Show menu
/course lesson 4     # Jump to lesson
/course ref loops    # Quick reference
```

---

## [1.8.0] - 2026-02-03

### Neural Squad Multi-Agent System

Added production-ready multi-agent orchestration with anti-slop enforcement.

### Added
- `/squad-init` - Initialize 3-agent system (Architect, Dev, Critic)
- `/squad-status` - Dashboard showing agents and tasks
- `/squad-task` - Create and manage tasks (Kanban flow)
- `/squad-standup` - Daily standup report
- `/squad-cron` - Automated heartbeats via macOS launchd

Features:
- CRAFT integration for specs
- Two-stage review (spec compliance + code quality)
- Git worktree isolation per agent
- File-based communication (no database)

---

## [1.7.0] - 2026-02-03

### Agentic Engineering Framework Release

Major update introducing comprehensive agentic coding measurement and optimization tools.

### Added

#### CRAFT Framework (`/craft`)
Structured prompt engineering framework for autonomous agent tasks:
- **C**ontext - Current situation and constraints
- **R**equirements - Success criteria and objectives
- **A**ctions - Allowed/forbidden operations with 3-tier boundaries
- **F**low - Execution steps and iteration strategy
- **T**ests - Verification and completion signals

Includes:
- 6 Core Areas checklist (Commands, Testing, Structure, Style, Git, Boundaries)
- 3-Tier Boundary System (✅ Always / ⚠️ Ask first / 🚫 Never)
- Integration with `/loop --craft` for autonomous sessions

#### KPI Tracking Skill (`/kpi`)
Track the 4 core metrics of agentic coding performance:
- **Plan Velocity** - Time from intent to actionable spec
- **Review Velocity** - Time per code review cycle
- **Autonomy Duration** - Time agents work without intervention
- **Loop State** - Distribution across In-Loop/Out-Loop/ZTE

```bash
/kpi                     # Dashboard
/kpi autonomy 45 "Task"  # Log session
/kpi report              # Weekly report
```

#### Compute Advantage Calculator (`/ca`)
Calculate your agentic leverage with the Compute Advantage formula:

```
CA = (Compute Scaling × Autonomy Duration) / (Time + Effort + Monetary Cost)
```

Interpretation:
- < 2.0 = Break-even
- 2.0-5.0 = Good leverage
- 5.0-10.0 = Excellent
- > 10.0 = Elite (ZTE-level)

#### Cost Tracker Skill (`/cost`)
Real-time API cost tracking for Compute Advantage calculations:
- Daily/weekly/monthly cost dashboards
- Budget alerts (80% threshold warnings)
- Model-specific pricing (Opus, Sonnet, Haiku, Codex, Gemini)
- Cost-per-autonomy-hour metrics

```bash
/cost                    # Today's costs
/cost budget 50 --weekly # Set budget
/cost report             # Weekly breakdown
```

#### CRAFT Template (`templates/craft.yaml`)
Complete YAML template for structured autonomous prompts:
- Full CRAFT sections with examples
- 6 Core Areas reference
- 3-Tier Boundary templates
- Spec-Driven Development phases
- Context management tips

### Changed

#### Loop Command Updated
- Added `--craft` flag for CRAFT-structured prompts
- Integration with KPI tracking on loop completion
- Auto-logging of autonomy duration

### Documentation

#### New Resources
- `agentic-engineering-course.md` - Complete methodology
- `agentic-frameworks.md` - CRAFT, KPIs, ZTE, Act-Learn-Reuse
- `spec-driven-development.md` - 70% Problem, 6 Core Areas

---

## [1.6.0] - 2026-02-03

### Claude Code 2.1.30 Integration Release

Updated plugin to leverage new Claude Code 2.1.30 features for improved autonomous operation and developer experience.

### Added

#### PDF Page Range Support
Skills now leverage Claude Code's `pages` parameter for large PDFs:
```bash
# Read specific pages (new in Claude Code 2.1.30)
Read(document.pdf, pages: "1-5")
Read(document.pdf, pages: "10-20")
```

#### Forked Context Pattern
Updated skills to use `context: fork` for isolated sub-agent execution:
- `youtube-learner` - Now runs with fresh context
- Prevents context pollution between skill invocations
- Template for future skill updates

#### Wildcard Bash Permissions
Skills now use wildcard patterns for cleaner permission declarations:
```yaml
allowed-tools:
  - Bash(npm *)
  - Bash(python3 *)
  - Bash(git * main)
```

### Changed

#### youtube-learner Skill
- Added `context: fork` for isolated execution
- Added wildcard `allowed-tools` for cleaner permissions
- Now runs in completely fresh context per invocation

### Documentation

#### New Learning Document
- `inbox/claude-code-changelog-2.1.30-learnings-2026-02-03.md`
- Comprehensive feature analysis
- Implementation patterns
- Action items for adoption

### Claude Code 2.1.30 Features Documented

| Feature | Impact |
|---------|--------|
| PDF Page Range | Handle large PDFs in chunks |
| Skill Hot-reload | No restart needed after edits |
| `context: fork` | Isolated sub-agent execution |
| Hooks in Frontmatter | Per-skill lifecycle hooks |
| Wildcard Permissions | Cleaner `Bash(npm *)` syntax |
| `--from-pr` | Resume PR-linked sessions |
| Task Dependencies | `addBlockedBy`, `addBlocks` |

### Environment Variables Reference

```bash
CLAUDE_CODE_ENABLE_TASKS=false              # Disable task system
CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1      # No background tasks
CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=N   # Override read limit
IS_DEMO=1                                   # Hide email/org in UI
FORCE_AUTOUPDATE_PLUGINS=1                  # Auto-update plugins
```

### Migration Notes

Skills should be updated to include:
1. `context: fork` in frontmatter for isolation
2. Wildcard `allowed-tools` patterns
3. Hooks in frontmatter (if needed per-skill)

---

## [1.5.0] - 2026-02-02

### Added
- **One-line installer**: `curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash`
- `/onboard` command - Interactive guided tour for new users: system check, feature discovery, skills setup, TTS configuration
- `/install-skills` command - Interactive installer with category browsing, multi-select, dependency resolution
- `/manage-skills` command - Enable/disable/update/uninstall skills without losing configuration
- `/tts` command - Toggle TTS audio and text summaries independently (`/tts off`, `/tts audio off`, `/tts summary off`)
- `scripts/install-skills.sh` - Full interactive installer script with bash 3.2 compatibility
- `scripts/manage-skills.sh` - Skills lifecycle manager
- `scripts/tts-toggle.sh` - TTS configuration toggle
- `.claude/skills-registry.json` - Skills metadata database with categories and dependencies

### Changed
- `install.sh` now auto-registers all commands to `~/.claude/commands/` during installation
- `stop-tts.sh` hook now respects `~/.claude/tts-config.json` for audio toggle
- Updated README with one-liner installation front and center
- Updated all documentation (tutorials, reference, skills catalog)

### Fixed
- New commands not available after plugin update (auto-copy to global commands dir)
- Bash 3.2 compatibility for macOS users (interactive installer gracefully degrades)

---

## [1.4.0] - 2026-02-01

### Added
- **react-best-practices** skill - React/Next.js optimization with 40+ rules and 6 reference guides (Vercel Engineering)
- **knowledge-management** skill - PARA-based second brain system for capturing and organizing knowledge
- **slop-scan** skill - Detect technical debt, code smells, and slop accumulation across codebase
- **slop-fix** skill - Auto-fix safe slop issues (unused imports, dead code, simple refactors)
- **overseer** skill - Review PRs/diffs for quality, security, and consistency before merge

### Changed
- Updated **debugging** skill with improved error handling and root cause analysis workflow
- Updated **tdd** skill with better task decomposition and RED-GREEN-REFACTOR enforcement
- Updated **deep-research** skill with auto-recall from knowledge base and systematic analysis

### Metadata
- Bumped version to 1.4.0
- Added keywords: react, nextjs, knowledge-management, slop, code-quality, anti-slop

---

## [4.0.0] - 2026-01-20

### Major Cleanup Release - Anti-Bloat Consolidation

Complete system audit and cleanup following the 5 Critical Questions framework:
1. **Frequency**: Is this done 5+ times per week?
2. **Complexity**: Does it take 3+ steps manually?
3. **Consistency**: Is the process the same each time?
4. **Value**: Does automating save significant time/effort?
5. **Existing**: Is there already something that does this?

### Archived (Moved to `*/archived/`)

#### Commands (14 archived → 14 remaining)
**Loop fragments** (replaced by unified `/loop`):
- `loop-cancel.md`, `loop-coverage.md`, `loop-entropy.md`
- `loop-init.md`, `loop-lint.md`, `loop-plan.md`
- `loop-start.md`, `loop-status.md`

**Learn fragments** (replaced by unified `/learn`):
- `gh-learn.md`, `pdf-learn.md`, `yt-learn.md`

**Deprecated**:
- `ralph.md` (alias for `/loop --once`)
- `sync.md` (rarely used)
- `output-style.md` (merged into hooks)

#### Agents (4 archived → 7 remaining)
**Speculative agents** (Claude doesn't need templates to roleplay):
- `meta-agent.md` - Replaced by meta-skill
- `meta-architect.md` - Overlaps with meta-agent
- `framework-architect.md` - Too theoretical
- `insight-synthesizer.md` - Better as a skill

**Remaining agents**:
- `codex.md` - Route to OpenAI Codex
- `cognitive-amplifier.md` - Complex decisions
- `gemini.md` - Route to Google Gemini
- `optimizer.md` - Self-improvement
- `multi-ai.md` - Orchestrate all AIs
- `dispatcher.md` - Smart routing
- `code-reviewer.md` - Read-only reviews

#### Skills (1 archived)
- `latex-pdf-generator.md` - Loose file, moved to archived

### Changed

#### `/evolve` Command Rewritten
Now includes:
- **5 Critical Questions** evaluation framework
- **6-phase process**: AUDIT → ANALYZE → EVALUATE → CLEAN → IMPROVE → CREATE
- **Anti-bloat principles**: 10:1 rule, Improve > Create, Delete > Archive > Keep
- **Decision framework** requiring user approval for changes
- **Iron Law**: Must answer YES to 4/5 questions before creating anything

#### Documentation
- Updated README.md with unified `/loop` and `/learn` commands
- Removed references to archived commands
- Version bumped to 4.0.0

### Migration

| Old Command | New Command |
|-------------|-------------|
| `/loop-start "task"` | `/loop "task"` |
| `/loop-cancel` | (use Ctrl+C or timeout) |
| `/loop-status` | (check progress.txt) |
| `/loop-coverage "task"` | `/loop "task" --type coverage` |
| `/loop-lint "task"` | `/loop "task" --type lint` |
| `/loop-entropy "task"` | `/loop "task" --type entropy` |
| `/yt-learn <url>` | `/learn <url>` |
| `/gh-learn <url>` | `/learn <url>` |
| `/pdf-learn <path>` | `/learn <path>` |
| `/ralph "task"` | `/loop "task" --once` |

### Stats

- **Commands**: 28 → 14 (50% reduction)
- **Agents**: 11 → 7 (36% reduction)
- **Skills**: 20 → 19 (5% reduction)
- **Total lines removed**: ~3,000

---

## [3.1.0] - 2026-01-12

### Claude Code v2.1.x Integration - Hidden Patterns Release

Major feature release implementing 10 breakthrough patterns discovered by synthesizing Claude Code v2.1.x features with Neural Claude Code architecture.

### Added

#### Research Swarm (`/research-swarm`)
Parallel forked research agents using `context: fork` for true cognitive isolation.
- Launch 3-5 parallel research agents simultaneously
- Each agent explores independently without context contamination
- Synthesize findings into comprehensive report
- Best for: broad research, competitive analysis, multi-angle exploration

#### Parallel Multi-AI Verification Mesh (`/pv-mesh`)
Combines AlphaGo-style parallel verification with true AI diversity.
- Run Claude, Codex, and Gemini in parallel forks (single message, 3 Task calls)
- Each AI uses its unique strengths (Claude: accuracy, Codex: terminal, Gemini: algorithms)
- 3x faster than sequential `/ai-collab` (15-20s vs 45-60s)
- Best for: architecture decisions, complex debugging, security reviews

#### Teleport Memory Bridge (`/teleport-sync`)
Synchronize memory state between local CLI and cloud (claude.ai) sessions.
- `export` - Pack memory into portable JSON blob for clipboard
- `import` - Unpack memory blob back to local files
- `status` - Check sync state
- Best for: hybrid execution (local work → cloud web access → return with results)

#### Expertise Watcher Script (`scripts/expertise-watcher.sh`)
Self-improving agent mesh infrastructure using fswatch.
- Watches `.claude/expertise/*.yaml` for changes
- Broadcasts updates to all active agents via systemMessage injection
- Queues changes for next session consumption
- Usage: `./expertise-watcher.sh start|stop|status|consume`

#### Expertise Streamer Script (`scripts/expertise-streamer.sh`)
Real-time expertise streaming during active sessions.
- Injects updates IMMEDIATELY into running session (vs. queuing)
- Manual injection support: `./expertise-streamer.sh inject "message"`
- Usage: `./expertise-streamer.sh start|stop|status|inject|consume`

#### Deep Research Hook (`scripts/deep-research-hook.sh`)
10-minute timeout research hook for deep web scraping.
- Runs AFTER neural loop iterations
- Full article scraping (not just snippets)
- Cross-references multiple sources
- Queue format: `TOPIC|URL1,URL2,URL3`
- Results output to `.claude/loop/research-results.md`

#### Wildcard Bash Permissions (`config/bash-permissions.yaml`)
Auto-approve safe command patterns for truly autonomous loops.
- Testing: pytest, npm test, vitest, jest
- Linting: eslint, prettier (check only)
- Git (read-only): status, diff, log, branch, show
- Claude scripts: `.claude/scripts/*.sh` (with exclusions for destructive commands)
- Context-specific: extra approvals during neural-loop, tdd modes
- Deny patterns: rm -rf, force push, sudo, DROP DATABASE, etc.

### Changed

#### Session Start Script Enhancements
- **Layered Background Loading**: Load expertise, memory, and inbox items in background for faster startup
- **Agent Mesh Integration**: Consumes broadcast queue from expertise-watcher
- **Clickable Memory Navigation**: OSC 8 hyperlinks for inbox items and facts (clickable in terminal)

### Technical Details

These patterns leverage Claude Code v2.1.x features:
- `context: fork` - Isolated sub-agent contexts
- 10-minute hook timeouts (600s) - Deep research capability
- Wildcard bash permissions - Autonomous loop enablement
- OSC 8 hyperlinks - Terminal file navigation
- Unified Ctrl+B backgrounding - Background task management
- Skill hot-reload from ~/.claude/skills

### Best Practices

**When to use each pattern:**

| Pattern | Use When |
|---------|----------|
| `/research-swarm` | Need broad coverage of a topic |
| `/pv-mesh` | Need fast multi-AI consensus |
| `/teleport-sync` | Moving between local and cloud Claude |
| Expertise Watcher | Setting up persistent learning |
| Deep Research Hook | Running extended research loops |
| Bash Permissions | Enabling autonomous loops |

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
