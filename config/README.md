# Configuration

Agent configuration files installed by the `graphify` and `workflow` components.

| File | Installed to | Component | Purpose |
|---|---|---|---|
| `claude/settings.json` | `.claude/settings.json` | `graphify` | graphify `PreToolUse` hooks for Claude Code: before Bash, Grep, Read and Glob they remind the agent to query the graph first |
| `codex/hooks.json` | `.codex/hooks.json` | `graphify` | The same hook for Codex |
| `gitattributes` | `.gitattributes` | `graphify` | Merge driver for `graphify-out/graph.json` |
| `gitignore` | appended to `.gitignore` | `graphify`, `workflow` | graphify cache lines with `graphify`; `.env` and `.DS_Store` with `workflow` |

The hooks require the `graphify` command on the `PATH`. If it is not installed, do not select the `graphify` component, or remove the hooks from these two files.
