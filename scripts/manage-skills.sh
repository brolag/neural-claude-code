#!/bin/bash

# Neural Claude Code - Skills Manager v1.0.0
# Manage installed skills: enable, disable, update, uninstall

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Paths
PROJECT_SKILLS="./.claude/skills"
GLOBAL_SKILLS="$HOME/.claude/skills"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

log() {
    echo -e "${CYAN}[$(date +'%H:%M:%S')]${RESET} $*"
}

success() {
    echo -e "${GREEN}✓${RESET} $*"
}

error() {
    echo -e "${RED}✗${RESET} $*" >&2
}

warning() {
    echo -e "${YELLOW}⚠${RESET} $*"
}

info() {
    echo -e "${BLUE}ℹ${RESET} $*"
}

header() {
    echo ""
    echo -e "${BOLD}═══════════════════════════════════════════════════════════${RESET}"
    echo -e "${BOLD}  $*${RESET}"
    echo -e "${BOLD}═══════════════════════════════════════════════════════════${RESET}"
    echo ""
}

# ============================================================================
# SKILL DETECTION
# ============================================================================

list_project_skills() {
    local scope="$1"  # "active" or "disabled"
    local base_dir=""

    if [ "$scope" = "active" ]; then
        base_dir="$PROJECT_SKILLS"
    else
        base_dir="$PROJECT_SKILLS/.disabled"
    fi

    if [ ! -d "$base_dir" ]; then
        return
    fi

    find "$base_dir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v "^\." || true
}

list_global_skills() {
    local scope="$1"  # "active" or "disabled"
    local base_dir=""

    if [ "$scope" = "active" ]; then
        base_dir="$GLOBAL_SKILLS"
    else
        base_dir="$GLOBAL_SKILLS/.disabled"
    fi

    if [ ! -d "$base_dir" ]; then
        return
    fi

    find "$base_dir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v "^\." || true
}

is_skill_active() {
    local skill="$1"
    local location="$2"  # "project" or "global"

    if [ "$location" = "project" ]; then
        [ -d "$PROJECT_SKILLS/$skill" ]
    else
        [ -d "$GLOBAL_SKILLS/$skill" ]
    fi
}

is_skill_disabled() {
    local skill="$1"
    local location="$2"  # "project" or "global"

    if [ "$location" = "project" ]; then
        [ -d "$PROJECT_SKILLS/.disabled/$skill" ]
    else
        [ -d "$GLOBAL_SKILLS/.disabled/$skill" ]
    fi
}

# ============================================================================
# SKILL OPERATIONS
# ============================================================================

disable_skill() {
    local skill="$1"
    local location="$2"

    if [ "$location" = "project" ]; then
        local source="$PROJECT_SKILLS/$skill"
        local target="$PROJECT_SKILLS/.disabled/$skill"
    else
        local source="$GLOBAL_SKILLS/$skill"
        local target="$GLOBAL_SKILLS/.disabled/$skill"
    fi

    if [ ! -d "$source" ]; then
        error "Skill not found: $skill ($location)"
        return 1
    fi

    mkdir -p "$(dirname "$target")"
    mv "$source" "$target"
    success "Disabled: $skill ($location)"
}

enable_skill() {
    local skill="$1"
    local location="$2"

    if [ "$location" = "project" ]; then
        local source="$PROJECT_SKILLS/.disabled/$skill"
        local target="$PROJECT_SKILLS/$skill"
    else
        local source="$GLOBAL_SKILLS/.disabled/$skill"
        local target="$GLOBAL_SKILLS/$skill"
    fi

    if [ ! -d "$source" ]; then
        error "Skill not found in disabled: $skill ($location)"
        return 1
    fi

    mv "$source" "$target"
    success "Enabled: $skill ($location)"
}

uninstall_skill() {
    local skill="$1"
    local location="$2"

    if [ "$location" = "project" ]; then
        local target="$PROJECT_SKILLS/$skill"
    else
        local target="$GLOBAL_SKILLS/$skill"
    fi

    if [ ! -d "$target" ]; then
        # Check if it's disabled
        if [ "$location" = "project" ]; then
            target="$PROJECT_SKILLS/.disabled/$skill"
        else
            target="$GLOBAL_SKILLS/.disabled/$skill"
        fi
    fi

    if [ ! -d "$target" ]; then
        error "Skill not found: $skill ($location)"
        return 1
    fi

    rm -rf "$target"
    success "Uninstalled: $skill ($location)"
}

update_skill() {
    local skill="$1"
    local location="$2"

    local plugin_source="$PLUGIN_ROOT/skills/$skill"

    if [ ! -d "$plugin_source" ]; then
        error "Skill not found in plugin: $skill"
        return 1
    fi

    if [ "$location" = "project" ]; then
        local target="$PROJECT_SKILLS/$skill"
    else
        local target="$GLOBAL_SKILLS/$skill"
    fi

    if [ ! -d "$target" ] && [ ! -d "${target%/*}/.disabled/$skill" ]; then
        error "Skill not installed: $skill ($location)"
        return 1
    fi

    # Update in place (preserves active/disabled status)
    if [ -d "$target" ]; then
        rm -rf "$target"
        mkdir -p "$target"
        cp -r "$plugin_source/"* "$target/"
        success "Updated: $skill ($location) - active"
    else
        target="${target%/*}/.disabled/$skill"
        rm -rf "$target"
        mkdir -p "$target"
        cp -r "$plugin_source/"* "$target/"
        success "Updated: $skill ($location) - disabled"
    fi
}

# ============================================================================
# MENU FUNCTIONS
# ============================================================================

show_main_menu() {
    header "Neural Claude Code - Skills Manager"

    echo "Select action:"
    echo ""
    echo "  1) List installed skills"
    echo "  2) Enable/Disable skills"
    echo "  3) Update skills from plugin"
    echo "  4) Uninstall skills"
    echo "  5) Install new skills"
    echo "  6) Exit"
    echo ""
    read -p "Select [1-6]: " choice

    case "$choice" in
        1) show_list_menu ;;
        2) show_toggle_menu ;;
        3) show_update_menu ;;
        4) show_uninstall_menu ;;
        5) install_new_skills ;;
        6) exit 0 ;;
        *) error "Invalid selection" && exit 1 ;;
    esac
}

show_list_menu() {
    header "Installed Skills"

    echo -e "${BOLD}Project Skills${RESET} (./.claude/skills/)"
    echo ""

    # Active
    local active_project=($(list_project_skills "active"))
    if [ ${#active_project[@]} -gt 0 ]; then
        echo -e "${GREEN}Active:${RESET}"
        for skill in "${active_project[@]}"; do
            echo "  ✓ $skill"
        done
    else
        echo "  (none active)"
    fi

    echo ""

    # Disabled
    local disabled_project=($(list_project_skills "disabled"))
    if [ ${#disabled_project[@]} -gt 0 ]; then
        echo -e "${YELLOW}Disabled:${RESET}"
        for skill in "${disabled_project[@]}"; do
            echo "  ○ $skill"
        done
    fi

    echo ""
    echo -e "${BOLD}Global Skills${RESET} (~/.claude/skills/)"
    echo ""

    # Active
    local active_global=($(list_global_skills "active"))
    if [ ${#active_global[@]} -gt 0 ]; then
        echo -e "${GREEN}Active:${RESET}"
        for skill in "${active_global[@]}"; do
            echo "  ✓ $skill"
        done
    else
        echo "  (none active)"
    fi

    echo ""

    # Disabled
    local disabled_global=($(list_global_skills "disabled"))
    if [ ${#disabled_global[@]} -gt 0 ]; then
        echo -e "${YELLOW}Disabled:${RESET}"
        for skill in "${disabled_global[@]}"; do
            echo "  ○ $skill"
        done
    fi

    echo ""
    read -p "Press Enter to continue..." dummy
    show_main_menu
}

show_toggle_menu() {
    header "Enable/Disable Skills"

    echo "Select location:"
    echo "  1) Project (./.claude/skills/)"
    echo "  2) Global (~/.claude/skills/)"
    echo "  3) Back"
    echo ""
    read -p "Select [1-3]: " choice

    local location=""
    case "$choice" in
        1) location="project" ;;
        2) location="global" ;;
        3) show_main_menu; return ;;
        *) error "Invalid selection" && exit 1 ;;
    esac

    # List skills
    local active=($(list_${location}_skills "active"))
    local disabled=($(list_${location}_skills "disabled"))

    echo ""
    echo -e "${GREEN}Active skills (enter number to disable):${RESET}"
    if [ ${#active[@]} -gt 0 ]; then
        local idx=1
        for skill in "${active[@]}"; do
            echo "  $idx) ✓ $skill"
            ((idx++))
        done
    else
        echo "  (none)"
    fi

    echo ""
    echo -e "${YELLOW}Disabled skills (enter number to enable):${RESET}"
    local disabled_start=$idx
    if [ ${#disabled[@]} -gt 0 ]; then
        for skill in "${disabled[@]}"; do
            echo "  $idx) ○ $skill"
            ((idx++))
        done
    else
        echo "  (none)"
    fi

    echo ""
    echo "  b) Back"
    echo ""
    read -p "Select: " selection

    if [[ "$selection" == "b" ]] || [[ "$selection" == "B" ]]; then
        show_main_menu
        return
    fi

    if [[ "$selection" =~ ^[0-9]+$ ]]; then
        if [ "$selection" -lt "$disabled_start" ]; then
            # Disable active skill
            local skill="${active[$((selection-1))]}"
            disable_skill "$skill" "$location"
        else
            # Enable disabled skill
            local skill="${disabled[$((selection-disabled_start))]}"
            enable_skill "$skill" "$location"
        fi
    else
        error "Invalid selection"
    fi

    echo ""
    read -p "Press Enter to continue..." dummy
    show_toggle_menu
}

show_update_menu() {
    header "Update Skills from Plugin"

    echo "This will update skills from the plugin repository."
    echo ""
    echo "Select location:"
    echo "  1) Update project skills"
    echo "  2) Update global skills"
    echo "  3) Update all"
    echo "  4) Back"
    echo ""
    read -p "Select [1-4]: " choice

    case "$choice" in
        1)
            local skills=($(list_project_skills "active") $(list_project_skills "disabled"))
            for skill in "${skills[@]}"; do
                update_skill "$skill" "project"
            done
            ;;
        2)
            local skills=($(list_global_skills "active") $(list_global_skills "disabled"))
            for skill in "${skills[@]}"; do
                update_skill "$skill" "global"
            done
            ;;
        3)
            local project_skills=($(list_project_skills "active") $(list_project_skills "disabled"))
            for skill in "${project_skills[@]}"; do
                update_skill "$skill" "project"
            done
            local global_skills=($(list_global_skills "active") $(list_global_skills "disabled"))
            for skill in "${global_skills[@]}"; do
                update_skill "$skill" "global"
            done
            ;;
        4)
            show_main_menu
            return
            ;;
        *)
            error "Invalid selection" && exit 1
            ;;
    esac

    echo ""
    success "Update complete!"
    read -p "Press Enter to continue..." dummy
    show_main_menu
}

show_uninstall_menu() {
    header "Uninstall Skills"

    echo "Select location:"
    echo "  1) Project (./.claude/skills/)"
    echo "  2) Global (~/.claude/skills/)"
    echo "  3) Back"
    echo ""
    read -p "Select [1-3]: " choice

    local location=""
    case "$choice" in
        1) location="project" ;;
        2) location="global" ;;
        3) show_main_menu; return ;;
        *) error "Invalid selection" && exit 1 ;;
    esac

    # List all skills (active + disabled)
    local active=($(list_${location}_skills "active"))
    local disabled=($(list_${location}_skills "disabled"))
    local all_skills=("${active[@]}" "${disabled[@]}")

    if [ ${#all_skills[@]} -eq 0 ]; then
        warning "No skills installed in $location"
        read -p "Press Enter to continue..." dummy
        show_main_menu
        return
    fi

    echo ""
    echo "Select skill to uninstall:"
    local idx=1
    for skill in "${all_skills[@]}"; do
        echo "  $idx) $skill"
        ((idx++))
    done
    echo ""
    echo "  b) Back"
    echo ""
    read -p "Select: " selection

    if [[ "$selection" == "b" ]] || [[ "$selection" == "B" ]]; then
        show_main_menu
        return
    fi

    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#all_skills[@]} ]; then
        local skill="${all_skills[$((selection-1))]}"
        echo ""
        read -p "Are you sure you want to uninstall '$skill'? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            uninstall_skill "$skill" "$location"
        else
            warning "Cancelled"
        fi
    else
        error "Invalid selection"
    fi

    echo ""
    read -p "Press Enter to continue..." dummy
    show_uninstall_menu
}

install_new_skills() {
    header "Install New Skills"

    if [ -f "$PLUGIN_ROOT/scripts/install-skills.sh" ]; then
        bash "$PLUGIN_ROOT/scripts/install-skills.sh"
    else
        error "Installer not found at: $PLUGIN_ROOT/scripts/install-skills.sh"
        read -p "Press Enter to continue..." dummy
    fi

    show_main_menu
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Parse arguments
    case "${1:-}" in
        --list|-l)
            show_list_menu
            ;;
        --help|-h)
            echo "Neural Claude Code - Skills Manager v1.0.0"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --list, -l     List installed skills"
            echo "  --help, -h     Show this help"
            echo ""
            echo "Interactive mode (no options) provides full management menu."
            ;;
        "")
            show_main_menu
            ;;
        *)
            error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
