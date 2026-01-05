import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../widgets/salary_details_section.dart';
import '../widgets/salary_input_section.dart';

/// شاشة الحاسبة - Calculator Screen
///
/// الشاشة الرئيسية للتطبيق التي تعرض:
/// - قسم المدخلات (الراتب، الزيادة السنوية، البونص)
/// - قسم تفاصيل الراتب المحسوبة
/// - قسم التفاصيل الإضافية (صافي الدخل السنوي)
/// - قسم الزيادة السنوية (إذا كانت موجودة)


/// شاشة الحاسبة الرئيسية
/// Main Calculator Screen
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.appTitle),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // قسم المدخلات
              SalaryInputSection(),

              // قسم تفاصيل الراتب
              SalaryDetailsSection(),

              SizedBox(height: 16),

              // قسم التفاصيل الإضافية
              AdditionalDetailsSection(),

              SizedBox(height: 16),

              // قسم الزيادة السنوية (يظهر فقط إذا كانت هناك زيادة)
              AnnualIncreaseSection(),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
