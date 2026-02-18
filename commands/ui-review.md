---
description: "Run parallel UI review agents against a URL using Playwright CLI"
allowed-tools: Bash, Read, Write, Task, Glob
---

# UI Review — Parallel Agentic QA

Run N parallel browser agents against a target URL, each executing a different user story. Returns a consolidated QA report with screenshot evidence.

## Instructions

You are orchestrating a parallel UI review. Follow these steps:

### 1. Parse Input

The user provides: `$ARGUMENTS`
- Extract the target URL
- If no URL provided, ask for one

### 2. Create Screenshot Directory

```bash
mkdir -p output/qa-screenshots
```

### 3. Define User Stories

Generate 3-5 user stories appropriate for the target URL:
- **Navigation**: Can a user navigate the main sections?
- **Content**: Is key content visible and readable?
- **Responsive**: Does it work at mobile viewport (375px)?
- **Interactions**: Do buttons, links, and forms work?
- **Performance**: Does the page load within 3 seconds?

### 4. Launch Parallel QA Agents

Use the Task tool to launch 3 agents in parallel, each with subagent_type "general-purpose":

**Agent 1 — Navigation & Content QA**:
```
Test URL: [url]
1. Take full-page screenshot: npx playwright screenshot [url] output/qa-screenshots/agent1-step01-fullpage.png --full-page
2. Check if page loads (non-empty screenshot)
3. Check viewport at 1280x720: npx playwright screenshot [url] output/qa-screenshots/agent1-step02-desktop.png --viewport-size "1280,720"
4. Report: page title, main heading, visible sections, any broken elements
```

**Agent 2 — Mobile & Responsive QA**:
```
Test URL: [url]
1. Mobile viewport: npx playwright screenshot [url] output/qa-screenshots/agent2-step01-mobile.png --viewport-size "375,812"
2. Tablet viewport: npx playwright screenshot [url] output/qa-screenshots/agent2-step02-tablet.png --viewport-size "768,1024"
3. Report: layout breaks, text overflow, touch target sizes, scrolling issues
```

**Agent 3 — Performance & Accessibility QA**:
```
Test URL: [url]
1. Screenshot with wait: npx playwright screenshot [url] output/qa-screenshots/agent3-step01-loaded.png --wait-for-timeout 5000
2. Check page source for: meta tags, alt text, semantic HTML, heading hierarchy
3. Report: load time estimate, missing alt text, accessibility concerns
```

### 5. Consolidate Report

After all agents complete, produce the report:

```markdown
## UI Review: [URL]
**Date**: [timestamp] | **Agents**: 3 | **Screenshots**: [count]

### Results

| Agent | Focus | Result | Issues |
|-------|-------|--------|--------|
| QA-1 | Navigation & Content | PASS/FAIL | ... |
| QA-2 | Mobile & Responsive | PASS/FAIL | ... |
| QA-3 | Performance & A11y | PASS/FAIL | ... |

### Issues Found
1. [description + screenshot reference]

### Screenshots
All saved to `output/qa-screenshots/`
```

## Usage

```bash
/ui-review https://example.com
/ui-review http://localhost:3000
/ui-review my-project/index.html
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Playwright not found | Not installed | `npm i -g @playwright/cli && npx playwright install chromium` |
| URL unreachable | Bad URL or server down | Verify URL is accessible |
| Screenshots empty | Page requires JS or auth | Try with --wait-for-timeout 5000 |

**Fallback**: If parallel agents fail, run sequential screenshots with Playwright CLI directly.
