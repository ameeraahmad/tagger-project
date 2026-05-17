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

## 📌 الخطوات المتبقية (للجلسة القادمة)

- [ ] حل مشكلة تعارض الإصدارات
- [ ] تثبيت `drizzle-orm` و `wrangler` بنجاح
- [ ] إنشاء ملف `wrangler.json` لإعدادات Cloudflare
- [ ] إنشاء قاعدة بيانات **D1** من لوحة Cloudflare والحصول على **Database ID**
- [ ] إنشاء ملفات مخطط قاعدة البيانات (Schema) بـ Drizzle
- [ ] كتابة سكريبت لتصدير بيانات SQLite الحالية إلى Cloudflare D1
- [ ] نشر (Deploy) الموقع على Cloudflare Pages

---

## 💡 ملاحظات مهمة

> **قاعدة البيانات الحالية:** ملف `database.sqlite` يحتوي على بياناتك ويجب الاحتفاظ بنسخة منه.

> **Drizzle ORM** هو بديل حديث وسريع لـ Sequelize، وهو الخيار الرسمي المفضل للعمل مع Cloudflare D1.

> **Cloudflare Pages** يدعم تطبيقات Next.js عبر مكتبة `@opennextjs/cloudflare` — وهي الطريقة الأحدث والأكثر استقراراً.

---

*آخر تحديث: 16/05/2026*
