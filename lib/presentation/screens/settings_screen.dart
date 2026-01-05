import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../providers/salary_provider.dart';

/// شاشة الإعدادات - Settings Screen
///
/// تتيح للمستخدم تخصيص:
/// - نسبة بدل السكن
/// - نسبة بدل المواصلات


/// شاشة الإعدادات
/// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.settings),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<SalaryProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 16),

                  // عنوان قسم البدلات
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      ArabicStrings.allowancesSettings,
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),

                  // بطاقة إعدادات البدلات
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // نسبة بدل السكن
                        _AllowanceSettingRow(
                          label: ArabicStrings.housingAllowancePercentage,
                          percentage: provider.housingAllowancePercentage,
                          onChanged:
                              provider.updateHousingAllowancePercentage,
                        ),

                        Divider(
                          height: 0.5,
                          color: AppColors.borderColor.withOpacity(0.3),
                        ),

                        // نسبة بدل المواصلات
                        _AllowanceSettingRow(
                          label:
                              ArabicStrings.transportationAllowancePercentage,
                          percentage:
                              provider.transportationAllowancePercentage,
                          onChanged:
                              provider.updateTransportationAllowancePercentage,
                          showBorder: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // معلومات عن التأمينات الاجتماعية
                  _GosiInfoCard(),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// صف إعداد نسبة البدل
/// Allowance Setting Row
class _AllowanceSettingRow extends StatelessWidget {
  final String label;
  final double percentage;
  final ValueChanged<double> onChanged;
  final bool showBorder;

  const _AllowanceSettingRow({
    required this.label,
    required this.percentage,
    required this.onChanged,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPercentagePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // النسبة على اليسار
            Text(
              '${(percentage * 100).toInt()}%',
              style: AppTextStyles.normalValue,
            ),
            // العنوان على اليمين
            Text(
              label,
              style: AppTextStyles.label,
            ),
          ],
        ),
      ),
    );
  }

  void _showPercentagePicker(BuildContext context) {
    final percentages = List.generate(51, (i) => i / 100); // 0% to 50%

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 250,
        child: Column(
          children: [
            // عنوان
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                label,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            // المنتقي
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem:
                      percentages.indexOf(percentage).clamp(0, percentages.length - 1),
                ),
                onSelectedItemChanged: (index) {
                  onChanged(percentages[index]);
                },
                children: percentages.map((p) {
                  return Center(
                    child: Text(
                      '${(p * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة معلومات التأمينات الاجتماعية
/// GOSI Info Card
class _GosiInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'معلومات التأمينات الاجتماعية',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 12),
          Text(
            'نسبة خصم التأمينات من الموظف: ${(GosiConstants.employeeContributionRate * 100).toStringAsFixed(2)}%',
            style: AppTextStyles.label,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            'الحد الأقصى للراتب الخاضع للتأمينات: ${GosiConstants.maxInsurableSalary.toInt()} ريال',
            style: AppTextStyles.label,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            'يتم احتساب خصم التأمينات على (الراتب الأساسي + بدل السكن)',
            style: AppTextStyles.secondaryLabel,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
