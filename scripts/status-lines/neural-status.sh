#!/bin/bash
# Neural Claude Code - Compact Status Line
# Shows: dir | model | branch | cost | duration | context% | lines +/-
set -e

input=$(cat)

# Extract fields with jq (fallback to defaults)
model=$(echo "$input" | jq -r '.model.display_name // "?"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
dir=$(basename "$current_dir")
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
lines_add=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_rm=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

# Calculate context % from tokens if used_percentage not available
if [ -z "$ctx_pct" ]; then
  ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
  ctx_usage=$(echo "$input" | jq -r '.context_window.current_usage // null')
  if [ "$ctx_usage" != "null" ] && [ "$ctx_size" -gt 0 ] 2>/dev/null; then
    tokens=$(echo "$ctx_usage" | jq -r '(.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)')
    ctx_pct=$((tokens * 100 / ctx_size))
  else
    ctx_pct=0
  fi
fi

# Format duration (compact: Xm or Xh)
if [ "$duration_ms" -gt 0 ] 2>/dev/null; then
  mins=$(( duration_ms / 60000 ))
  if [ "$mins" -lt 60 ]; then
    dur="${mins}m"
  else
    hrs=$(( mins / 60 ))
    rem=$(( mins % 60 ))
    dur="${hrs}h${rem}m"
  fi
else
  dur="0m"
fi

# Git branch (cached, fast)
branch=""
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "")
fi

# Context bar (tiny visual)
if [ "$ctx_pct" -lt 25 ]; then
  ctx_icon="~"
elif [ "$ctx_pct" -lt 50 ]; then
  ctx_icon="="
elif [ "$ctx_pct" -lt 75 ]; then
  ctx_icon="#"
else
  ctx_icon="!"
fi

# Build output - compact single line
parts="$dir"

# Model (short)
case "$model" in
  Opus*)   parts="$parts | O4.6" ;;
  Sonnet*) parts="$parts | S4.5" ;;
  Haiku*)  parts="$parts | H4.5" ;;
  *)       parts="$parts | $model" ;;
esac

# Branch (with dirty indicator)
if [ -n "$branch" ]; then
  # Truncate long branch names
  if [ ${#branch} -gt 20 ]; then
    branch="${branch:0:18}.."
  fi
  dirty=$(git -C "$current_dir" status --porcelain 2>/dev/null)
  if [ -n "$dirty" ]; then
    branch="$branch *"
  fi
  parts="$parts | $branch"
fi

# Duration
parts="$parts | $dur"

# Context
parts="$parts | ctx:${ctx_pct}%${ctx_icon}"

# Lines changed
if [ "$lines_add" -gt 0 ] || [ "$lines_rm" -gt 0 ]; then
  parts="$parts | +${lines_add}/-${lines_rm}"
fi

echo "$parts"
