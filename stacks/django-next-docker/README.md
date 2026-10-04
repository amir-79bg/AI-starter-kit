# Django + Next.js + Docker

## What it contains

| Service | Description | Port |
|---|---|---|
| `backend` | Django 5.1 + Django Ninja, with a single `/api/v1/health` route | 8000 |
| `worker` | Celery on Redis | — |
| `frontend` | Next.js 16 + React 19 + TypeScript + Tailwind CSS 4, right-to-left | 3001 |
| `db` | PostgreSQL 16 | internal |
| `redis` | Redis 7 | internal |
| `minio` | S3-compatible object storage | 9000, console 9001 |

## After creating the project

```bash
cp .env.example .env
(cd frontend && npm install)     # creates package-lock.json; the Dockerfile needs it for npm ci
docker compose up --build
docker compose exec backend python manage.py createsuperuser
```

- Frontend: http://localhost:3001
- API documentation: http://localhost:8000/api/v1/docs
- Django admin: http://localhost:8000/admin

Backend without Docker: `cd backend && USE_SQLITE=true python manage.py runserver`

## What it does not contain

- Django apps, a user model and authentication. If you need a custom user model, create it before the first migration and set `AUTH_USER_MODEL`.
- Production settings: `entrypoint.sh` starts `runserver`. Gunicorn is in `requirements.txt` but is not wired up.
- A Playwright browser: the Dockerfile skips the browser download. For end-to-end tests either run `npx playwright install chromium` or point `playwright.config.ts` at an installed Chrome.
- A design system. It is selected from `design-systems/`.

## Test status of this skeleton

`python manage.py check` has been run on the backend and passes. The frontend build and `docker compose up` have not been run on the skeleton itself; their files come from the Academy project, which runs on them.

## Source

The Manement Academy project.
