# Changelog

All notable changes to the Neural Claude Code plugin will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
