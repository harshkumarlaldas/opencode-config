# opencode-config

Shared [opencode](https://opencode.ai) configuration for this team — clone
this on every laptop so agents, permissions, commands and MCP servers behave
identically no matter who's running opencode or from which machine.

## Quick start

```sh
git clone https://github.com/harshkumarlaldas/opencode-config.git
cd opencode-config

# macOS / Linux
./scripts/install.sh

# Windows (PowerShell)
.\scripts\install.ps1
```

The script installs the `opencode` CLI if it's missing, links `opencode.json`
and `AGENTS.md` into opencode's global config directory (`~/.config/opencode`,
or `%USERPROFILE%\.config\opencode` on Windows), and clones/updates
[GeniusOrchestrator](https://github.com/harshkumarlaldas/GeniusOrchestrator)
alongside this repo, copying its `skills/` into the global opencode skills
directory — the same personal skill library available in Claude Code via the
`genius-orchestrator` plugin. Re-run the script any time GeniusOrchestrator
changes to refresh the copy.

Finally, connect a model provider:

```sh
opencode auth login
```

We default to **OpenCode Zen** (`opencode/...` model IDs) so nobody needs to
manage their own API keys — sign in at opencode.ai when prompted. If you'd
rather bring your own Anthropic/OpenAI keys, run `opencode auth login` and
pick that provider instead, then override `model` in a local
`.opencode/opencode.json` (project- or user-level config always wins over
this global one — see [precedence](https://opencode.ai/docs/config/)).

## What's in here

| File | Purpose |
|---|---|
| `opencode.json` | Main config: default models, permissions, agents, commands, MCP servers, formatter |
| `AGENTS.md` | Team-wide instructions loaded into every session (house rules, testing policy) |
| `prompt/*.md` | System prompts for the custom agents defined in `opencode.json` |
| `scripts/install.sh` / `install.ps1` | One-shot bootstrap for a new machine (also syncs GeniusOrchestrator skills) |

### Agents

- **plan** (built-in, overridden) — read-only, for scoping work before writing code
- **build** (built-in, overridden) — the default agent that writes code and runs tests
- **review** (subagent) — reviews a diff/PR without editing anything
- **docs** (subagent) — writes and updates documentation

### Commands

Run these inside opencode with `/test`, `/commit`, `/pr-review`, `/docs-update`.

### Permissions

Edits are auto-allowed; most bash is `ask` except a short allow-list of safe
read-only/git/test commands, and `rm -rf`/`sudo` are always denied. Adjust
the `permission` block in `opencode.json` as the team's comfort level
changes.

### MCP servers

[Context7](https://context7.com) is wired up by default for up-to-date
library docs. Add more servers under `mcp` in `opencode.json` — see the
[MCP docs](https://opencode.ai/docs/mcp-servers/).

## Making changes

This config is shared, so treat changes like code: open a PR, and once
merged, everyone re-runs the install script (or just re-pulls, since global
config is symlinked — copies on Windows need a re-run if the symlink
fallback kicked in) to pick up the update.
