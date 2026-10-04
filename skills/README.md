# Agent Skills

Agent Skills bundled with AI Starter Kit for Claude Code and OpenAI Codex.

| Source folder | Installed to | Contents | Selector |
|---|---|---|---|
| `agents/` | `.agents/skills/` | General-purpose skills | `--with skills` or `--skills <ids>` |
| `spec/` | `.agents/skills/` and `.claude/skills/` | Feature specification, planning and bug-fix skills | `--with spec` |
| `claude/` | `.claude/skills/` | The Claude Code build of graphify | `--with graphify` |
| `codex/` | `.codex/skills/` | The Codex build of graphify | `--with graphify` |

graphify generates a separate build of its skill for each tool and the two differ in content, so both are kept (version 0.9.72).

## General skills

| Skill | Purpose |
|---|---|
| `frontend-design` | Visual direction, typography and layout when building UI |
| `webapp-testing` | Testing and debugging local web apps with Playwright |
| `web-artifacts-builder` | Multi-component HTML artifacts with React and Tailwind |
| `theme-factory` | Ready-made themes for slides, documents and HTML pages |
| `canvas-design` | Posters and visual designs as PNG and PDF |
| `algorithmic-art` | Generative art with p5.js |
| `brand-guidelines` | Anthropic brand colours and typography |
| `slack-gif-creator` | Animated GIFs for Slack |
| `doc-coauthoring` | A workflow for writing documentation, proposals and technical specs |
| `internal-comms` | Internal company communications |
| `claude-api` | Reference for the Claude API and SDKs |
| `mcp-builder` | Building MCP servers |
| `skill-creator` | Creating, improving and evaluating skills |
| `academy-guide` | Course and training suggestions from Claude Academy |
| `discernment-nudge` | A review reminder after an answer the user may act on |

## Spec-driven skills

| Skill | Purpose |
|---|---|
| `feature-spec` | Writes a feature specification and resolves open questions before any code |
| `feature-plan` | Writes the technical plan and ordered tasks, then checks the code against the specification |
| `bug-fix` | Fixes a bug in three steps: diagnose, fix, verify |

These three were written for this kit. The approach is inspired by [GitHub Spec Kit](https://github.com/github/spec-kit); no text or files were copied from it. Their content is written in Persian.

## Licensing

Skills that include a `LICENSE.txt` are published under Apache 2.0. `doc-coauthoring` has no licence file.

The `docx`, `pdf`, `pptx` and `xlsx` skills are not in this repository because their licence does not permit redistribution; they are available from within Claude itself. Read the licence of any skill before adding it.

## Adding a skill

Put the skill folder (with its `SKILL.md`) in `agents/` and add a row to the table above. To write a skill from scratch, use `skill-creator`.
