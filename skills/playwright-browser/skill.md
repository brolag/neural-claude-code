---
name: playwright-browser
description: "Agentic browser automation and UI testing via Playwright CLI. Use when: user wants to test a website, automate browser tasks, run parallel QA agents, do visual regression testing. Don't use when: user wants interactive browser debugging (use Chrome DevTools MCP instead)."
trigger: /ui-test, /browser-auto, "test the UI", "QA this site"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Task
---

# Playwright Browser Automation Skill

Token-efficient browser automation via Playwright CLI. Supports headless parallel sessions, persistent profiles, and screenshot trails.

## Core Technology

- **Playwright CLI**: `npx playwright` — headless by default, parallel sessions, named profiles
- **Chrome DevTools MCP**: For interactive debugging (complementary, not replacement)

## Architecture (4-Layer Stack)

```
Layer 1: SKILL (this file) — raw browser capability
Layer 2: SUBAGENTS — specialized parallel browser agents
Layer 3: COMMANDS — orchestration (/ui-review, /browser-auto)
Layer 4: SCRIPTS — one-command reusability
```

## Usage

### Quick UI Test
```bash
# Test a single URL
npx playwright screenshot <url> screenshot.png --full-page

# Run a Playwright script
npx playwright test <test-file>
```

### Parallel QA (via subagents)
```bash
# Launch 3 parallel QA agents against a URL
/ui-review <url>
```

### Browser Automation
```bash
# Automate a workflow
/browser-auto "login to site X and download report"
```

## Playwright CLI Reference

```bash
# Screenshots
npx playwright screenshot <url> <output.png> [--full-page] [--wait-for-selector <sel>]

# Code generation (record interactions)
npx playwright codegen <url>

# Run tests
npx playwright test [--headed] [--browser chromium|firefox|webkit]

# Open inspector
npx playwright open <url>

# Install browsers
npx playwright install [chromium|firefox|webkit]
```

## Subagent Pattern

When launching parallel QA agents, each agent should:

1. Navigate to the target URL
2. Execute its assigned user story
3. Take screenshots at each step (save to `output/qa-screenshots/`)
4. Report pass/fail with evidence
5. Return concise summary to orchestrator

### Screenshot Trail

Every QA agent creates a screenshot trail:
```
output/qa-screenshots/
  agent-1-step-01-homepage.png
  agent-1-step-02-navigation.png
  agent-1-step-03-result.png
  agent-2-step-01-homepage.png
  ...
```

## Test File Template

```typescript
// tests/ui-review.spec.ts
import { test, expect } from '@playwright/test';

test('user story: navigate and verify', async ({ page }) => {
  await page.goto('URL_HERE');
  await page.screenshot({ path: 'output/qa-screenshots/step-01.png' });

  // Verify content
  await expect(page.locator('h1')).toBeVisible();

  // Navigate
  await page.click('a[href="/about"]');
  await page.screenshot({ path: 'output/qa-screenshots/step-02.png' });
});
```

## Integration with Existing Tools

- **Chrome DevTools MCP**: Use for interactive sessions, live debugging
- **Playwright CLI**: Use for automated testing, parallel QA, CI/CD
- **Autonomous Dev Scanners**: Add as visual regression scanner (scanner #7)

## Output Format

```markdown
## UI Review: [URL]

**Agents**: 3 | **Duration**: 45s | **Screenshots**: 9

| Agent | User Story | Result | Steps | Issues |
|-------|-----------|--------|-------|--------|
| QA-1  | Navigation flow | PASS | 3/3 | None |
| QA-2  | Form submission | FAIL | 2/3 | Button unresponsive |
| QA-3  | Mobile responsive | PASS | 3/3 | None |

### Failures
- **QA-2 Step 3**: Submit button does not respond to click. Screenshot: `qa-2-step-03.png`
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Browser not found | Playwright browsers not installed | `npx playwright install chromium` |
| Timeout on navigation | Page too slow or URL unreachable | Increase timeout or check URL |
| Screenshot permission denied | Output dir doesn't exist | `mkdir -p output/qa-screenshots` |

**Fallback**: If Playwright CLI fails, fall back to Chrome DevTools MCP for single-browser testing.
