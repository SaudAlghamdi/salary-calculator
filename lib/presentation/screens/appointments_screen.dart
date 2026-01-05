import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

/// شاشة المواعيد - Appointments Screen
///
/// شاشة لعرض المواعيد المتعلقة بالراتب مثل:
/// - موعد نزول الراتب
/// - موعد خصم التأمينات
/// - مواعيد الزيادات السنوية


/// شاشة المواعيد
/// Appointments Screen
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.appointments),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // عنوان القسم
                Text(
                  'مواعيد الراتب',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 16),

                // بطاقة المواعيد
                _AppointmentCard(
                  title: 'موعد نزول الراتب',
                  description: 'يتم صرف الراتب عادةً في اليوم 27 من كل شهر ميلادي',
                  icon: Icons.calendar_today,
                ),

                const SizedBox(height: 12),

                _AppointmentCard(
                  title: 'خصم التأمينات الاجتماعية',
                  description: 'يتم خصم نسبة التأمينات شهرياً من الراتب',
                  icon: Icons.account_balance,
                ),

                const SizedBox(height: 12),

                _AppointmentCard(
                  title: 'الزيادة السنوية',
                  description:
                      'تتم الزيادات السنوية عادةً في بداية السنة المالية أو الهجرية حسب جهة العمل',
                  icon: Icons.trending_up,
                ),

                const SizedBox(height: 24),

                // ملاحظة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'ملاحظة: المواعيد المذكورة تقريبية وقد تختلف حسب جهة العمل',
                          style: AppTextStyles.secondaryLabel,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة الموعد
/// Appointment Card
class _AppointmentCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _AppointmentCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // المحتوى
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.secondaryLabel,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.textGreen,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
