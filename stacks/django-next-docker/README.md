# Django + Next.js + Docker

## چه چیزی دارد

| سرویس | چیست | پورت |
|---|---|---|
| `backend` | Django 5.1 + Django Ninja، با یک مسیر `/api/v1/health` | 8000 |
| `worker` | Celery روی Redis | — |
| `frontend` | Next.js 16 + React 19 + TypeScript + Tailwind 4، راست‌به‌چپ | 3001 |
| `db` | PostgreSQL 16 | داخلی |
| `redis` | Redis 7 | داخلی |
| `minio` | ذخیره‌سازی سازگار با S3 | 9000، کنسول 9001 |

## بعد از ساخت پروژه

```bash
cp .env.example .env
(cd frontend && npm install)     # package-lock.json را می‌سازد؛ Dockerfile با npm ci به آن نیاز دارد
docker compose up --build
docker compose exec backend python manage.py createsuperuser
```

- فرانت‌اند: http://localhost:3001
- مستندات API: http://localhost:8000/api/v1/docs
- ادمین Django: http://localhost:8000/admin

بک‌اند بدون Docker: `cd backend && USE_SQLITE=true python manage.py runserver`

## چه چیزی ندارد

- اپ‌های Django، مدل کاربر و احراز هویت. اگر مدل کاربر اختصاصی می‌خواهی، قبل از اولین migration بسازش و `AUTH_USER_MODEL` را تنظیم کن.
- تنظیمات production: `entrypoint.sh` با `runserver` بالا می‌آید. Gunicorn در `requirements.txt` هست ولی سیم‌کشی نشده است.
- مرورگر Playwright: Dockerfile دانلود مرورگر را رد می‌کند. برای تست e2e یا `npx playwright install chromium` بزن یا در `playwright.config.ts` مسیر Chrome نصب‌شده را بده.
- دیزاین سیستم. از `design-systems/` انتخاب می‌شود.

## وضعیت تست این اسکلت

`python manage.py check` روی بک‌اند اجرا شده و بدون خطاست. build فرانت‌اند و `docker compose up` روی خود اسکلت اجرا نشده‌اند؛ فایل‌های آن‌ها از پروژهٔ آکادمی آمده که با همین‌ها کار می‌کند.

## منبع

پروژهٔ Manement Academy.
