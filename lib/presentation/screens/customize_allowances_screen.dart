import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../providers/allowances_provider.dart';
import '../widgets/segmented_control.dart';

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
      body: Consumer<AllowancesProvider>(
        builder: (context, provider, _) {
          final allowances = provider.allowances;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 16),

                  // قائمة البدلات
                  ...allowances.map((allowance) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _AllowanceCard(
                      allowance: allowance,
                      onValueChanged: (value) {
                        provider.updateAllowanceValue(allowance.id, value);
                      },
                      onTypeChanged: (isPercentage) {
                        provider.updateAllowanceType(allowance.id, isPercentage);
                      },
                      onDelete: allowance.isDefault
                          ? null
                          : () => provider.deleteAllowance(allowance.id),
                    ),
                  )),

                  const SizedBox(height: 8),

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
  final Allowance allowance;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<bool> onTypeChanged;
  final VoidCallback? onDelete;

  const _AllowanceCard({
    required this.allowance,
    required this.onValueChanged,
    required this.onTypeChanged,
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
  late TextEditingController _valueController;

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

    _initValueController();
  }

  void _initValueController() {
    final displayValue = widget.allowance.isPercentage
        ? (widget.allowance.value * 100).toStringAsFixed(2)
        : widget.allowance.value.toStringAsFixed(2);
    _valueController = TextEditingController(text: displayValue);
  }

  @override
  void didUpdateWidget(covariant _AllowanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allowance.value != widget.allowance.value ||
        oldWidget.allowance.isPercentage != widget.allowance.isPercentage) {
      _initValueController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    if (widget.onDelete == null) return;
    setState(() {
      _isRevealed = !_isRevealed;
      if (_isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onValueSubmitted(String text) {
    final parsed = double.tryParse(text);
    if (parsed != null) {
      final value = widget.allowance.isPercentage ? parsed / 100 : parsed;
      widget.onValueChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeletable = widget.onDelete != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // عنوان البدل
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.allowance.name,
            style: AppTextStyles.sectionTitle,
          ),
        ),

        const SizedBox(height: 8),

        // بطاقة البدل
        GestureDetector(
          onHorizontalDragEnd: isDeletable
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
                if (isDeletable)
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
                            selectedIndex: widget.allowance.isPercentage ? 1 : 0,
                            onChanged: (index) {
                              widget.onTypeChanged(index == 1);
                            },
                          ),
                        ),

                        // صف البدل مع إمكانية التعديل
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // حقل القيمة
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: TextField(
                                        controller: _valueController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onSubmitted: _onValueSubmitted,
                                        onEditingComplete: () {
                                          _onValueSubmitted(_valueController.text);
                                        },
                                      ),
                                    ),
                                    Text(
                                      widget.allowance.isPercentage
                                          ? ' %'
                                          : ' ${ArabicStrings.sar}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // اسم البدل
                              Text(
                                widget.allowance.name,
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
                    if (isCustom) {
                      _showCustomNameDialog(context);
                    } else {
                      _addAllowance(context, type);
                    }
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

  void _addAllowance(BuildContext context, String name) {
    final provider = Provider.of<AllowancesProvider>(context, listen: false);
    provider.addAllowance(name: name);
  }

  void _showCustomNameDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          ArabicStrings.customName,
          style: AppTextStyles.sectionTitle,
          textAlign: TextAlign.right,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: ArabicStrings.enterAllowanceName,
            hintStyle: AppTextStyles.secondaryLabel,
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              ArabicStrings.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final provider = Provider.of<AllowancesProvider>(
                  context,
                  listen: false,
                );
                provider.addAllowance(name: controller.text.trim());
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              ArabicStrings.add,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
