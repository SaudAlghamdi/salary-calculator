import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

/// شاشة الإلتزامات - Commitments Screen
///
/// شاشة لعرض وإدارة الإلتزامات المالية مثل:
/// - القروض
/// - الأقساط
/// - الفواتير الشهرية


/// شاشة الإلتزامات
/// Commitments Screen
class CommitmentsScreen extends StatelessWidget {
  const CommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.commitments),
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
                  'الإلتزامات المالية',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 16),

                // بطاقة توضيحية
                _CommitmentInfoCard(),

                const SizedBox(height: 24),

                // أنواع الإلتزامات
                Text(
                  'أنواع الإلتزامات',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 16),

                _CommitmentTypeCard(
                  title: 'القروض',
                  description: 'القروض الشخصية والعقارية وقروض السيارات',
                  icon: Icons.account_balance_wallet,
                ),

                const SizedBox(height: 12),

                _CommitmentTypeCard(
                  title: 'الأقساط',
                  description: 'أقساط الأجهزة والإلكترونيات والمشتريات',
                  icon: Icons.credit_card,
                ),

                const SizedBox(height: 12),

                _CommitmentTypeCard(
                  title: 'الفواتير الشهرية',
                  description: 'الكهرباء والماء والإنترنت والهاتف',
                  icon: Icons.receipt_long,
                ),

                const SizedBox(height: 12),

                _CommitmentTypeCard(
                  title: 'الإيجار',
                  description: 'إيجار السكن الشهري أو السنوي',
                  icon: Icons.home,
                ),

                const SizedBox(height: 24),

                // نصيحة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'نصيحة مالية',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.textGreen,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يُنصح بعدم تجاوز إجمالي الإلتزامات الشهرية 40% من صافي الراتب لضمان الاستقرار المالي',
                        style: AppTextStyles.secondaryLabel,
                        textAlign: TextAlign.right,
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

/// بطاقة معلومات الإلتزامات
/// Commitment Info Card
class _CommitmentInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'إدارة الإلتزامات',
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.pie_chart_outline,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'تتبع إلتزاماتك المالية الشهرية لمعرفة المبلغ المتبقي من راتبك بعد سداد جميع الإلتزامات',
            style: AppTextStyles.secondaryLabel,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

/// بطاقة نوع الإلتزام
/// Commitment Type Card
class _CommitmentTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _CommitmentTypeCard({
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
