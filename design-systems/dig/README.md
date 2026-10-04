# دیگ (Dig)

## چیست

دیزاین سیستم فارسی و راست‌به‌چپ بر پایهٔ React و Tailwind 4. کامپوننت‌ها با CLI از رجیستری `https://docs.digdesign.ir` داخل خود پروژه کپی می‌شوند (در `components/ui`) و بعد از آن مال پروژه‌اند. تم دیگ و برند پروژه در دو فایل جدا نگه داشته می‌شوند تا به‌روزرسانی تم، رنگ‌های پروژه را خراب نکند.

## مناسب چه کاری است

دیگ بیشتر به درد توسعهٔ پنل می‌خورد: پنل مدیریت، داشبورد، و پنل کاربری با فرم، جدول، سایدبار، دیالوگ و فیلدهای فارسی (تاریخ شمسی، عدد و زمان). در پروژهٔ آکادمی هر سه پنل مدیر، مدرس و هنرجو با آن ساخته شد.

برای لندینگ و صفحهٔ بازاریابی انتخاب اول نیست؛ کامپوننت‌هایش برای صفحه‌های پرداده و فرم‌محور طراحی شده‌اند، نه صفحه‌های تبلیغاتی.

## نصب

`bin/new-project.sh` فایل `dig.json` را در پوشهٔ فرانت‌اند می‌گذارد. بعد در همان پوشه:

```bash
npx digdesign init                       # تم، توکن‌ها و dir="rtl"
npx digdesign theme brand "#2864DC"      # رمپ برند از یک رنگ
npx digdesign add button input dialog    # کامپوننت‌های لازم
npx digdesign list                       # همهٔ آیتم‌های رجیستری
```

نسخهٔ CLI که در پروژهٔ آکادمی استفاده شد `digdesign@0.5.0` است. گزینه‌های هر فرمان را با `npx digdesign <command> --help` ببین.

## فایل‌ها در پروژه

| فایل | مال کیست |
|---|---|
| `dig.json` | تنظیمات دیگ: مسیرها، RTL، آدرس رجیستری |
| `app/dig-theme.css` | تم دیگ؛ دست نمی‌خورد و با `dig update theme` به‌روز می‌شود |
| `app/brand.css` | برند پروژه؛ دیگ هیچ‌وقت بازنویسی‌اش نمی‌کند |
| `components/ui/*` | کامپوننت‌های نصب‌شده |
| `.dig/registry-lock.json` | نسخه و هش هر کامپوننت نصب‌شده |

## کامپوننت‌هایی که در پروژهٔ آکادمی نصب شد

alert، alert-dialog، autocomplete، avatar، badge، breadcrumb، button، calendar، card، checkbox، date-picker، dialog، drawer، dropdown-menu، empty-state، fieldset، form، input، label، number-field، popover، progress، radio-group، scroll-area، select، separator، sheet، sidebar، skeleton، spinner، stat-tile، switch، table، tabs، text-field، textarea، time-field، toast، toggle، toggle-group، tooltip، typography، wheel-picker، icons، persian

## برند و تم

- رنگ برند: `npx digdesign theme brand "#RRGGBB"` رمپ `--brand-50` تا `--brand-950` را در `app/brand.css` می‌سازد؛ پلهٔ ۶۰۰ همان `--primary` است.
- فونت: متغیر `--font-anchor` در `app/brand.css`. فونت پروژهٔ آکادمی IRANYekan بود که مجوز تجاری دارد و برای همین در این ریپو نیست؛ فایل‌های فونت را خودت در `public/fonts` بگذار و `@font-face` را در `app/globals.css` بنویس.

## نگهداری

```bash
npx digdesign diff <component>     # مقایسه با رجیستری، بدون تغییر
npx digdesign update <component>   # فقط فایل‌های دست‌نخورده بازنویسی می‌شوند
npx digdesign doctor               # سلامت دیزاین سیستم در پروژه
```

## منبع

پروژهٔ Manement Academy، پوشهٔ `frontend`. مستندات: https://docs.digdesign.ir
