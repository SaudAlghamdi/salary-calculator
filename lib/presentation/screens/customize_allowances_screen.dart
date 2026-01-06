import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../providers/salary_provider.dart';
import '../widgets/segmented_control.dart';

/// أنواع البدلات المتاحة
enum AllowanceType {
  housing(ArabicStrings.housingAllowance),
  transportation(ArabicStrings.transportationAllowance),
  workNature(ArabicStrings.workNatureAllowance),
  costOfLiving(ArabicStrings.costOfLivingAllowance),
  communication(ArabicStrings.communicationAllowance),
  phone(ArabicStrings.phoneAllowance),
  risk(ArabicStrings.riskAllowance),
  secondment(ArabicStrings.secondmentAllowance),
  infection(ArabicStrings.infectionAllowance),
  computer(ArabicStrings.computerAllowance),
  appearance(ArabicStrings.appearanceAllowance),
  travel(ArabicStrings.travelAllowance),
  trips(ArabicStrings.tripsAllowance),
  food(ArabicStrings.foodAllowance);

  final String label;
  const AllowanceType(this.label);
}

/// شاشة تخصيص البدلات - Customize Allowances Screen
class CustomizeAllowancesScreen extends StatelessWidget {
  const CustomizeAllowancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.customizeAllowances),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddAllowanceSheet(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, _) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 16),

                  // بدل السكن
                  _AllowanceCard(
                    title: ArabicStrings.housingAllowance,
                    percentage: provider.housingAllowancePercentage,
                    onPercentageChanged: provider.updateHousingAllowancePercentage,
                    isDeletable: false,
                  ),

                  const SizedBox(height: 16),

                  // بدل المواصلات
                  _AllowanceCard(
                    title: ArabicStrings.transportationAllowance,
                    percentage: provider.transportationAllowancePercentage,
                    onPercentageChanged: provider.updateTransportationAllowancePercentage,
                    isDeletable: false,
                  ),

                  const SizedBox(height: 24),

                  // ملاحظات
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          ArabicStrings.addAllowanceHint,
                          style: AppTextStyles.secondaryLabel,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ArabicStrings.swipeToDeleteHint,
                          style: AppTextStyles.secondaryLabel,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddAllowanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const _AddAllowanceSheet(),
    );
  }
}

/// بطاقة البدل
class _AllowanceCard extends StatefulWidget {
  final String title;
  final double percentage;
  final ValueChanged<double> onPercentageChanged;
  final bool isDeletable;
  final VoidCallback? onDelete;

  const _AllowanceCard({
    required this.title,
    required this.percentage,
    required this.onPercentageChanged,
    this.isDeletable = true,
    this.onDelete,
  });

  @override
  State<_AllowanceCard> createState() => _AllowanceCardState();
}

class _AllowanceCardState extends State<_AllowanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isRevealed = false;
  bool _showPercentage = true; // true = percentage, false = value

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.2, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    if (!widget.isDeletable) return;
    setState(() {
      _isRevealed = !_isRevealed;
      if (_isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // عنوان البدل
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.title,
            style: AppTextStyles.sectionTitle,
          ),
        ),

        const SizedBox(height: 8),

        // بطاقة البدل
        GestureDetector(
          onHorizontalDragEnd: widget.isDeletable
              ? (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < -200) {
                      _toggleReveal();
                    } else if (details.primaryVelocity! > 200 && _isRevealed) {
                      _toggleReveal();
                    }
                  }
                }
              : null,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                // زر الحذف
                if (widget.isDeletable)
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            _toggleReveal();
                            widget.onDelete?.call();
                          },
                          child: Container(
                            width: 70,
                            decoration: const BoxDecoration(
                              color: AppColors.textRed,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ArabicStrings.delete,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // المحتوى الرئيسي
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // شريط التبديل بين القيمة والنسبة
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SegmentedControl(
                            firstOption: ArabicStrings.value,
                            secondOption: ArabicStrings.percentage,
                            selectedIndex: _showPercentage ? 1 : 0,
                            onChanged: (index) {
                              setState(() {
                                _showPercentage = index == 1;
                              });
                            },
                          ),
                        ),

                        // صف البدل
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // القيمة أو النسبة
                              Text(
                                _showPercentage
                                    ? '${(widget.percentage * 100).toStringAsFixed(2)} %'
                                    : '0.00 ${ArabicStrings.sar}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              // اسم البدل
                              Text(
                                widget.title,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ورقة إضافة بدل جديد
class _AddAllowanceSheet extends StatelessWidget {
  const _AddAllowanceSheet();

  @override
  Widget build(BuildContext context) {
    final allowanceTypes = [
      ArabicStrings.customName,
      ArabicStrings.housingAllowance,
      ArabicStrings.transportationAllowance,
      ArabicStrings.workNatureAllowance,
      ArabicStrings.costOfLivingAllowance,
      ArabicStrings.communicationAllowance,
      ArabicStrings.phoneAllowance,
      ArabicStrings.riskAllowance,
      ArabicStrings.secondmentAllowance,
      ArabicStrings.infectionAllowance,
      ArabicStrings.computerAllowance,
      ArabicStrings.appearanceAllowance,
      ArabicStrings.travelAllowance,
      ArabicStrings.tripsAllowance,
      ArabicStrings.foodAllowance,
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          // العنوان
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              ArabicStrings.chooseAllowanceType,
              style: AppTextStyles.sectionTitle,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // قائمة أنواع البدلات
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: allowanceTypes.length,
              separatorBuilder: (context, index) => Divider(
                height: 0.5,
                color: AppColors.borderColor.withOpacity(0.3),
              ),
              itemBuilder: (context, index) {
                final type = allowanceTypes[index];
                final isCustom = index == 0;

                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Add allowance logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isCustom
                            ? AppColors.textGreen
                            : AppColors.textPrimary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
