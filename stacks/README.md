# Tech Stacks

A stack is an optional technical skeleton (boilerplate). Whenever a new stack is used in a project, it gets a row in this table and a folder next to the others.

| ID | Backend | Frontend | Infrastructure | Status |
|---|---|---|---|---|
| [`django-next-docker`](django-next-docker/) | Django 5 + Django Ninja + Celery | Next.js 16 + React 19 + Tailwind CSS 4 | PostgreSQL, Redis, MinIO, Docker Compose | In use; extracted from the Academy project |

## Selecting one

```bash
bin/new-project.sh ../my-app --stack django-next-docker
```

Without `--stack` no skeleton is installed. The agent-layer components (skills, graphify, workflow, docs, spec) are selected separately with `--with`.

## Adding a stack

1. Copy the `_template` folder under a new ID: `cp -R stacks/_template stacks/<id>`
2. Put the skeleton files in `files/`; this folder is copied verbatim into the project root. Write `__PROJECT__` wherever the project name is needed. Name the `.gitignore` file `gitignore`.
3. Declare the frontend directory in `stack.env` (`FRONTEND_DIR=frontend`); the design system is installed there.
4. Write the run, test and deploy-to-running-app commands in `AGENT_RULES.md`. This file is appended to the project's `AGENTS.md`.
5. Fill in `README.md` (the first heading is shown by `--list`) and add a row to the table above and to the table in the root `README.md`.
