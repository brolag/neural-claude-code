#!/bin/bash
# Neural Claude Code Plugin - Sync Script
# Syncs plugin to projects and updates global hooks

set -e

PLUGIN_ROOT="${PLUGIN_ROOT:-$HOME/Sites/neural-claude-code}"
GLOBAL_SETTINGS="$HOME/.claude/settings.json"
VERSION=$(jq -r '.version' "$PLUGIN_ROOT/.claude-plugin/plugin.json" 2>/dev/null || echo "unknown")

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    cat << EOF
Neural Claude Code Plugin Sync v$VERSION

Usage: sync-plugin.sh [command] [options]

Commands:
  hooks       Update global hooks in ~/.claude/settings.json
  project     Sync plugin to a project directory
  status      Show sync status for a project
  all         Sync hooks + current project

Options:
  -p, --project <path>   Target project path (default: current directory)
  -f, --force            Overwrite existing files without asking
  -n, --dry-run          Show what would be done without making changes
  -h, --help             Show this help message

Examples:
  sync-plugin.sh hooks                    # Update global hooks
  sync-plugin.sh project -p ~/myproject   # Sync to specific project
  sync-plugin.sh all                      # Sync everything to current project
  sync-plugin.sh status                   # Check sync status
EOF
}

# Update global hooks in settings.json
sync_hooks() {
    log_info "Syncing global hooks..."

    if [ ! -f "$GLOBAL_SETTINGS" ]; then
        log_warn "Creating $GLOBAL_SETTINGS"
        mkdir -p "$(dirname "$GLOBAL_SETTINGS")"
        echo '{}' > "$GLOBAL_SETTINGS"
    fi

    # Backup current settings
    cp "$GLOBAL_SETTINGS" "$GLOBAL_SETTINGS.backup"

    # Update hooks using jq
    local tmp=$(mktemp)
    jq --arg plugin "$PLUGIN_ROOT" '
    .hooks = {
        "SessionStart": [{
            "matcher": "",
            "hooks": [{
                "type": "command",
                "command": "bash \($plugin)/scripts/hooks/session-start.sh",
                "timeout": 5000
            }]
        }],
        "PostToolUse": [{
            "matcher": "",
            "hooks": [{
                "type": "command",
                "command": "bash \($plugin)/scripts/hooks/post-tool-use.sh",
                "timeout": 1000
            }]
        }],
        "Stop": [{
            "matcher": "",
            "hooks": [{
                "type": "command",
                "command": "bash \($plugin)/scripts/hooks/stop-tts.sh",
                "timeout": 15000
            }]
        }]
    }' "$GLOBAL_SETTINGS" > "$tmp" && mv "$tmp" "$GLOBAL_SETTINGS"

    log_success "Global hooks updated"
}

# Sync plugin components to a project
sync_project() {
    local project_path="${1:-$PWD}"
    local force="${2:-false}"
    local dry_run="${3:-false}"

    log_info "Syncing to project: $project_path"

    # Ensure .claude directory exists
    local claude_dir="$project_path/.claude"
    if [ ! -d "$claude_dir" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] Would create $claude_dir"
        else
            mkdir -p "$claude_dir"
            log_success "Created $claude_dir"
        fi
    fi

    # Directories to sync
    local dirs=("commands" "scripts" "schemas")

    for dir in "${dirs[@]}"; do
        local src="$PLUGIN_ROOT/$dir"
        local dest="$claude_dir/$dir"

        if [ -d "$src" ]; then
            if [ "$dry_run" = "true" ]; then
                log_info "[DRY-RUN] Would sync $dir/"
            else
                mkdir -p "$dest"
                # Copy files that don't exist or are older
                for file in "$src"/*; do
                    if [ -f "$file" ]; then
                        local filename=$(basename "$file")
                        local dest_file="$dest/$filename"

                        if [ ! -f "$dest_file" ] || [ "$force" = "true" ]; then
                            cp "$file" "$dest_file"
                            log_success "Synced $dir/$filename"
                        elif [ "$file" -nt "$dest_file" ]; then
                            cp "$file" "$dest_file"
                            log_success "Updated $dir/$filename"
                        fi
                    fi
                done
            fi
        fi
    done

    # Sync learnings infrastructure
    local learnings_dir="$claude_dir/memory/learnings"
    if [ ! -d "$learnings_dir" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] Would create learnings directory"
        else
            mkdir -p "$learnings_dir"
            # Initialize index if doesn't exist
            if [ ! -f "$learnings_dir/index.json" ]; then
                echo '{"version":"1.0","last_indexed":null,"entries":[],"stats":{}}' > "$learnings_dir/index.json"
            fi
            log_success "Created learnings infrastructure"
        fi
    fi

    # Copy index-learnings.sh if not exists
    local indexer_src="$PLUGIN_ROOT/scripts/index-learnings.sh"
    local indexer_dest="$claude_dir/scripts/index-learnings.sh"
    if [ -f "$indexer_src" ]; then
        if [ ! -f "$indexer_dest" ] || [ "$force" = "true" ]; then
            mkdir -p "$(dirname "$indexer_dest")"
            cp "$indexer_src" "$indexer_dest"
            chmod +x "$indexer_dest"
            log_success "Synced index-learnings.sh"
        fi
    fi

    # Create/update AGENTS.md if not exists
    local agents_md="$claude_dir/agents/AGENTS.md"
    if [ ! -f "$agents_md" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] Would create AGENTS.md"
        else
            mkdir -p "$(dirname "$agents_md")"
            cat > "$agents_md" << 'AGENTSEOF'
# Agent Instructions

Shared instructions for all agents in this project.

## Memory Usage (REQUIRED)

All agents MUST check existing learnings before performing tasks:

### Before Starting Work

1. Check learnings summary (loaded at session start)
2. Use /recall <topic> for relevant knowledge
3. Read inbox/*.md if detailed learning exists

### After Completing Work

If you discover something valuable:
1. Quick fact → Suggest user runs `/remember <insight>`
2. Detailed learning → Create note in `inbox/`

## Key Principle

**Never re-research what's already learned.**
AGENTSEOF
            log_success "Created AGENTS.md"
        fi
    fi

    log_success "Project sync complete"
}

# Show sync status
show_status() {
    local project_path="${1:-$PWD}"
    local claude_dir="$project_path/.claude"

    echo ""
    echo "=== Neural Claude Code Plugin Status ==="
    echo "Plugin Version: $VERSION"
    echo "Plugin Path: $PLUGIN_ROOT"
    echo "Project: $project_path"
    echo ""

    # Check global hooks
    echo "--- Global Hooks ---"
    if [ -f "$GLOBAL_SETTINGS" ]; then
        local hook_path=$(jq -r '.hooks.SessionStart[0].hooks[0].command // "not set"' "$GLOBAL_SETTINGS" 2>/dev/null)
        if [[ "$hook_path" == *"neural-claude-code"* ]]; then
            log_success "Hooks configured correctly"
        else
            log_warn "Hooks not pointing to plugin"
        fi
    else
        log_warn "No global settings found"
    fi

    # Check project structure
    echo ""
    echo "--- Project Structure ---"
    local components=("commands" "scripts" "memory/learnings" "agents/AGENTS.md")
    for comp in "${components[@]}"; do
        if [ -e "$claude_dir/$comp" ]; then
            log_success "$comp exists"
        else
            log_warn "$comp missing"
        fi
    done

    # Check learnings
    echo ""
    echo "--- Learnings Status ---"
    local index="$claude_dir/memory/learnings/index.json"
    if [ -f "$index" ]; then
        local count=$(jq -r '.stats.total_entries // 0' "$index" 2>/dev/null)
        local last=$(jq -r '.last_indexed // "never"' "$index" 2>/dev/null)
        log_info "Entries indexed: $count"
        log_info "Last indexed: $last"
    else
        log_warn "No learnings index found"
    fi

    echo ""
}

# Main
main() {
    local command="${1:-}"
    shift || true

    local project_path="$PWD"
    local force="false"
    local dry_run="false"

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--project)
                project_path="$2"
                shift 2
                ;;
            -f|--force)
                force="true"
                shift
                ;;
            -n|--dry-run)
                dry_run="true"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                shift
                ;;
        esac
    done

    case $command in
        hooks)
            sync_hooks
            ;;
        project)
            sync_project "$project_path" "$force" "$dry_run"
            ;;
        status)
            show_status "$project_path"
            ;;
        all)
            sync_hooks
            sync_project "$project_path" "$force" "$dry_run"
            ;;
        ""|help|-h|--help)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

main "$@"
