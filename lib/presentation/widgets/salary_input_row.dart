import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../core/constants.dart';
import '../../core/theme.dart';

/// صف إدخال الراتب - Salary Input Row Widget
///
/// مكون واجهة مستخدم لعرض صف يحتوي على عنوان وقيمة
/// مع إمكانية التعديل أو العرض فقط


/// صف عرض معلومات الراتب
/// Salary Information Row Widget
///
/// يعرض صف يحتوي على عنوان على اليمين وقيمة على اليسار
/// مع دعم أنماط مختلفة للقيم (عادي، أخضر، أحمر)
class SalaryInfoRow extends StatelessWidget {
  /// العنوان
  final String label;

  /// القيمة
  final double value;

  /// نمط القيمة
  final SalaryValueStyle style;

  /// إظهار العملة
  final bool showCurrency;

  /// خلفية داكنة
  final bool darkBackground;

  /// المُنشئ
  const SalaryInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.style = SalaryValueStyle.normal,
    this.showCurrency = true,
    this.darkBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final formattedValue = formatter.format(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: darkBackground ? AppColors.cardBackground : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // القيمة على اليسار
          Text(
            showCurrency ? '$formattedValue ${ArabicStrings.sar}' : formattedValue,
            style: _getValueStyle(),
            textDirection: TextDirection.ltr,
          ),
          // العنوان على اليمين
          Text(
            label,
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }

  /// الحصول على نمط القيمة حسب النوع
  TextStyle _getValueStyle() {
    switch (style) {
      case SalaryValueStyle.green:
        return AppTextStyles.greenValue;
      case SalaryValueStyle.red:
        return AppTextStyles.redValue;
      case SalaryValueStyle.normal:
      default:
        return AppTextStyles.normalValue;
    }
  }
}

/// أنماط قيم الراتب
/// Salary Value Styles
enum SalaryValueStyle {
  /// نمط عادي (أبيض)
  normal,

  /// نمط إيجابي (أخضر)
  green,

  /// نمط سلبي (أحمر)
  red,
}

/// صف عنوان ثانوي
/// Secondary Label Row
class SecondaryLabelRow extends StatelessWidget {
  /// النص الثانوي
  final String text;

  /// المُنشئ
  const SecondaryLabelRow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: AppTextStyles.secondaryLabel,
          ),
        ],
      ),
    );
  }
}
