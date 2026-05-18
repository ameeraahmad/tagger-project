# 📋 سجل الترحيل: Tagger → Next.js + Cloudflare D1
**تاريخ الجلسة:** 16 مايو 2026

---

## 🎯 الهدف من الجلسة

تحويل مشروع **Tagger** من تطبيق Express.js + SQLite إلى:
- **Frontend/Backend:** Next.js (أحدث إصدار)
- **قاعدة البيانات:** Cloudflare D1 (بديل SQLite على الـ Edge)
- **الاستضافة:** Cloudflare Pages (بديل Vercel)
- **ORM:** Drizzle ORM (بديل Sequelize)

---

## ✅ الخطوات المنجزة

### الخطوة 1: فهم المشروع الحالي
- المشروع الحالي يعمل على **Node.js + Express.js**
- قاعدة البيانات الحالية: **SQLite** محلية (ملف `database.sqlite`)
- يستخدم مكتبة **Sequelize** للتعامل مع القاعدة
- الاستضافة الحالية: إعدادات **Vercel** موجودة (ملف `vercel.json`)

### الخطوة 2: إنشاء مشروع Next.js
- تم إنشاء مجلد جديد داخل المشروع: `tagger-web/`
- تم تشغيل الأمر:
  ```bash
  npx -y create-next-app@latest tagger-web --js --tailwind --eslint --app --no-src-dir --import-alias @/*
  ```
- **النتيجة:** ✅ تم إنشاء تطبيق Next.js 16 بنجاح

### الخطوة 3: محاولة تثبيت حزم Cloudflare
- تم محاولة تشغيل:
  ```bash
  npm install drizzle-orm
  npm install -D drizzle-kit @cloudflare/next-on-pages @cloudflare/workers-types wrangler
  ```
- **مشكلة اكتُشفت ⚠️:** حزمة `@cloudflare/next-on-pages` الإصدار `1.13.16` تطلب Next.js إصدار `>=14.3.0 && <=15.5.2`، لكن المشروع يستخدم Next.js `16.2.6` وهو أحدث من الحد المسموح به.

---

## 🔧 المشكلة القائمة وحلها

| المشكلة | التفاصيل |
|---------|---------|
| تعارض الإصدارات | `@cloudflare/next-on-pages` لا يدعم بعد Next.js v16 |
| **الحل المقترح** | استخدام `--legacy-peer-deps` أو الانتظار لتحديث الحزمة من Cloudflare |

### خيارات للمتابعة في الجلسة القادمة:

**الخيار أ: التراجع لإصدار Next.js 15 (الأكثر استقراراً)**
```bash
# داخل مجلد tagger-web
npm install next@15.3.2
```

**الخيار ب: تثبيت الحزم بـ legacy mode (قد يحدث عدم استقرار)**
```bash
npm install -D @cloudflare/next-on-pages wrangler --legacy-peer-deps
```

**الخيار ج: استخدام OpenNext (بديل حديث)**
```bash
npm install @opennextjs/cloudflare
```
> هذا هو البديل الرسمي المعتمد حالياً من Cloudflare لنشر تطبيقات Next.js على منصتهم.

---

## 📌 الخطوات المنجزة بالكامل اليوم

- [x] حل مشكلة تعارض الإصدارات (باستخدام Next.js 16 + Drizzle D1 HTTP Driver)
- [x] تثبيت `drizzle-orm` و `wrangler` و `better-sqlite3` بنجاح
- [x] إنشاء ملف `wrangler.json` لإعدادات Cloudflare
- [x] إنشاء قاعدة بيانات **D1** والحصول على **Database ID** (`0db95838-6916-4566-b59f-50dd89c6a892`)
- [x] استيراد مخطط قاعدة البيانات بالكامل (15 جدولاً) باستخدام `drizzle-kit pull` إلى ملف `db/schema.js`
- [x] توليد وتطبيق الـ Migrations بالكامل بنجاح على قاعدة البيانات السحابية D1
- [x] كتابة سكريبت لتصدير كافة البيانات من SQLite المحلية واستيرادها بنجاح في Cloudflare D1 (ترحيل 578 استعلاماً بنجاح!)
- [x] إنشاء **رمز API سرّي (Cloudflare API Token)** مخصص للوصول إلى قاعدة بيانات D1 بصلاحيات التعديل والقراءة.
- [x] إنشاء وتجهيز ملف الإعدادات المحلية `tagger-next/.env.local` للاتصال بـ D1 عبر الـ HTTP API بنجاح واختبار نجاح الاتصال.
- [x] ربط المشروع ورفعه بالكامل على منصة **Vercel** السحابية.
- [x] تهيئة وإضافة متغيرات البيئة (Environment Variables) السحابية على Vercel:
  - `CLOUDFLARE_ACCOUNT_ID`
  - `CLOUDFLARE_DATABASE_ID`
  - `CLOUDFLARE_D1_TOKEN`
- [x] إعادة نشر المشروع (Redeploy) على Vercel بنجاح لتفعيل الاتصال بقاعدة البيانات السحابية.

---

## 💡 ملاحظات معمارية وتقنية مهمة

> 💻 **الاتصال عن بُعد (Cloudflare D1 HTTP Driver):**
> تم ضبط المشروع للاتصال بقاعدة بيانات Cloudflare D1 عبر بروتوكول HTTPS باستخدام حزمة `drizzle-orm/d1-http`. هذه المعمارية المذهلة تتيح لتطبيق Next.js المنشور على Vercel إجراء استعلامات سريعة ومباشرة على قاعدة البيانات السحابية دون الحاجة لاستضافة الكود بالكامل على Cloudflare Pages، مما يمنحنا أفضل ما في المنصتين (سهولة Vercel المجانية وسرعة قاعدة بيانات Cloudflare).

> 📊 **ترحيل البيانات بنجاح 100%:**
> تم نقل جميع البيانات بنجاح؛ حيث تم استيراد **7 مستخدمين** و **62 إعلاناً** بالإضافة إلى الجداول الأخرى (إجمالي 15 جدولاً) دون فقدان أي بيانات أو علاقات.

---

*آخر تحديث: 18 مايو 2026 (الساعة 1:15 صباحاً)*


