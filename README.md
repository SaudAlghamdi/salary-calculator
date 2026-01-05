# حاسبة الراتب السعودية - Saudi Salary Calculator

تطبيق Flutter لحساب تفاصيل الراتب مع خصومات التأمينات الاجتماعية (GOSI) في المملكة العربية السعودية.

A Flutter application for calculating salary details with GOSI (General Organization for Social Insurance) deductions in Saudi Arabia.

## المميزات - Features

### الحاسبة - Calculator
- حساب الراتب من إجمالي الراتب أو الراتب الأساسي
- تحليل الراتب إلى مكوناته (أساسي، بدل سكن، بدل مواصلات)
- حساب خصم التأمينات الاجتماعية (GOSI) بنسبة 9.75%
- حساب صافي الراتب بعد الخصومات
- حساب الزيادة السنوية بنسبة ثابتة أو مخصصة
- حساب صافي الدخل السنوي مع البونص

### الإعدادات - Settings
- تخصيص نسبة بدل السكن (الافتراضي: 25%)
- تخصيص نسبة بدل المواصلات (الافتراضي: 10%)
- عرض معلومات التأمينات الاجتماعية

### المواعيد - Appointments
- عرض مواعيد الراتب المهمة
- معلومات عن مواعيد خصم التأمينات
- معلومات عن الزيادات السنوية

### الإلتزامات - Commitments
- معلومات عن أنواع الإلتزامات المالية
- نصائح مالية للإدارة المالية السليمة

## معادلات الحساب - Calculation Formulas

### تحويل إجمالي الراتب إلى راتب أساسي
```
الراتب الأساسي = إجمالي الراتب ÷ (1 + نسبة بدل السكن + نسبة بدل المواصلات)
Basic Salary = Total Salary / (1 + Housing % + Transportation %)
```

مثال: إذا كان إجمالي الراتب 10,000 ريال
```
الراتب الأساسي = 10,000 ÷ 1.35 = 7,407.41 ريال
```

### حساب البدلات
```
بدل السكن = الراتب الأساسي × 25%
بدل المواصلات = الراتب الأساسي × 10%
```

### حساب خصم التأمينات الاجتماعية (GOSI)
```
الراتب الخاضع للتأمينات = الراتب الأساسي + بدل السكن
خصم التأمينات = الراتب الخاضع للتأمينات × 9.75%
```

**ملاحظات مهمة:**
- الحد الأقصى للراتب الخاضع للتأمينات: 45,000 ريال
- الحد الأدنى للراتب الخاضع للتأمينات: 1,500 ريال

### حساب صافي الراتب
```
صافي الراتب = إجمالي الراتب - خصم التأمينات
```

### حساب صافي الدخل السنوي
```
صافي الدخل السنوي = (صافي الراتب × 12) + (صافي الراتب × عدد رواتب البونص)
```

## هيكل المشروع - Project Structure

```
lib/
├── core/                          # الثوابت والإعدادات الأساسية
│   ├── constants.dart             # الثوابت (GOSI rates, strings)
│   └── theme.dart                 # ثيم التطبيق الداكن
├── data/
│   └── models/                    # نماذج البيانات
│       ├── salary_input.dart      # نموذج مدخلات الراتب
│       └── salary_breakdown.dart  # نموذج تفاصيل الراتب
├── domain/
│   ├── repositories/              # واجهات المستودعات
│   │   └── settings_repository.dart
│   └── services/                  # خدمات الأعمال
│       └── gosi_calculator_service.dart
├── presentation/
│   ├── providers/                 # إدارة الحالة (Provider)
│   │   └── salary_provider.dart
│   ├── screens/                   # الشاشات
│   │   ├── home_screen.dart
│   │   ├── calculator_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── appointments_screen.dart
│   │   └── commitments_screen.dart
│   └── widgets/                   # المكونات القابلة لإعادة الاستخدام
│       ├── salary_input_section.dart
│       ├── salary_details_section.dart
│       ├── salary_input_row.dart
│       └── segmented_control.dart
└── main.dart                      # نقطة الدخول الرئيسية
```

## المبادئ المتبعة - Design Principles

### SOLID Principles

1. **Single Responsibility Principle (SRP)**
   - كل كلاس له مسؤولية واحدة محددة
   - `GosiCalculatorService` مسؤول فقط عن الحسابات
   - `SettingsRepository` مسؤول فقط عن التخزين

2. **Open/Closed Principle (OCP)**
   - الكلاسات مفتوحة للتوسع ومغلقة للتعديل
   - يمكن إضافة أنواع جديدة من البدلات بدون تعديل الكود الحالي

3. **Liskov Substitution Principle (LSP)**
   - `ISalaryCalculatorService` يمكن استبداله بأي تنفيذ آخر

4. **Interface Segregation Principle (ISP)**
   - واجهات صغيرة ومحددة (`ISettingsRepository`, `ISalaryCalculatorService`)

5. **Dependency Inversion Principle (DIP)**
   - الاعتماد على الواجهات وليس التنفيذ
   - `SalaryProvider` يعتمد على `ISalaryCalculatorService`

### Clean Architecture
- فصل طبقات البيانات والمنطق والعرض
- تدفق البيانات أحادي الاتجاه

## المتطلبات - Requirements

- Flutter SDK: ^3.5.4
- Dart SDK: ^3.5.4
- Android: API 21+ (Android 5.0+)
- iOS: iOS 12.0+

## التثبيت - Installation

```bash
# استنساخ المشروع
git clone <repository-url>
cd salary-calculator

# تثبيت الاعتمادات
flutter pub get

# تشغيل التطبيق
flutter run
```

## البناء - Build

### Android
```bash
flutter build apk --release
# أو لـ App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## الاختبارات - Testing

```bash
# تشغيل الاختبارات
flutter test

# تشغيل الاختبارات مع التغطية
flutter test --coverage
```

## الاعتمادات - Dependencies

| الحزمة | الوصف |
|--------|-------|
| provider | إدارة الحالة |
| shared_preferences | التخزين المحلي |
| intl | تنسيق الأرقام والعملات |
| cupertino_icons | أيقونات iOS |

## الترخيص - License

MIT License

## المساهمة - Contributing

نرحب بالمساهمات! يرجى قراءة إرشادات المساهمة قبل تقديم طلب سحب.

---

تم التطوير بواسطة فريق حاسبة الراتب
Developed by Salary Calculator Team
