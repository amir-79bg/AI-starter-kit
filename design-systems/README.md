# Design System Registry

A design system is optional and is installed only when the user asks for it. Whenever a new design system is used in a project, it gets a row in this table and a folder next to the others.

| ID | Name | Suited to | Compatible stacks | Status |
|---|---|---|---|---|
| [`dig`](dig/) | Dig | Panel development: Persian, right-to-left admin panels, dashboards and user panels | Any stack with React and Tailwind CSS 4 | In use; extracted from the Academy project |

## Selecting one

```bash
bin/new-project.sh ../my-app --design-system dig
```

Without `--design-system` none is installed, not even with `--with all`. An agent asks the user before installing and does not install a design system into a project that already has its own UI or design system.

Files are copied into the frontend directory declared by the selected stack (`FRONTEND_DIR` in `stack.env`), or into the project root when no stack is selected.

## Adding a design system

1. Copy the `_template` folder under a new ID: `cp -R design-systems/_template design-systems/<id>`
2. Fill in its `README.md`: what it is, how it is installed, which components it provides. The first heading is shown by `--list`.
3. Write the rules an agent must follow when building UI in `AGENT_RULES.md`. This file is appended to the project's `AGENTS.md`.
4. Put the files that must be copied verbatim into the frontend directory in `files/`.
5. Add a row to the table above and to the table in the root `README.md`.
