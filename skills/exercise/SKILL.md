---
name: exercise
description: "Behavioral verification gate: run the test suite, then drive the running software as a real user (CLI/HTTP by default; browser or computer-use if those MCP tools are available) to confirm a feature works end to end. Reports PASS/FAIL per scenario with evidence. Use after a build, before ship, or as /craft's behavioral gate alongside /vet. Don't use for static code review (that is /vet)."
argument-hint: "[--spec <plan path>] [--scenario \"...\"] [app / url / command]"
allowed-tools: Bash(npm *), Bash(npx *), Bash(pytest *), Bash(cargo *), Bash(go *), Bash(python *), Bash(node *), Bash(curl *), Read, Glob, Grep
---

# /exercise — Behavioral Verification Gate

Run the tests, then drive the running app as a real user to confirm the feature works end to end. The
dynamic counterpart to `/vet`: vet asks "is this written right?", exercise asks "does it work for a user?".

Discipline: evidence over assertion. Every scenario carries command output, an HTTP response, a console
excerpt, or a screenshot. A green claim with no evidence is a FAIL.

## 1. Detect the app type and pick the backend

Default to what works with no extra dependencies:
- **CLI / TUI app**: run the binary, feed input, read output.
- **Web app / HTTP service** (a dev server, a `start`/`dev` script, a URL): launch it and drive it over
  HTTP with `curl` (status codes, response bodies, redirects).

Optional richer backends, used ONLY if the matching MCP tools are present in this session:
- **Browser** (claude-in-chrome or chrome-devtools, loaded via ToolSearch): click/fill/screenshot a real
  page. Use when the assertion is visual or needs the DOM/console.
- **Desktop / GUI** (computer-use): screenshot + click/type.

If those MCP tools are NOT available, do not block — fall back to the test suite + CLI/HTTP path and say so
in the report (e.g. "browser backend unavailable; verified via HTTP responses").

## 2. Run the test suite first

Detect and run the project's tests, capture the output as evidence: `npm test` / `npm run test:run`,
`pytest`, `cargo test`, `go test ./...`, etc. Record pass/fail counts. A failing suite is a FAIL for the
run; report it, do not present user-simulation as green over a red suite. If no test suite exists, state
`Tests: none found` explicitly and treat it as a caveat in the verdict, never a silent skip.

## 3. Source the scenarios

- If `--spec <plan>` is given (or the latest approved plan exists), derive scenarios from its acceptance
  criteria (the `verify:` / when-requires-ensures lines): each becomes a user flow to walk.
- Else ask the user for the 1-3 key flows ("what should a user be able to do?").

Keep scenarios small and concrete: a named flow with steps and one expected observable result.

## 4. Launch the app

Use the project's start command (web: dev server + the URL; cli: the binary). The built-in `/run` skill can
help if present. Wait until ready (poll the URL with `curl`, or watch for the ready log). Record the launch
command in the report.

## 5. Drive it as a user (by backend)

- **CLI / TUI**: run the command with the scenario's inputs, capture stdout/stderr and exit code; for a TUI,
  drive keystrokes and capture the rendered output.
- **Web over HTTP**: `curl` the endpoints the flow touches; assert on status code and response body.
- **Browser** (if MCP available): navigate, click, fill forms, submit, observe; screenshot at the key
  assertion point and read the console for errors.
- **Desktop** (if computer-use available): screenshot, locate, click/type through the scenario, screenshot
  the result.

Never click destructive controls (delete / pay / send) or trigger blocking browser dialogs without explicit
confirmation.

## 6. Judge each scenario on evidence

A scenario PASSES only if the observed result (output / HTTP response / console / screenshot) matches the
expected outcome. Errors, an unexpected response, or a non-zero exit are FAILs. Quote the evidence; never
assert "works" without it. A green test suite does NOT make the run PASS: a passing suite with even one
failed scenario is still a FAIL.

## 7. Report (evidence-based)

```
## Exercise Report
Target: <app> | Backend: <cli|http|browser|desktop>
Tests: <N passed / M failed>
Scenarios: <N run, M passed>

### [PASS|FAIL] Scenario: <name>
- steps: <what was done>
- expected: <observable outcome>
- evidence: <command output | curl response | console excerpt | screenshot path>

### Verdict: PASS | FAIL (<k> scenarios failed)
```

Save any screenshots/evidence under `plans/<...>/evidence/` (or `./exercise-evidence/`). Do NOT commit
evidence that may contain secrets or PII.

## Integration

- `/craft` calls `/exercise` as the behavioral gate alongside `/vet`: vet reviews the code, exercise
  confirms it works for a user. Both should pass before ship.
- Complements, does not replace: `/vet` (static / code review).

## Security

- @invariant: drive only the LOCAL app under test; never run untrusted or remote code (CWE-78).
- @invariant: evidence may capture secrets or PII; flag and never commit such evidence (CWE-200).
- @invariant: never trigger destructive actions or blocking browser dialogs without explicit confirmation.

## Done when

The test suite ran, the scenarios were exercised on an available backend (CLI/HTTP at minimum), and an
Exercise Report was produced with a verdict and at least one piece of evidence per scenario.
