---
name: html
description: Render a Claude Code plan (PlanViewer), a task result, or a recap of a branch/commit/PR diff (ResultViewer) as a single-file HTML artifact with anti-fatigue UX. Use when the user asks for an HTML artifact, a plan/result/recap view, or to "show this as HTML". Not for plain markdown/text or one-liners.
allowed-tools: Read, Write, Bash
argument-hint: "[plan|result] [source-path | git-ref]"
---

# html

Build a single-file, framework-free HTML artifact that makes a plan or a run report easy and calm to read. Two templates: **PlanViewer** (before executing) and **ResultViewer** (after finishing).

**Always read `references/principles.md` before building.** It holds the 10 anti-cognitive-fatigue principles with the reasoning behind each — follow the reasoning, not just the rule.

## When to use
- The user explicitly asks for an "HTML artifact", a "plan/result view", a "dashboard", or to "show this as HTML".
- You are presenting a multi-phase plan/proposal/breakdown and the user wants it as a document.
- You just finished a multi-step task and the user wants a visual summary of what changed.
- The user wants a **recap** of a branch, commit, or PR diff (what a set of changes did), built from the real diff rather than from session memory.

## When NOT to use
- A one-line answer, a single code snippet, or prose explanation.
- The user wants plain text or markdown only.
- Do NOT auto-fire on every plan. `spec` already emits its own `plan.html` in the plan→craft flow; this skill is **on-demand and standalone**. Trigger only on an explicit request.

## 1. Pick the template
- **PlanViewer** (pre-execution) → `templates/plan-viewer.html`. Sections: Overview · Phases & Tasks · Decisions · Risks · Open Questions.
- **ResultViewer** (post-execution) → `templates/result-viewer.html`. Sections: Summary · Files Changed · Commands Run · Errors/Warnings · Next Steps.
  - **Recap from a diff:** point the ResultViewer at a branch, commit, or PR instead of the current session. Read the real change with read-only git (`git diff <base>...<ref>`, `git show <commit>`, `git log --stat`) and fill Files Changed, per-file diffs, and stats from that output. Same template, the source is the diff. This is the reverse of a plan: it describes the change that was just made, one altitude above line-by-line review.

If the user's intent is ambiguous (could be either), ask once; otherwise infer from tense ("show me the plan" → Plan, "what changed" → Result).

## 2. Build it
1. **Read** the chosen template in full.
2. **Replace every `<!-- REPLACE ... -->` block** with the real content. Keep `<style>` and `<script>` intact unless the project defines its own palette.
3. **Fill the stat-hero with decision-grade metrics** (see §6), not file/phase counts.
4. **Wire every risk/error/blocker into the Needs-Attention panel** (`#na`) with a link to its anchor. If there are none, render the calm "All clear" empty state.
5. **In the PlanViewer, turn Open Questions into a decision queue** (see §7).
6. **Run the self-check** (§9) before presenting.

**Recap-from-diff source:** when building a recap, first extract the real change with read-only git — `git diff <base>...<ref>`, `git show <commit>`, `git log --stat` — and derive Files Changed, per-file diffs, and stats from that output. Never hand-summarize a file you did not read in the diff. Keep the body lean (no "this is just an aid" boilerplate) but substantial: a file list plus the key per-file diffs, not one sentence. See §4b.

## 3. The 10 anti-fatigue principles (summary)
Detailed in `references/principles.md`. In one line each:
1. Progressive disclosure — native `<details>`, top summary open, detail collapsed.
2. Chunking — 3-5 items per group; split longer under `<h3>`.
3. Visual hierarchy — one H1 + TL;DR, 2-3 weight scale, whitespace.
4. Status never by color alone — color + icon + shape + text (WCAG 1.4.1).
5. Sticky anchor nav with you-are-here.
6. Reading rhythm — alternate dense tables and sparse callouts.
7. Entry animations — subtle, unobserved after first reveal, fully disabled under `prefers-reduced-motion`.
8. Friction reduction — copy buttons, expand/collapse all, never horizontal scroll.
9. Needs-Attention floating panel aggregating everything blocking.
10. Reading-time (`words / 238`) as a small subtitle, not a hero stat.

## 4. Hard rules (local browser-first, self-contained)
- **One `.html` file.** Inline ALL CSS and JS. No frameworks, no build step.
- **No external resources** — no CDN, no Google Fonts. Use a system font stack.
- **Apply `font-family` LITERALLY, never via CSS `var()`** — some browsers don't honor `var()` inside `font-family` and silently fall back to serif. (Colors via `var()` are fine.)
- **`localStorage` only inside try/catch with an in-memory fallback** — never assume it exists; the artifact may run in a sandboxed iframe where it throws.
- **No horizontal scroll** at any width: `overflow-x:hidden` on body, `pre` scrolls internally, fluid `max-width`.
- Default typeface (cross-platform humanist chain): `"Avenir Next","Avenir","Segoe UI",system-ui,Roboto,"Helvetica Neue",Arial,sans-serif` — Avenir on macOS, Segoe UI on Windows, Roboto on Android/Linux. Mono: `ui-monospace,SFMono-Regular,Menlo,Consolas,monospace`.

## 4b. Grounding — true by construction
The factual blocks (Files Changed, Commands Run, diffs, stats, the stat-hero metrics) must be derived **mechanically from real state** — the actual `git diff`, real command output, the real plan text — never inferred, rounded, or invented. The model writes freely ONLY in the prose: the Summary's "what and why", the risk read, the narrative. A confidently wrong recap is dangerous in review: a reader who trusts the summary may skip the exact line it got wrong.
- If a fact is not in the diff / output / source, leave it out rather than guess. Mark anything you **inferred** (not extracted) as inferred, in text.
- **Redact secrets.** A diff or log can carry API keys, tokens, `.env` values, webhook URLs. Never transcribe them into any block, caption, or note — replace with `sk-•••` / `<redacted>` (CWE-200/CWE-532).
- **Read-only git only.** The recap git commands above never mutate the repo. Use fixed, literal refs; never interpolate untrusted input into the shell (CWE-78).

## 5. Aesthetic — avoid AI slop
- Commit to ONE calm, legible, professional look. Neutral-dominant palette + 1-2 sharp accents via CSS variables (colors only).
- **Reuse the project's palette if it defines one** (tailwind `theme.colors`, CSS `:root` vars, a brand/design doc) — same instinct as `spec`'s `plan.html`. Otherwise the template defaults.
- Avoid: purple-on-white gradients, uniformly rounded everything, dead-centered layouts, maximalism. This is a working tool, not a poster — prioritize calm and legibility.
- Dark mode is automatic via `prefers-color-scheme`; keep both palettes legible.

## 6. Stat-hero = decision-grade metrics, not vanity
Counting files/phases/decisions looks informative but doesn't change a decision. Use metrics that do — all fillable by you when generating:
- **Effort** (S/M/L or ~Xd) · **Downtime** (Zero/Yes) · **Blast radius** (modules/services; prod? db?) · **External deps** (N) · **Open blockers** (N — live from the decision queue) · **Risk** (Low/Med/High) · **Reversibility** (per-phase/partial/irreversible) · **Security surface** (auth/PII/payments/secrets) · **Readiness** (High/Med/Low) · **Acceptance coverage** (subtasks with executable criteria).
- Pick ~6 that fit the change. Text values use `.v`; numbers use `.n` (count-up). Severity tint via `s-done` / `s-risk` / `s-error`.
- Reading-time is NOT a hero stat — it's a small subtitle under the TL;DR.

## 7. Open Questions = decision queue + copy-back (PlanViewer)
A self-contained artifact **cannot send anything back to Claude** — there is no channel from the document to the agent. So managing open questions means **closing the loop by hand**:
- Each question is a card: text + optional option-buttons + free-text answer + a blocking/info toggle.
- Answering live-updates the **blockers** stat, the Needs-Attention count, and the `approved` gate step.
- The **"Copiar respuestas para Claude"** button exports markdown (answered + unanswered) that the user pastes into chat — that paste is how answers reach you.
- State persists via `localStorage` with in-memory fallback.
- The ResultViewer's Next Steps use the same shape: checkable list + "Copiar próximos pasos".

## 8. Output format
- Write to `artifacts/<YYYY-MM-DD>-<plan|result>-<slug>.html` (or the path the user gave).
- Mark the file clearly as generated (header/footer note); it's a regenerable view, not a hand-edited source.
- After writing, tell the user the path and offer to open it (macOS `open`, Windows `start`, Linux `xdg-open`).

## 9. Self-check (run before presenting)
- [ ] Single self-contained `.html`? No CDN, no external fonts?
- [ ] `font-family` literal (not via `var()`)?
- [ ] `localStorage` wrapped in try/catch with fallback?
- [ ] Every status uses color + icon + shape + text (never color alone)?
- [ ] All motion wrapped in `prefers-reduced-motion`?
- [ ] No horizontal scroll at ~400px and at full width?
- [ ] Needs-Attention panel present, aggregating every risk/error/blocker (or "All clear")?
- [ ] Stat-hero is decision-grade, not vanity counts?
- [ ] Reading-time shown (as subtitle)?
- [ ] PlanViewer: Open Questions are a working decision queue with copy-back?
- [ ] Factual blocks (files, commands, diffs, stats, metrics) derived from real state, not invented — and anything inferred marked as inferred? (§4b)
- [ ] No secrets transcribed from diffs/logs — redacted? (§4b)
