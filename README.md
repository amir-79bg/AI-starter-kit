# AI Starter Kit: قالب شروع پروژه با Claude Code و Codex

**AI Starter Kit** is a project template for AI-assisted development with **Claude Code** and **OpenAI Codex**. It bundles agent skills, an `AGENTS.md` / `CLAUDE.md` template, a step-by-step task workflow, hooks, documentation templates, a design-system registry (RTL / Persian admin panels) and an optional **Django + Next.js + Docker** boilerplate. One script scaffolds a new project from all of it.

استارتر کیت هوش مصنوعی یک قالب آماده برای شروع پروژه با ایجنت‌های کدنویسی است. به‌جای اینکه در هر پروژه اسکیل‌ها، قانون‌های ایجنت، داکیومنت‌ها و دیزاین سیستم را از صفر بچینی، یک فرمان همه را در پروژهٔ تازه می‌گذارد.

## فهرست

- [چه چیزی در این قالب هست](#چه-چیزی-در-این-قالب-هست)
- [شروع سریع](#شروع-سریع)
- [روند انجام تسک برای ایجنت](#روند-انجام-تسک-برای-ایجنت)
- [دیزاین سیستم برای توسعهٔ پنل](#دیزاین-سیستم-برای-توسعهٔ-پنل)
- [استک فنی: Django + Next.js + Docker](#استک-فنی-django--nextjs--docker)
- [اضافه کردن اسکیل، دیزاین سیستم یا استک تازه](#اضافه-کردن-اسکیل-دیزاین-سیستم-یا-استک-تازه)
- [پیش‌نیاز](#پیش‌نیاز)

## چه چیزی در این قالب هست

| پوشه | چیست |
|---|---|
| [`skills/`](skills/) | ۱۹ اسکیل ایجنت (Agent Skills) برای طراحی رابط، تست اپ وب، ساخت فایل Word، PDF، Excel و PowerPoint، ساخت سرور MCP و کار با Claude API، به‌علاوهٔ اسکیل graphify برای گراف دانش کد |
| [`workflow/`](workflow/) | روند انجام تسک در ۹ مرحله و قالب `AGENTS.md` |
| [`config/`](config/) | تنظیمات و هوک‌های Claude Code (`.claude/settings.json`) و Codex (`.codex/hooks.json`) |
| [`docs-templates/`](docs-templates/) | قالب پلن محصول، سند نیازمندی‌ها و معماری، چک‌لیست امنیت قبل از انتشار و README |
| [`design-systems/`](design-systems/) | فهرست دیزاین سیستم‌ها؛ برای هر پروژه یکی انتخاب می‌شود |
| [`stacks/`](stacks/) | فهرست استک‌های فنی (boilerplate)؛ اختیاری |
| [`bin/new-project.sh`](bin/new-project.sh) | اسکریپت ساخت پروژهٔ تازه |

## شروع سریع

```bash
git clone https://github.com/amir-79bg/AI-starter-kit.git
cd AI-starter-kit

bin/new-project.sh --list                                    # استک‌ها و دیزاین سیستم‌های موجود
bin/new-project.sh ../my-app                                 # فقط لایهٔ ایجنت
bin/new-project.sh ../my-app --stack django-next-docker --design-system dig
```

اسکریپت روی پروژهٔ موجود هم اجرا می‌شود و هیچ فایلی را بازنویسی نمی‌کند.

ساختاری که در پروژه ساخته می‌شود:

```
my-app/
├── AGENTS.md              روند کار + قانون‌های استک و دیزاین سیستم انتخاب‌شده
├── CLAUDE.md              به AGENTS.md اشاره می‌کند
├── .agents/skills/        اسکیل‌های عمومی
├── .claude/               اسکیل graphify و هوک‌های Claude Code
├── .codex/                اسکیل graphify و هوک‌های Codex
├── docs/                  روند تسک، پلن محصول، نیازمندی‌ها و معماری، چک‌لیست امنیت
└── ...                    فایل‌های استک و دیزاین سیستم، اگر انتخاب شده باشند
```

مرحله‌های بعدیِ مخصوص هر استک و دیزاین سیستم در `README.md` همان پوشه نوشته شده است.

## روند انجام تسک برای ایجنت

ایجنت هر تسک را با همین ترتیب جلو می‌برد. متن کامل در [`workflow/TASK_WORKFLOW.md`](workflow/TASK_WORKFLOW.md) است.

1. فهمیدن خواسته و نگاه به پلن محصول
2. جهت‌یابی در کد با گراف دانش (graphify) قبل از grep
3. پیاده‌سازی با کامپوننت‌های دیزاین سیستم
4. تست، و دیدن تغییر در مرورگر
5. دادهٔ نمونه برای همهٔ حالت‌ها: خالی، یک مورد، تعداد زیاد، هر وضعیت، هر نقش
6. به‌روز کردن چک‌لیست امنیت
7. اعمال تغییر روی برنامهٔ در حال اجرا
8. به‌روز کردن گراف
9. گزارش: چه چیزی عوض شد، چه چیزی تست شد، چه چیزی نشد

## دیزاین سیستم برای توسعهٔ پنل

فهرست کامل در [`design-systems/`](design-systems/) است و با هر پروژه بزرگ‌تر می‌شود.

| شناسه | نام | مناسب برای |
|---|---|---|
| [`dig`](design-systems/dig/) | دیگ (Dig) | توسعهٔ پنل: پنل مدیریت، داشبورد و پنل کاربری فارسی و راست‌به‌چپ (RTL) با React و Tailwind CSS 4 |

دیگ بیشتر مناسب پنل است: فرم، جدول، سایدبار، دیالوگ و فیلدهای فارسی مثل تاریخ شمسی. برای لندینگ و صفحهٔ بازاریابی انتخاب اول نیست.

## استک فنی: Django + Next.js + Docker

فهرست کامل در [`stacks/`](stacks/) است.

| شناسه | بک‌اند | فرانت‌اند | زیرساخت |
|---|---|---|---|
| [`django-next-docker`](stacks/django-next-docker/) | Django 5، Django Ninja، Celery | Next.js 16، React 19، TypeScript، Tailwind CSS 4 | PostgreSQL، Redis، MinIO، Docker Compose |

این استک فقط اسکلت است: Dockerfileها، تنظیمات Django، یک مسیر `/health` و یک صفحهٔ خالی Next.js. مدل کاربر، ورود و منطق کسب‌وکار ندارد.

## اضافه کردن اسکیل، دیزاین سیستم یا استک تازه

| چه چیزی | کجا | راهنما |
|---|---|---|
| دیزاین سیستم | `design-systems/<id>/` | [design-systems/README.md](design-systems/README.md) |
| استک فنی | `stacks/<id>/` | [stacks/README.md](stacks/README.md) |
| اسکیل | `skills/agents/<name>/` | [skills/README.md](skills/README.md) |
| قانون تازه در روند کار | `workflow/TASK_WORKFLOW.md` | — |
| قالب داکیومنت | `docs-templates/` و یک خط `copy_file` در اسکریپت | — |

## پیش‌نیاز

- [graphify](skills/claude/graphify/SKILL.md) روی سیستم نصب باشد؛ هوک‌ها و روند کار به آن تکیه دارند.
- برای استک و دیزاین سیستم: Docker و Node 20.
- macOS یا Linux با bash.

## مجوز اسکیل‌ها

هر اسکیل مجوز خودش را در `LICENSE.txt` همان پوشه دارد.
