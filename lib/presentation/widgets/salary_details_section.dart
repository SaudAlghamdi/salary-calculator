import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../providers/salary_provider.dart';
import 'salary_input_row.dart';

/// قسم تفاصيل الراتب - Salary Details Section Widget
///
/// يعرض جميع تفاصيل الراتب المحسوبة بما في ذلك:
/// - الراتب الأساسي
/// - البدلات (السكن والمواصلات)
/// - إجمالي الراتب
/// - خصم التأمينات
/// - صافي الراتب


/// قسم تفاصيل الراتب
/// Salary Details Section
class SalaryDetailsSection extends StatelessWidget {
  const SalaryDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalaryProvider>(
      builder: (context, provider, _) {
        final breakdown = provider.breakdown;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // عنوان القسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                ArabicStrings.salaryDetails,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            // بطاقة تفاصيل الراتب
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // الراتب الأساسي
                  SalaryInfoRow(
                    label: ArabicStrings.basicSalary,
                    value: breakdown.basicSalary,
                  ),

                  // بدل السكن
                  SalaryInfoRow(
                    label: ArabicStrings.housingAllowance,
                    value: breakdown.housingAllowance,
                  ),

                  // بدل المواصلات
                  SalaryInfoRow(
                    label: ArabicStrings.transportationAllowance,
                    value: breakdown.transportationAllowance,
                  ),

                  // إجمالي الراتب
                  SalaryInfoRow(
                    label: ArabicStrings.totalSalary,
                    value: breakdown.totalSalary,
                    style: SalaryValueStyle.normal,
                  ),

                  // خصم التأمينات (بالأحمر)
                  SalaryInfoRow(
                    label: ArabicStrings.insuranceDeduction,
                    value: breakdown.insuranceDeduction,
                    style: SalaryValueStyle.red,
                  ),

                  // صافي الراتب (بالأخضر)
                  SalaryInfoRow(
                    label: ArabicStrings.netSalary,
                    value: breakdown.netSalary,
                    style: SalaryValueStyle.green,
                    darkBackground: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// قسم التفاصيل الإضافية
/// Additional Details Section
class AdditionalDetailsSection extends StatelessWidget {
  const AdditionalDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalaryProvider>(
      builder: (context, provider, _) {
        final breakdown = provider.breakdown;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // عنوان القسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                ArabicStrings.additionalDetails,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            // بطاقة صافي الدخل السنوي
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SalaryInfoRow(
                label: ArabicStrings.annualNetIncome,
                value: breakdown.annualNetIncome,
                style: SalaryValueStyle.green,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// قسم الزيادة السنوية
/// Annual Increase Section
class AnnualIncreaseSection extends StatelessWidget {
  const AnnualIncreaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalaryProvider>(
      builder: (context, provider, _) {
        final breakdown = provider.breakdown;

        // لا يظهر إذا لم تكن هناك زيادة
        if (!breakdown.hasAnnualIncrease) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // عنوان القسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                ArabicStrings.annualIncreaseOn,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            // بطاقة تفاصيل الزيادة
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // الزيادة على إجمالي الراتب
                  SalaryInfoRow(
                    label: ArabicStrings.totalSalary,
                    value: breakdown.totalSalaryIncrease,
                    style: SalaryValueStyle.green,
                  ),

                  // الزيادة على صافي الراتب
                  SalaryInfoRow(
                    label: ArabicStrings.netSalary,
                    value: breakdown.netSalaryIncrease,
                    style: SalaryValueStyle.green,
                  ),
                ],
              ),
            ),

            // زر اعتماد الراتب الجديد
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: provider.applyNewSalaryAfterIncrease,
                child: Text(
                  ArabicStrings.applyNewSalary,
                  style: AppTextStyles.greenValue.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
