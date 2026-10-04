# Dig

## What it is

A Persian, right-to-left design system built on React and Tailwind CSS 4. Components are copied by a CLI from the registry at `https://docs.digdesign.ir` into the project itself (under `components/ui`) and belong to the project from then on. The Dig theme and the project brand are kept in two separate files so that a theme update does not overwrite the project's colours.

## What it is suited to

Dig is mainly for panel development: admin panels, dashboards and user panels with forms, tables, sidebars, dialogs and Persian fields (Jalali dates, numbers and time). In the Academy project all three panels (manager, teacher and student) were built with it.

It is not the first choice for landing and marketing pages; its components are designed for data-heavy, form-driven screens, not promotional ones.

## Installation

`bin/new-project.sh` places `dig.json` in the frontend directory. Then, in that directory:

```bash
npx digdesign init                       # theme, tokens and dir="rtl"
npx digdesign theme brand "#2864DC"      # brand ramp from a single colour
npx digdesign add button input dialog    # the components you need
npx digdesign list                       # every registry item
```

The CLI version used in the Academy project is `digdesign@0.5.0`. See `npx digdesign <command> --help` for the options of each command.

## Files in the project

| File | Owner |
|---|---|
| `dig.json` | Dig configuration: paths, RTL, registry URL |
| `app/dig-theme.css` | The Dig theme; not edited by hand, updated with `dig update theme` |
| `app/brand.css` | The project brand; Dig never overwrites it |
| `components/ui/*` | Installed components |
| `.dig/registry-lock.json` | Version and hash of each installed component |

## Components installed in the Academy project

alert, alert-dialog, autocomplete, avatar, badge, breadcrumb, button, calendar, card, checkbox, date-picker, dialog, drawer, dropdown-menu, empty-state, fieldset, form, input, label, number-field, popover, progress, radio-group, scroll-area, select, separator, sheet, sidebar, skeleton, spinner, stat-tile, switch, table, tabs, text-field, textarea, time-field, toast, toggle, toggle-group, tooltip, typography, wheel-picker, icons, persian

## Brand and theme

- Brand colour: `npx digdesign theme brand "#RRGGBB"` generates the `--brand-50` to `--brand-950` ramp in `app/brand.css`; step 600 is `--primary`.
- Font: the `--font-anchor` variable in `app/brand.css`. The Academy project used IRANYekan, which is commercially licensed and therefore not in this repository; place the font files in `public/fonts` yourself and declare `@font-face` in `app/globals.css`.

## Maintenance

```bash
npx digdesign diff <component>     # compare with the registry, no changes
npx digdesign update <component>   # only untouched files are rewritten
npx digdesign doctor               # health of the design system in the project
```

## Source

The Manement Academy project, `frontend` directory. Documentation: https://docs.digdesign.ir
