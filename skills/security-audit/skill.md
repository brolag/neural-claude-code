---
name: security-audit
description: "Security audit for Claude Code projects. Use when: opening unfamiliar repos, before deploying, after installing skills/MCPs, or on-demand. Don't use when: quick code reviews (use /overseer), general code quality (use /slop-scan)."
trigger: /security-audit
allowed-tools: Read, Glob, Grep, Bash
---

# Security Audit Skill

4-tier security audit for Claude Code projects. Scans configuration, supply chain, application code, and AI-specific risks.

## Usage

```bash
# Full audit — all 4 tiers (~2-5 min)
/security-audit

# Quick config scan — Tier 1 only (~30s)
/security-audit --quick

# Application code only — Tiers 3-4
/security-audit --code

# Supply chain only — Tier 2 (before installing skills/MCPs)
/security-audit --skills

# Scan a specific path
/security-audit /path/to/project
```

## Execution

### Step 0: Determine mode and project

Parse arguments:
- No args or path only → full audit (all tiers)
- `--quick` → Tier 1 only
- `--code` → Tiers 3+4 only
- `--skills` → Tier 2 only

Default project path: current working directory.

### Step 1: Initialize

```
findings = []  # {id, tier, severity, check, message, file, line}
```

Severity levels: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`

---

## Tier 1: Claude Code Configuration (~30s)

**Always run this tier.** This is where the most actively exploited vulnerabilities live (CVE-2025-59536, CVE-2026-21852).

### C1: Hook Injection Scan

Search ALL hook scripts referenced in settings for dangerous patterns:

```bash
# Find settings files
.claude/settings.json
.claude/settings.local.json
~/.claude/settings.json
```

Read each settings file. For every hook command found:
1. If it's a script file → Read it and scan for:
   - `curl`, `wget`, `nc`, `ncat` (network exfiltration)
   - `base64 -d` piped to `bash` or `sh` (encoded payloads)
   - `$ANTHROPIC_API_KEY` or `$CLAUDE_` env var references
   - Outbound connections to non-localhost URLs
   - `eval` with dynamic content
2. If it's an inline command → scan the command string for same patterns

**Severity**: CRITICAL for any match (direct RCE vector per CVE-2025-59536)

### C2: MCP Configuration Risk

Read MCP configs:
```
.mcp.json
~/.claude/mcp.json
```

Check for:
- `enableAllProjectMcpServers: true` → HIGH (auto-trusts all MCPs)
- Unversioned packages (no `@x.y.z` pinning) → MEDIUM
- Database MCPs without `readonly` in env vars → HIGH
- MCPs with `--dangerous` flags → CRITICAL
- Unknown/unvetted MCP servers → MEDIUM (cross-reference with threat-db.yaml if available)

### C3: CLAUDE.md Injection

Read all instruction files:
```
CLAUDE.md
.claude/CLAUDE.md
.claude/rules/*.md
AGENTS.md
```

Scan for:
- Zero-width unicode characters (U+200B, U+200C, U+200D, U+FEFF, U+2060) → CRITICAL
- RTL override characters (U+202A-U+202E, U+2066-U+2069) → CRITICAL
- Role override phrases: "ignore previous", "you are now", "disregard" → CRITICAL
- Base64 blocks in HTML comments → HIGH
- Suspicious `<script>` or `javascript:` in markdown → HIGH
- References to external URLs that fetch and execute content → HIGH

### C4: Permission Audit

Read `.claude/settings.json` and check:
- No `permissions.deny` list at all → MEDIUM
- `permissions.deny` doesn't include `.env` → HIGH
- `skipDangerousModePermissionPrompt: true` without deny rules → HIGH
- `ANTHROPIC_BASE_URL` set in project config → CRITICAL (CVE-2026-21852)

---

## Tier 2: Skill & MCP Supply Chain

### C5: Installed Skill Body Scan

Find all skill files:
```
.claude/skills/*/skill.md
.claude/skills/**/SKILL.md
```

For each skill, scan for:
- `curl | bash` or `wget | bash` patterns → CRITICAL
- `eval` with `base64 -d` → CRITICAL
- References to `$ANTHROPIC_API_KEY` or credential env vars → HIGH
- Prompt manipulation phrases in skill body → HIGH
- `allowed-tools` including `Bash` without clear justification → MEDIUM
- Scripts in `scripts/` subdirectories → scan each for same patterns

### C6: MCP Tool Description Poisoning

If MCP servers are configured, use Bash to list their tools:
```bash
# For each MCP in config, check tool descriptions
```

Look for:
- Tool descriptions containing instruction-like text ("always", "must", "ignore") → HIGH
- Tool names that shadow built-in tools (`read`, `write`, `bash`, `edit`) → CRITICAL
- Unusually long tool descriptions (>500 chars) that may contain hidden instructions → MEDIUM

---

## Tier 3: Application Code

### C7: Hardcoded Secrets

Use Grep to scan project files (excluding node_modules, .git, dist, build, vendor):

```
Patterns (regex):
sk-ant-[a-zA-Z0-9]{20,}          # Anthropic
sk-[a-zA-Z0-9]{20,}              # OpenAI
AKIA[0-9A-Z]{16}                  # AWS Access Key
(ghp|gho|ghu|ghs|ghr)_[a-zA-Z0-9]{36,}  # GitHub
(sk|pk)_(live|test)_[0-9a-zA-Z]{24,}     # Stripe
xox[baprs]-[0-9a-zA-Z-]{10,}     # Slack
glpat-[a-zA-Z0-9_-]{20,}         # GitLab
-----BEGIN.*PRIVATE KEY-----       # Private keys
(postgres|mysql|mongodb)://[^:]+:[^@]+@   # DB URLs with passwords
```

Exclude: `*.md`, `*.yaml`, `*.example`, `*.sample`, `threat-db.yaml`, `*.test.*`

**Severity**: CRITICAL for any match in non-test, non-example files

### C8: Injection Vulnerabilities

Scan source code files (`.ts`, `.js`, `.py`, `.go`, `.rs`, `.java`):

- **SQL injection**: String interpolation in SQL (`${`, `f"`, `.format(`, `%s` in raw queries without parameterization) → HIGH
- **Command injection**: `child_process.exec` with template literals, `subprocess.run(shell=True)` with user input, `os.system()` → HIGH
- **Path traversal**: `../` in file path construction without sanitization → MEDIUM
- **SSRF**: Fetch/request with user-controlled URLs without allowlist → MEDIUM

### C9: Auth Weaknesses

- Hardcoded passwords in source (not config) → CRITICAL
- `alg: "none"` or `algorithm: "none"` in JWT config → CRITICAL
- Routes/endpoints without auth middleware (heuristic — look for route definitions without auth decorators/middleware) → LOW

### C10: Dependency Vulnerabilities

Run available audit tools (don't fail if not installed):

```bash
# Node.js
npm audit --json 2>/dev/null | jq '.metadata.vulnerabilities | {high, critical}'

# Python
pip-audit --format json 2>/dev/null | jq 'length'

# Go
go list -json -m all 2>/dev/null | nancy sleuth 2>/dev/null
```

Only flag HIGH and CRITICAL findings.

---

## Tier 4: AI-Specific Risks (OWASP Agentic ASI01-ASI10)

### C11: Prompt Injection Surface

Look for patterns where user input flows into prompts:
- Template literals containing `userInput`, `user_input`, `message`, `query` adjacent to system prompt construction → HIGH
- `WebFetch` results injected into prompts without sanitization → MEDIUM
- RAG results passed directly as context without attribution markers → MEDIUM

### C12: Excessive Agency

Check agent configurations:
- Agents with `allowed-tools: *` or no tool restrictions → MEDIUM
- Agents that can spawn sub-agents without limits → MEDIUM
- No `permissions.deny` scoping agent capabilities → HIGH

### C13: Sensitive Info Disclosure

- Debug modes enabled in production configs → MEDIUM
- Logging full conversation history/prompts → HIGH
- Error messages exposing file paths, stack traces, or system info → LOW

---

## Scoring

```
Starting score: 100

Deductions:
  CRITICAL: -30 pts (instant F if any found)
  HIGH:     -15 pts
  MEDIUM:    -5 pts
  LOW:       -1 pt

Letter grades:
  A: 90-100  (0 critical, 0 high, ≤2 medium)
  B: 75-89   (0 critical, 0-1 high)
  C: 60-74   (0 critical, 1-2 high)
  D: 40-59   (0 critical, 3+ high)
  F: <40 OR any CRITICAL finding
```

---

## Output Format

```markdown
# Security Audit Report

**Project**: {project path}
**Date**: {date}
**Mode**: {full|quick|code|skills}
**Score**: {score}/100 — Grade: {A|B|C|D|F}

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | {n}   |
| HIGH     | {n}   |
| MEDIUM   | {n}   |
| LOW      | {n}   |

## Findings

### CRITICAL

#### [{id}] {check name}
- **File**: {path}:{line}
- **Finding**: {description}
- **Risk**: {what can happen}
- **Fix**: {specific remediation}

### HIGH
...

### MEDIUM
...

### LOW
...

## Tiers Scanned

| Tier | Status | Findings |
|------|--------|----------|
| T1: Config     | {scanned/skipped} | {n} |
| T2: Supply Chain | {scanned/skipped} | {n} |
| T3: App Code   | {scanned/skipped} | {n} |
| T4: AI-Specific | {scanned/skipped} | {n} |

## Recommendations

1. {Top priority fix}
2. {Second priority}
3. {Third priority}

---
*Neural Claude Code Security Audit v1.0*
*Sources: OWASP Agentic AI Top 10, Snyk ToxicSkills, CVE database*
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No .claude/ directory | Not a Claude Code project | Run T3+T4 only (app code + AI risks) |
| npm/pip not installed | Missing package manager | Skip C10 (dependency audit), note in report |
| No source code found | Empty or docs-only project | Run T1+T2 only (config + supply chain) |
| Permission denied on files | Restricted access | Note which files couldn't be scanned |

**Fallback**: If a check fails, log the error, skip it, and continue. Never abort the full audit for a single check failure.

## References

- [OWASP Agentic AI Security Risks 2026](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [Snyk ToxicSkills](https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/)
- [CVE-2025-59536 Hook RCE](https://research.checkpoint.com/2026/rce-and-api-token-exfiltration-through-claude-code-project-files-cve-2025-59536/)
- [CVE-2026-21852 API Key Exfiltration](https://research.checkpoint.com/2026/rce-and-api-token-exfiltration-through-claude-code-project-files-cve-2025-59536/)
- [Flatt Security - 8 ways to pwn Claude Code](https://flatt.tech/research/posts/pwning-claude-code-in-8-different-ways/)
- [AgentShield](https://github.com/affaan-m/everything-claude-code)
