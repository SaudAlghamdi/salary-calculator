import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/services/gosi_calculator_service.dart';
import 'presentation/providers/salary_provider.dart';
import 'presentation/screens/home_screen.dart';

/// نقطة الدخول الرئيسية للتطبيق - Main Entry Point
///
/// حاسبة الراتب السعودية
/// تطبيق لحساب تفاصيل الراتب مع خصومات التأمينات الاجتماعية (GOSI)
///
/// Saudi Salary Calculator
/// App for calculating salary details with GOSI social insurance deductions
void main() async {
  // التأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تثبيت اتجاه الشاشة (عمودي فقط)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تهيئة التخزين المحلي
  final prefs = await SharedPreferences.getInstance();
  final settingsRepository = SettingsRepository(prefs);

  // تهيئة خدمة الحسابات
  const calculatorService = GosiCalculatorService();

  // تشغيل التطبيق
  runApp(
    SalaryCalculatorApp(
      settingsRepository: settingsRepository,
      calculatorService: calculatorService,
    ),
  );
}

/// تطبيق حاسبة الراتب
/// Salary Calculator App
///
/// التطبيق الرئيسي الذي يهيئ:
/// - الثيم الداكن
/// - اللغة العربية
/// - مزود الحالة (Provider)
class SalaryCalculatorApp extends StatelessWidget {
  /// مستودع الإعدادات
  final ISettingsRepository settingsRepository;

  /// خدمة الحسابات
  final ISalaryCalculatorService calculatorService;

  /// المُنشئ
  const SalaryCalculatorApp({
    super.key,
    required this.settingsRepository,
    required this.calculatorService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalaryProvider(
        calculatorService: calculatorService,
        settingsRepository: settingsRepository,
      )..loadSavedSettings(),
      child: MaterialApp(
        // عنوان التطبيق
        title: 'حاسبة الراتب',

        // إخفاء شريط التصحيح
        debugShowCheckedModeBanner: false,

        // الثيم الداكن
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // اللغة العربية
        locale: const Locale('ar', 'SA'),

        // دعم RTL
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },

        // الشاشة الرئيسية
        home: const HomeScreen(),
      ),
    );
  }
}
