import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import 'customize_allowances_screen.dart';

/// شاشة الإعدادات - Settings Screen
///
/// تتيح للمستخدم تخصيص:
/// - البدلات
/// - المدخلات
/// - التواصل والمشاركة

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 16),

              // زر دعم التطبيق
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement support/donation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          ArabicStrings.supportApp,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // قسم البدلات
              _buildSectionHeader(ArabicStrings.allowances),
              _buildNavigationItem(
                context,
                title: ArabicStrings.customizeAllowances,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomizeAllowancesScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // قسم المدخلات
              _buildSectionHeader(ArabicStrings.inputs),
              _buildNavigationItem(
                context,
                title: ArabicStrings.customizeInputs,
                onTap: () => _showCustomizeInputsSheet(context),
              ),

              const SizedBox(height: 16),

              // قسم الزيادة التدريجية
              _buildSectionHeader(ArabicStrings.gradualIncrease),
              _buildNavigationItem(
                context,
                title: ArabicStrings.gradualIncreaseInsurance,
                onTap: () {
                  // TODO: Implement gradual increase screen
                },
              ),

              const SizedBox(height: 16),

              // قسم التواصل
              _buildSectionHeader(ArabicStrings.contactUs),
              _buildContactCard(context),

              const SizedBox(height: 16),

              // زر مشاركة التطبيق
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Share.share(
                      'حاسبة الراتب السعودية - حمل التطبيق الآن!',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ArabicStrings.shareApp,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.ios_share,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // قسم الروابط المهمة
              _buildSectionHeader(ArabicStrings.usefulLinks),
              _buildNavigationItem(
                context,
                title: ArabicStrings.gosiGuide,
                onTap: () {
                  // TODO: Open GOSI guide link
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle,
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.chevron_left,
                color: AppColors.textSecondary,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // تويتر
          InkWell(
            onTap: () {
              // TODO: Open Twitter
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.flutter_dash, // Twitter icon placeholder
                    color: Colors.blue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ArabicStrings.twitter,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        '@7asebatALRateb',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Divider(
            height: 0.5,
            color: AppColors.borderColor.withOpacity(0.3),
            indent: 16,
            endIndent: 16,
          ),

          // البريد الإلكتروني
          InkWell(
            onTap: () {
              // TODO: Open email
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.alternate_email,
                    color: Colors.blue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ArabicStrings.email,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'YazeedALZahraniApps@gmail.com',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomizeInputsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CustomizeInputsSheet(),
    );
  }
}

/// ورقة تخصيص المدخلات
class _CustomizeInputsSheet extends StatefulWidget {
  const _CustomizeInputsSheet();

  @override
  State<_CustomizeInputsSheet> createState() => _CustomizeInputsSheetState();
}

class _CustomizeInputsSheetState extends State<_CustomizeInputsSheet> {
  bool _saveInputs = false;
  bool _showCommitments = true;
  bool _showAnnualBonus = true;
  final TextEditingController _dollarRateController = TextEditingController(text: '3.75');

  @override
  void dispose() {
    _dollarRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // الهيدر
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      ArabicStrings.save,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    ArabicStrings.customizeInputs,
                    style: AppTextStyles.sectionTitle,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // حفظ المدخلات
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoSwitch(
                    value: _saveInputs,
                    onChanged: (value) {
                      setState(() {
                        _saveInputs = value;
                      });
                    },
                    activeColor: AppColors.textGreen,
                  ),
                  Text(
                    ArabicStrings.saveInputs,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // قسم إظهار
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                ArabicStrings.show,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // الإلتزامات المالية
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoSwitch(
                          value: _showCommitments,
                          onChanged: (value) {
                            setState(() {
                              _showCommitments = value;
                            });
                          },
                          activeColor: AppColors.textGreen,
                        ),
                        Text(
                          ArabicStrings.financialCommitments,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 0.5,
                    color: AppColors.borderColor.withOpacity(0.3),
                  ),

                  // البونص السنوي
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoSwitch(
                          value: _showAnnualBonus,
                          onChanged: (value) {
                            setState(() {
                              _showAnnualBonus = value;
                            });
                          },
                          activeColor: AppColors.textGreen,
                        ),
                        Text(
                          ArabicStrings.annualBonus,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // سعر صرف الدولار
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                ArabicStrings.dollarExchangeRate,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _dollarRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '1 دولار = ${_dollarRateController.text} ريال',
                style: AppTextStyles.secondaryLabel,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
