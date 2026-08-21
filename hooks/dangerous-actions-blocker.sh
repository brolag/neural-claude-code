#!/bin/bash
# Hook: PreToolUse — Block destructive actions
# Exit 0 = allow, Exit 2 = block
set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty')

if [[ "$TOOL_NAME" == "Bash" ]]; then
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty')

    # rm -rf of a protected root ITSELF (or its trailing-slash / glob form),
    # not subpaths. `rm -rf /tmp/build` and `rm -rf ~/proj` stay allowed;
    # `rm -rf /`, `~`, `$HOME`, and system dirs (/etc /usr /var ...) are blocked.
    # The target alternation matches the actual argument, so deleting a child
    # of a protected dir (e.g. `rm -rf /etc/myapp`) is still permitted.
    if echo "$COMMAND" | grep -qE '(^|[;&|[:space:]])rm[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*-[a-zA-Z]*r[a-zA-Z]*([[:space:]]+-[a-zA-Z]+)*[[:space:]]+"?(/|~|\$HOME|\$\{HOME\}|/etc|/usr|/var|/bin|/sbin|/lib|/lib64|/boot|/dev|/proc|/sys|/opt|/root|/home|/System|/Library|/Applications)/?\*?"?([[:space:]]|$|[;&|])' 2>/dev/null; then
        echo "BLOCKED: Destructive command detected: 'rm -rf' targeting a protected root (/, ~, \$HOME, or a system dir)" >&2
        exit 2
    fi

    for pattern in "dd if=" "mkfs" \
        ":(){:|:&};:" "> /dev/sda" "chmod -R 777 /" "--no-preserve-root" \
        "DROP DATABASE" "DROP TABLE"; do
        if [[ "$COMMAND" == *"$pattern"* ]]; then
            echo "BLOCKED: Destructive command detected: '$pattern'" >&2
            exit 2
        fi
    done

    if echo "$COMMAND" | grep -qE "git push.*(-f|--force).*(main|master)" 2>/dev/null; then
        echo "BLOCKED: Force push to main/master" >&2
        exit 2
    fi

    if echo "$COMMAND" | grep -qE "^(npm|pnpm|yarn) publish" 2>/dev/null; then
        echo "BLOCKED: Package publication requires manual confirmation" >&2
        exit 2
    fi

    if echo "$COMMAND" | grep -qE "rm -r|rmdir" 2>/dev/null; then
        echo '{"systemMessage": "Warning: File deletion detected. Verify this is intentional."}'
    fi
fi

if [[ "$TOOL_NAME" == "Edit" || "$TOOL_NAME" == "Write" ]]; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
    FILENAME=$(basename "$FILE_PATH" 2>/dev/null || echo "")

    for protected in ".env" ".env.local" ".env.production" "credentials.json" \
        "serviceAccountKey.json" "id_rsa" "id_ed25519" ".npmrc" ".pypirc"; do
        if [[ "$FILENAME" == "$protected" ]]; then
            echo "BLOCKED: Writing to sensitive file '$FILENAME'" >&2
            exit 2
        fi
    done
fi

exit 0
