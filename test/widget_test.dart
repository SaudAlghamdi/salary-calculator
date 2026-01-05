/// اختبارات تطبيق حاسبة الراتب
/// Salary Calculator Widget Tests
///
/// اختبارات أساسية للتحقق من عمل التطبيق

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_calculator/core/constants.dart';
import 'package:salary_calculator/domain/repositories/settings_repository.dart';
import 'package:salary_calculator/domain/services/gosi_calculator_service.dart';
import 'package:salary_calculator/main.dart';

void main() {
  /// اختبار أن التطبيق يبدأ بشكل صحيح
  /// Test that the app starts correctly
  testWidgets('App starts and shows calculator screen', (WidgetTester tester) async {
    // تهيئة SharedPreferences للاختبار
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settingsRepository = SettingsRepository(prefs);
    const calculatorService = GosiCalculatorService();

    // بناء التطبيق
    await tester.pumpWidget(
      SalaryCalculatorApp(
        prefs: prefs,
        settingsRepository: settingsRepository,
        calculatorService: calculatorService,
      ),
    );

    // انتظار اكتمال التحميل
    await tester.pumpAndSettle();

    // التحقق من ظهور عنوان التطبيق
    expect(find.text(ArabicStrings.appTitle), findsOneWidget);
  });

  /// اختبار حسابات التأمينات الاجتماعية
  /// Test GOSI calculations
  test('GOSI calculator calculates correct values', () {
    const calculator = GosiCalculatorService();

    // اختبار تحويل إجمالي الراتب إلى أساسي
    // Total: 10,000 = Basic * (1 + 0.25 + 0.10) = Basic * 1.35
    // Basic = 10,000 / 1.35 = 7,407.41
    final basicSalary = calculator.totalToBasicSalary(10000, 0.25, 0.10);
    expect(basicSalary, closeTo(7407.41, 0.01));

    // اختبار حساب خصم التأمينات
    // GOSI = (Basic + Housing) * 9.75%
    // GOSI = (7407.41 + 1851.85) * 0.0975 = 902.78
    final housingAllowance = basicSalary * 0.25;
    final gosiDeduction = calculator.calculateGosiDeduction(basicSalary, housingAllowance);
    expect(gosiDeduction, closeTo(902.78, 0.01));
  });
}
