## استک: Django + Next.js + Docker

- بک‌اند در `backend/` (Django + Django Ninja، مسیرها زیر `/api/v1`)، فرانت‌اند در `frontend/` (Next.js، App Router).
- اجرا: `make up` · لاگ: `make logs` · migration: `make migrate`
- تست: `make test` (تست‌های Django و `tsc --noEmit`) · تست مرورگر: `cd frontend && npm run test:e2e`
- قبل از نوشتن کد Next.js، راهنمای همان نسخه را در `frontend/node_modules/next/dist/docs/` بخوان؛ این نسخه با نسخه‌های قدیمی‌تر فرق دارد.
- اعمال تغییر روی برنامهٔ در حال اجرا:
  - فرانت‌اند Docker (پورت 3001) از image ساخته‌شده اجرا می‌شود و تغییر کد را نمی‌بیند: `docker compose build frontend && docker compose up -d --no-deps frontend`
  - بک‌اند پوشهٔ `./backend` را mount کرده و خودش reload می‌شود؛ migration تازه: `docker compose exec backend python manage.py migrate`
  - `npm run dev` روی پورت 3000 خودش hot-reload دارد.
