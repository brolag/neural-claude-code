# Changelog

All notable changes to the Neural Claude Code plugin will be documented here.

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
