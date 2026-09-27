# Team standards for opencode

These instructions are loaded into every opencode session (see `instructions`
in `opencode.json`) so every machine and every developer behaves the same
way, regardless of which agent or model is active.

## General

- Prefer small, focused diffs over large rewrites.
- Match the existing code style in a file rather than imposing a new one.
- Don't add dependencies without calling it out first.
- Don't commit or push unless explicitly asked to.
- When a task is genuinely ambiguous, ask one short clarifying question
  rather than guessing silently.

## Testing

- If a change touches logic, run the relevant tests (or add one) before
  calling the task done.
- Don't mark something as fixed if tests are failing or you couldn't verify
  the fix.

## Project-specific notes

Add per-project conventions here as the team settles on them (e.g. package
manager, test runner, deploy process, branch naming). Keep this file the
single source of truth — don't duplicate the same rule in an agent prompt.
