# AI Starter Kit: Project Scaffolding for Claude Code and OpenAI Codex

**AI Starter Kit** is an opt-in project scaffold for AI-assisted software development with **Claude Code** and **OpenAI Codex**. A single Bash installer adds the pieces you choose to a new or existing repository: agent skills, an `AGENTS.md` / `CLAUDE.md` rule set, a nine-step task workflow, spec-driven feature and bug-fix skills, knowledge-graph hooks, documentation templates, a **Django + Next.js + Docker** boilerplate, and an RTL design system for admin panels.

Nothing is installed by default. Every component is selected explicitly, previewed with a dry run, and written without overwriting a single existing file.

## Table of contents

- [Why use it](#why-use-it)
- [Features](#features)
- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Interactive setup](#interactive-setup)
- [Command-line reference](#command-line-reference)
- [Agent-driven installation](#agent-driven-installation)
- [What gets installed](#what-gets-installed)
- [Agent task workflow](#agent-task-workflow)
- [Spec-driven development and bug fixing](#spec-driven-development-and-bug-fixing)
- [Agent skills](#agent-skills)
- [Tech stack: Django + Next.js + Docker](#tech-stack-django--nextjs--docker)
- [Design system registry](#design-system-registry)
- [Safety guarantees](#safety-guarantees)
- [Extending the kit](#extending-the-kit)
- [Repository layout](#repository-layout)
- [Language of the installed content](#language-of-the-installed-content)
- [Licensing](#licensing)

## Why use it

Coding agents produce better results when a repository tells them how to work: which rules apply, how a task moves from request to verified change, where the specification lives, and which skills are available. Setting that up by hand for every project is repetitive, and installers that copy everything at once leave a repository full of files nobody asked for.

AI Starter Kit keeps the agent setup in one place and installs it selectively:

- **Opt-in by design.** The installer does nothing until a component is named or confirmed.
- **Safe on existing projects.** Existing files are skipped, never overwritten or merged.
- **Agent-agnostic layout.** Skills are placed where both Claude Code (`.claude/skills/`) and Codex (`.agents/skills/`, `.codex/`) discover them.
- **Process, not only files.** A task workflow, feature specifications and a bug-fix procedure give the agent a repeatable path from request to verified result.

## Features

| Component | Selector | Summary |
|---|---|---|
| General agent skills | `--with skills` or `--skills <ids>` | 15 Agent Skills for UI design, web app testing, MCP servers, the Claude API, documentation and more |
| Knowledge-graph tooling | `--with graphify` | The graphify skill for Claude Code and Codex, `PreToolUse` hooks, and a merge driver entry for the graph file |
| Task workflow | `--with workflow` | `AGENTS.md`, `CLAUDE.md` and a nine-step task workflow |
| Documentation templates | `--with docs` | Product plan, requirements and architecture, security release checklist, project README |
| Spec-driven skills | `--with spec` | `feature-spec`, `feature-plan` and `bug-fix` |
| Tech stack boilerplate | `--stack <id>` | Django 5 + Django Ninja + Celery, Next.js 16 + React 19, PostgreSQL, Redis, MinIO, Docker Compose |
| Design system | `--design-system <id>` | Dig: an RTL, Persian-first component system on React and Tailwind CSS 4 |

## Requirements

- macOS or Linux with Bash 3.2 or later.
- Git.
- [graphify](skills/claude/graphify/SKILL.md) on the `PATH`, only if you install the `graphify` component; its hooks call the `graphify` command.
- Docker and Node.js 20, only if you install a stack or a design system.

## Quick start

```bash
git clone https://github.com/amir-79bg/AI-starter-kit.git
cd AI-starter-kit

bin/new-project.sh ../my-app            # interactive setup: asks what to install
```

Non-interactive equivalents:

```bash
bin/new-project.sh --list                                         # every selectable component
bin/new-project.sh ../my-app --with graphify,workflow --dry-run   # preview, write nothing
bin/new-project.sh ../my-app --with graphify,workflow,spec --skills webapp-testing,frontend-design
bin/new-project.sh ../my-app --with all --stack django-next-docker
```

The target directory may be empty, missing, or an existing project.

## Interactive setup

Running the installer in a terminal with only a target directory starts a five-step setup. Each answer defaults to "no", and nothing is written before the final confirmation.

| Step | Question |
|---|---|
| 1. Agent layer | Yes/no for each of `graphify`, `workflow`, `docs`, `spec` |
| 2. General skills | A numbered list with descriptions; enter numbers, `all`, or nothing |
| 3. Stack | Pick a boilerplate by number, or `0` for none |
| 4. Design system | Pick a design system by number, or `0` for none |
| 5. Review | Shows the equivalent command and the dry-run file list, then asks for confirmation |

Use `--interactive` to force the setup when standard input is not a terminal.

## Command-line reference

```text
bin/new-project.sh <target-dir>
bin/new-project.sh <target-dir> [--with <parts>] [--skills <ids>] [--stack <id>]
                   [--design-system <id>] [--name <slug>] [--dry-run]
bin/new-project.sh --list
```

| Option | Effect |
|---|---|
| `--with <parts>` | Comma-separated components: `skills`, `graphify`, `workflow`, `docs`, `spec`, or `all` |
| `--skills <ids>` | Install only the named general skills instead of all of them |
| `--stack <id>` | Install a boilerplate from [`stacks/`](stacks/) |
| `--design-system <id>` | Install a design system from [`design-systems/`](design-systems/) |
| `--name <slug>` | Project name substituted for `__PROJECT__`; defaults to the target directory name |
| `--dry-run` | Print every file that would be created; write nothing |
| `--interactive` | Force the step-by-step setup |
| `--list` | List components, skills, stacks and design systems |

`--with all` selects the five agent-layer components. It never includes a stack or a design system; those are installed only when named.

Without any selection and without a terminal, the installer prints the available options, exits with status `2`, and leaves the target untouched.

## Agent-driven installation

This section is for Claude Code, Codex and any other agent asked to install the kit into a project. An agent has no interactive terminal, so it asks the user the same questions itself, one step at a time, using the options from `bin/new-project.sh --list`. Use a multiple-choice question tool if one is available.

1. **Agent layer:** which of `graphify`, `workflow`, `docs` and `spec`? State in one line what each adds to the project.
2. **General skills:** none, all, or a specific set? Show the list with the purpose of each skill.
3. **Stack:** wanted or not. Do not suggest it for a project that already contains code.
4. **Design system:** wanted or not. Do not install it into a project that already has its own UI or design system.
5. **Review and confirm:** run the command with `--dry-run`, show the output, and run it without `--dry-run` only after the user confirms.

Do not choose on the user's behalf, and do not pass `--with all` unless the user asked for everything. After installing, do not modify the project's existing files on account of the kit; if something has to be added by hand, tell the user.

## What gets installed

Paths are relative to the target directory. The label before each description is the component that creates it.

```
my-app/
├── AGENTS.md              workflow: task rules, plus the rules of the selected stack and design system
├── CLAUDE.md              workflow: a one-line import of AGENTS.md
├── .agents/skills/        skills, spec: general skills and the spec-driven skills
├── .claude/
│   ├── settings.json      graphify: PreToolUse hooks for Claude Code
│   └── skills/            graphify, spec: skills discovered by Claude Code
├── .codex/
│   ├── hooks.json         graphify: PreToolUse hook for Codex
│   └── skills/            graphify: the Codex build of the graphify skill
├── .gitattributes         graphify: merge driver for graphify-out/graph.json
├── .gitignore             workflow, graphify: missing lines are appended
├── README.md              docs: project README template
├── docs/
│   ├── TASK_WORKFLOW.md                 workflow
│   ├── PRODUCT_PLAN.md                  docs
│   ├── REQUIREMENTS_ARCHITECTURE.md     docs
│   └── SECURITY_RELEASE_CHECKLIST.md    docs
└── ...                    files of the selected stack and design system
```

## Agent task workflow

The `workflow` component installs [`docs/TASK_WORKFLOW.md`](workflow/TASK_WORKFLOW.md) and an `AGENTS.md` that points to it. Every task, from a small fix to a full feature, follows the same order; a step that does not apply is skipped, not replaced.

1. Understand the request and check the product plan.
2. Orient in the code with the knowledge graph before using grep.
3. Implement with the project's design-system components and existing patterns.
4. Test, and verify UI changes in a real browser.
5. Provide seed data for every state: empty, one item, many items, each status, each role.
6. Update the security release checklist.
7. Apply the change to the running application.
8. Update the knowledge graph.
9. Report what changed, what was tested, and what was not.

## Spec-driven development and bug fixing

The `spec` component adds three small skills for work that is too large or too risky to start with code. They are intended for features that span more than one screen, data model or role, and for bugs; small changes go straight through the task workflow.

| Skill | Purpose | Output |
|---|---|---|
| [`feature-spec`](skills/spec/feature-spec/SKILL.md) | Captures what is being built and why, then asks the user at most five clarifying questions and records the answers | `docs/specs/<slug>/spec.md` |
| [`feature-plan`](skills/spec/feature-plan/SKILL.md) | Produces the technical plan and an ordered task list tied to requirement IDs, then checks the finished code against the specification | `docs/specs/<slug>/plan.md` |
| [`bug-fix`](skills/spec/bug-fix/SKILL.md) | Separates diagnosis, the smallest fix for the diagnosed cause, and re-verification of the original symptom, ending in a verdict: verified, partial or failed | A report in the conversation |

Each feature produces two files. Tasks and the conformance table live inside `plan.md`, and a bug produces a file only on request or when it involves data, access control or money.

The approach is inspired by [GitHub Spec Kit](https://github.com/github/spec-kit); the skills were written for this kit and contain no text or files from it.

## Agent skills

Fifteen general-purpose Agent Skills are available individually through `--skills` or together through `--with skills`. The full table is in [`skills/README.md`](skills/README.md).

| Area | Skills |
|---|---|
| Frontend and testing | `frontend-design`, `webapp-testing`, `web-artifacts-builder`, `theme-factory` |
| Visual output | `canvas-design`, `algorithmic-art`, `brand-guidelines`, `slack-gif-creator` |
| Writing | `doc-coauthoring`, `internal-comms` |
| Building with Claude | `claude-api`, `mcp-builder`, `skill-creator` |
| Assistant behaviour | `academy-guide`, `discernment-nudge` |

## Tech stack: Django + Next.js + Docker

Stacks are listed in [`stacks/`](stacks/).

| ID | Backend | Frontend | Infrastructure |
|---|---|---|---|
| [`django-next-docker`](stacks/django-next-docker/) | Django 5, Django Ninja, Celery | Next.js 16, React 19, TypeScript, Tailwind CSS 4 | PostgreSQL, Redis, MinIO, Docker Compose |

The stack is a skeleton only: Dockerfiles, Django settings, a `/health` endpoint and an empty Next.js page. It contains no user model, authentication or business logic.

## Design system registry

Design systems are optional and are installed only with `--design-system <id>`. The registry in [`design-systems/`](design-systems/) grows as new systems are used in projects.

| ID | Name | Suited to |
|---|---|---|
| [`dig`](design-systems/dig/) | Dig | Panel development: Persian, right-to-left (RTL) admin panels, dashboards and user panels on React and Tailwind CSS 4 |

Dig targets data-heavy, form-driven screens: forms, tables, sidebars, dialogs and Persian fields such as Jalali dates. It is not the first choice for landing or marketing pages.

## Safety guarantees

- **No defaults.** With nothing selected, nothing is written and the target directory is not created.
- **No overwrites.** A file that already exists is reported as `skip (exists)` and left as it is.
- **No silent merges.** If `AGENTS.md` already exists, stack and design-system rules are not appended; the installer prints their path so they can be added by hand, and `CLAUDE.md` is not created next to it.
- **Preview first.** `--dry-run` lists every file and `.gitignore` line before any write.
- **Scoped substitution.** The project name replaces `__PROJECT__` only in files created during the current run.
- **Idempotent.** Re-running the same command changes nothing.

## Extending the kit

| To add | Location | Guide |
|---|---|---|
| A design system | `design-systems/<id>/` | [design-systems/README.md](design-systems/README.md) |
| A tech stack | `stacks/<id>/` | [stacks/README.md](stacks/README.md) |
| A general skill | `skills/agents/<name>/` | [skills/README.md](skills/README.md) |
| A workflow rule | `workflow/TASK_WORKFLOW.md` | — |
| A documentation template | `docs-templates/` plus one `copy_file` line in the installer | — |

After changing `bin/new-project.sh`, `stacks/` or `design-systems/`, run the installer against a temporary directory and inspect the output.

## Repository layout

| Path | Contents |
|---|---|
| [`bin/new-project.sh`](bin/new-project.sh) | The installer |
| [`skills/`](skills/) | General skills (`agents/`), spec-driven skills (`spec/`), and the graphify skill for Claude Code (`claude/`) and Codex (`codex/`) |
| [`workflow/`](workflow/) | Task workflow and the `AGENTS.md` template |
| [`config/`](config/) | Claude Code settings, Codex hooks, `.gitattributes` and `.gitignore` lines |
| [`docs-templates/`](docs-templates/) | Product plan, requirements and architecture, security checklist, README |
| [`stacks/`](stacks/) | Tech stack boilerplates |
| [`design-systems/`](design-systems/) | Design system registry |

## Language of the installed content

This documentation and the installer output are in English. The content written into your project by the `workflow`, `docs` and `spec` components (the task workflow, the `AGENTS.md` template, the documentation templates and the three spec-driven skills) is currently written in Persian, as are the stack and design-system agent rules. The 15 general skills and the graphify skill are in English.

## Licensing

The bundled general skills are published under Apache 2.0, each with its own `LICENSE.txt`; `doc-coauthoring` ships without a licence file. Skills whose licence does not permit redistribution (`docx`, `pdf`, `pptx`, `xlsx`) are deliberately not included. Details are in [skills/README.md](skills/README.md).
