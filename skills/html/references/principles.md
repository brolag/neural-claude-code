# Anti-cognitive-fatigue principles

The 10 principles every artifact from this skill applies. Each: **what**, **why** (the research), **how** (in the templates). Follow the reasoning, not just the rule.

---

## 1. Progressive disclosure
**What:** Native `<details>/<summary>`. Keep the top-priority summary open; collapse secondary detail.
**Why:** Cuts extraneous cognitive load — the reader chooses depth instead of absorbing everything at once (Cognitive Load Theory, Sweller).
**How:** Each timeline node is a `<section>` wrapping `<details>`. Overview / primary sections start `open`; deep detail starts closed. Zero JS, keyboard-accessible by default.

## 2. Chunking
**What:** Max 3-5 items per visible group. Split longer lists under sub-headers (`<h3>`).
**Why:** Working memory holds ~4 chunks (Cowan 2001), not the misapplied "magic number 7" (Miller). Beyond that, the reader drops items.
**How:** Phases hold 3-5 tasks; long file lists group under `<h3>` and truncate with an explicit "+N more" note (never silently).

## 3. Visual hierarchy & intentional reading path
**What:** One dominant H1, a 2-3 weight type scale, generous whitespace.
**Why:** A single focal point + clear scale lets the eye triage. Dense sections get scanned F-pattern; sparse hero/summary get scanned Z-pattern.
**How:** One H1 + TL;DR per artifact. Section titles at one weight, body at another, labels uppercase-small. Cards breathe with padding.

## 4. Status at a glance — never color alone
**What:** Every status combines **color + icon + shape + text label**.
**Why:** ~8% of men have red/green color vision deficiency; color alone fails WCAG 1.4.1. Redundant encoding is readable by everyone.
**How:** Badge set — green `✓` "Done", amber `▲` (triangle) "Risk/Warning", red `■`/`✕` "Blocked/Error", blue `●` "Info", violet `◆` "Decision". Avoid pure red/green; the palette uses muted variants.

## 5. Persistent anchor nav
**What:** Sticky table-of-contents with in-page anchors and a "you-are-here" highlight.
**Why:** Keeps orientation external so the reader doesn't spend memory tracking position.
**How:** Left sticky `nav.toc` built from sections; an IntersectionObserver toggles `.here`. Collapses to a compact top bar under 820px. Stays under ~20% viewport.

## 6. Reading rhythm — alternate dense and sparse
**What:** Alternate dense blocks (tables, lists) with sparse ones (single-line callouts).
**Why:** Uniform density fatigues; rhythm gives the eye rest points.
**How:** Tables/task-lists sit next to one-line `.callout` rows. Don't stack three dense tables in a row.

## 7. Scroll-triggered entry animations — always guarded
**What:** Subtle fade + translateY on reveal; unobserve after first show (no repeat).
**Why:** Motion draws attention to new content, but vestibular disorders need it gone — WCAG 2.3.3.
**How:** IntersectionObserver adds `.in` once, then `unobserve`. Transitions ~150-250ms. **All motion lives inside `@media (prefers-reduced-motion: reduce){ ... }` that disables it** and elements render fully visible.

## 8. Friction reduction
**What:** Copy buttons on every command/code block; an Expand-all / Collapse-all control; never any horizontal scroll.
**Why:** Each manual step (select, scroll, retype) is a small tax that compounds.
**How:** `navigator.clipboard.writeText` with an `execCommand('copy')` fallback (the artifact may run in an iframe that blocks the Clipboard API via Permissions Policy). `setAll()` toggles all `<details>`. Layout uses fluid max-width; `overflow-x:hidden` on body; `pre` scrolls internally, the page never does.

## 9. "Needs Attention" floating panel
**What:** Fixed, dismissible panel aggregating EVERY blocked item, risk, and error, each linking to its anchor. Empty → calm "All clear".
**Why:** The single most important question a reader has is "what needs me?". Aggregating it removes the hunt.
**How:** `#na` lists static risks plus live items injected by the engine (blocking unanswered questions in the PlanViewer; errors/warnings in the ResultViewer). The count updates live; dismiss collapses to a small reopen pill.

## 10. Reading-time estimate
**What:** Word count ÷ ~238 wpm, rounded up, shown as "~X min".
**Why:** Adult silent reading of non-fiction averages 238 wpm (Brysbaert 2019, meta-analysis). It sets expectation and lowers the "how long is this?" friction.
**How:** Computed from `#content.innerText` at load. Shown as a small subtitle under the TL;DR, not as a hero stat (it's orientation, not a decision input).

---

## Two patterns layered on top of the principles

### Decision queue (PlanViewer · Open Questions)
A self-contained HTML artifact **cannot send anything back to Claude** — there is no channel from the artifact to the agent. So "managing" open questions means **closing the loop manually**: the document helps you decide, then exports your answers as markdown you paste into chat.
- Each question is a card: text + optional option-buttons + free-text answer + a blocking/info toggle.
- Answering live-updates the **bloqueantes** stat, the Needs-Attention count, and the `approved` gate step.
- **"Copiar respuestas para Claude"** emits markdown (answered → `n. question → answer [bloqueante]`, plus an "unanswered" list). That paste is how answers reach Claude.
- State persists via `localStorage` with an in-memory fallback (try/catch) so reloads don't lose input.

### Stat-hero = decision-grade metrics, not vanity
Counting files/phases/decisions looks informative but doesn't change whether you approve. Use metrics that drive the decision, all fillable by Claude when generating:
- **Effort** (S/M/L or ~Xd) · **Downtime** (Zero/Yes) · **Blast radius** (modules/services touched, prod? db?) · **External deps** (N) · **Open blockers** (N, live) · **Risk** (Low/Med/High) · **Reversibility** (per-phase/partial/irreversible) · **Security surface** (auth/PII/payments/secrets) · **Readiness** (High/Med/Low) · **Acceptance coverage** (subtasks with executable criteria).

---

## Sources
- Sweller, J. — Cognitive Load Theory.
- Cowan, N. (2001) — *The magical number 4 in short-term memory.*
- Brysbaert, M. (2019) — *How many words do we read per minute? A review and meta-analysis of reading rate.*
- WCAG 2.2 — 1.4.1 Use of Color · 2.3.3 Animation from Interactions.
- Nielsen Norman Group — F-pattern / Z-pattern reading.
