import 'package:flutter/material.dart';

/// ثيم التطبيق - Application Theme
///
/// يحتوي على تعريف الألوان والأنماط المستخدمة في التطبيق
/// يدعم الوضع الداكن فقط كما في التصميم الأصلي

/// ألوان التطبيق
/// App Colors
class AppColors {
  AppColors._();

  // الألوان الأساسية - Primary Colors
  static const Color primaryBlack = Color(0xFF000000);
  static const Color cardBackground = Color(0xFF1C1C1E);
  static const Color inputBackground = Color(0xFF2C2C2E);
  static const Color segmentedControlBackground = Color(0xFF3A3A3C);

  // ألوان النصوص - Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textGreen = Color(0xFF30D158);
  static const Color textRed = Color(0xFFFF453A);

  // ألوان الحدود - Border Colors
  static const Color borderColor = Color(0xFF3A3A3C);

  // ألوان التحديد - Selection Colors
  static const Color selectedTab = Color(0xFF636366);
  static const Color unselectedTab = Colors.transparent;
}

/// ثيم التطبيق الداكن
/// Dark Theme Configuration
class AppTheme {
  AppTheme._();

  /// الثيم الداكن للتطبيق
  /// Dark theme for the application
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBlack,
      primaryColor: AppColors.textPrimary,

      // شريط التطبيق - AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // البطاقات - Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // شريط التنقل السفلي - Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // حقول الإدخال - Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // النصوص - Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // الأزرار - Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),

      // الأيقونات - Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderColor,
        thickness: 0.5,
      ),
    );
  }
}

/// أنماط النصوص المخصصة
/// Custom Text Styles
class AppTextStyles {
  AppTextStyles._();

  /// نمط القيمة الخضراء (صافي الراتب)
  /// Green value style (Net Salary)
  static const TextStyle greenValue = TextStyle(
    color: AppColors.textGreen,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// نمط القيمة الحمراء (خصم التأمينات)
  /// Red value style (Insurance Deduction)
  static const TextStyle redValue = TextStyle(
    color: AppColors.textRed,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// نمط القيمة العادية
  /// Normal value style
  static const TextStyle normalValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  /// نمط العنوان
  /// Label style
  static const TextStyle label = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// نمط العنوان الثانوي
  /// Secondary label style
  static const TextStyle secondaryLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// نمط عنوان القسم
  /// Section title style
  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}
