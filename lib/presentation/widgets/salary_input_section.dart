import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/salary_input.dart';
import '../providers/salary_provider.dart';
import 'segmented_control.dart';

/// قسم مدخلات الراتب - Salary Input Section Widget
///
/// يحتوي على جميع حقول إدخال بيانات الراتب


/// قسم مدخلات الراتب
/// Salary Input Section
class SalaryInputSection extends StatelessWidget {
  const SalaryInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalaryProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // عنوان القسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                ArabicStrings.inputs,
                style: AppTextStyles.sectionTitle,
              ),
            ),

            // شريط التحكم للتبديل بين إجمالي الراتب والراتب الأساسي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedControl(
                firstOption: ArabicStrings.basicSalary,
                secondOption: ArabicStrings.totalSalary,
                selectedIndex:
                    provider.inputMode == SalaryInputMode.totalSalary ? 1 : 0,
                onChanged: (index) {
                  provider.updateInputMode(
                    index == 1
                        ? SalaryInputMode.totalSalary
                        : SalaryInputMode.basicSalary,
                  );
                },
              ),
            ),

            // البطاقة الرئيسية للمدخلات
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // حقل الراتب
                  _SalaryInputField(
                    label: provider.inputMode == SalaryInputMode.totalSalary
                        ? ArabicStrings.totalSalary
                        : ArabicStrings.basicSalary,
                    value: provider.inputSalary,
                    onChanged: provider.updateInputSalary,
                  ),

                  // حقل الزيادة السنوية
                  _AnnualIncreaseField(
                    percentage: provider.annualIncreasePercentage,
                    type: provider.annualIncreaseType,
                    onPercentageChanged: (value) =>
                        provider.updateAnnualIncrease(value),
                    onTypeChanged: provider.updateAnnualIncreaseType,
                  ),

                  // حقل البونص السنوي
                  _BonusSalariesField(
                    bonusSalaries: provider.bonusSalaries,
                    onChanged: provider.updateBonusSalaries,
                  ),
                ],
              ),
            ),

            // ملاحظة تخصيص البدلات
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                ArabicStrings.customizeMessage,
                style: AppTextStyles.secondaryLabel,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// حقل إدخال الراتب
/// Salary Input Field
class _SalaryInputField extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _SalaryInputField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_SalaryInputField> createState() => _SalaryInputFieldState();
}

class _SalaryInputFieldState extends State<_SalaryInputField> {
  late TextEditingController _controller;
  final _formatter = NumberFormat('#,##0.00', 'en_US');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _formatter.format(widget.value),
    );
  }

  @override
  void didUpdateWidget(_SalaryInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final newText = _formatter.format(widget.value);
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InputRowContainer(
      label: widget.label,
      child: Row(
        children: [
          Text(
            ArabicStrings.sarSymbol,
            style: AppTextStyles.secondaryLabel,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              style: AppTextStyles.normalValue,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (value) {
                final cleanValue = value.replaceAll(',', '');
                final number = double.tryParse(cleanValue);
                if (number != null && number > 0) {
                  widget.onChanged(number);
                }
              },
              onSubmitted: (value) {
                final cleanValue = value.replaceAll(',', '');
                final number = double.tryParse(cleanValue);
                if (number != null && number > 0) {
                  _controller.text = _formatter.format(number);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// حقل الزيادة السنوية
/// Annual Increase Field
class _AnnualIncreaseField extends StatelessWidget {
  final double percentage;
  final AnnualIncreaseType type;
  final ValueChanged<double> onPercentageChanged;
  final ValueChanged<AnnualIncreaseType> onTypeChanged;

  const _AnnualIncreaseField({
    required this.percentage,
    required this.type,
    required this.onPercentageChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InputRowContainer(
      label: ArabicStrings.annualIncrease,
      child: GestureDetector(
        onTap: () => _showAnnualIncreasePicker(context),
        child: Row(
          children: [
            Text(
              '${percentage.toStringAsFixed(percentage == percentage.roundToDouble() ? 0 : 1)}%',
              style: AppTextStyles.normalValue,
            ),
          ],
        ),
      ),
    );
  }

  void _showAnnualIncreasePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _AnnualIncreasePickerSheet(
        currentPercentage: percentage,
        currentType: type,
        onPercentageChanged: onPercentageChanged,
        onTypeChanged: onTypeChanged,
      ),
    );
  }
}

/// ورقة اختيار الزيادة السنوية
/// Annual Increase Picker Sheet
class _AnnualIncreasePickerSheet extends StatefulWidget {
  final double currentPercentage;
  final AnnualIncreaseType currentType;
  final ValueChanged<double> onPercentageChanged;
  final ValueChanged<AnnualIncreaseType> onTypeChanged;

  const _AnnualIncreasePickerSheet({
    required this.currentPercentage,
    required this.currentType,
    required this.onPercentageChanged,
    required this.onTypeChanged,
  });

  @override
  State<_AnnualIncreasePickerSheet> createState() =>
      _AnnualIncreasePickerSheetState();
}

class _AnnualIncreasePickerSheetState
    extends State<_AnnualIncreasePickerSheet> {
  late AnnualIncreaseType _selectedType;
  late double _selectedPercentage;
  late TextEditingController _customController;

  final List<double> _fixedPercentages = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentType;
    _selectedPercentage = widget.currentPercentage;
    _customController = TextEditingController(
      text: widget.currentPercentage.toString(),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // شريط التحكم للتبديل بين نسبة ثابتة ومخصص
          SmallSegmentedControl(
            firstOption: ArabicStrings.fixedPercentage,
            secondOption: ArabicStrings.custom,
            selectedIndex:
                _selectedType == AnnualIncreaseType.fixedPercentage ? 0 : 1,
            onChanged: (index) {
              setState(() {
                _selectedType = index == 0
                    ? AnnualIncreaseType.fixedPercentage
                    : AnnualIncreaseType.custom;
              });
              widget.onTypeChanged(_selectedType);
            },
          ),
          const SizedBox(height: 16),

          // محتوى حسب النوع المحدد
          if (_selectedType == AnnualIncreaseType.fixedPercentage)
            _buildFixedPercentagePicker()
          else
            _buildCustomInput(),
        ],
      ),
    );
  }

  Widget _buildFixedPercentagePicker() {
    return SizedBox(
      height: 200,
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(
          initialItem: _fixedPercentages.indexOf(
            _selectedPercentage.roundToDouble(),
          ).clamp(0, _fixedPercentages.length - 1),
        ),
        onSelectedItemChanged: (index) {
          _selectedPercentage = _fixedPercentages[index];
          widget.onPercentageChanged(_selectedPercentage);
        },
        children: _fixedPercentages.map((p) {
          return Center(
            child: Text(
              '${p.toInt()}%',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        controller: _customController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          hintText: '0.0',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          suffixText: '%',
          suffixStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
          ),
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          final number = double.tryParse(value);
          if (number != null) {
            widget.onPercentageChanged(number);
          }
        },
      ),
    );
  }
}

/// حقل البونص السنوي (عدد الرواتب)
/// Bonus Salaries Field
class _BonusSalariesField extends StatelessWidget {
  final int bonusSalaries;
  final ValueChanged<int> onChanged;

  const _BonusSalariesField({
    required this.bonusSalaries,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InputRowContainer(
      label: ArabicStrings.annualBonus,
      showBorder: false,
      child: GestureDetector(
        onTap: () => _showBonusPicker(context),
        child: Row(
          children: [
            Text(
              bonusSalaries == 0
                  ? ArabicStrings.numberOfSalaries
                  : '$bonusSalaries',
              style: bonusSalaries == 0
                  ? AppTextStyles.secondaryLabel
                  : AppTextStyles.normalValue,
            ),
          ],
        ),
      ),
    );
  }

  void _showBonusPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 40,
          scrollController: FixedExtentScrollController(
            initialItem: bonusSalaries,
          ),
          onSelectedItemChanged: onChanged,
          children: List.generate(13, (index) {
            return Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// حاوية صف الإدخال
/// Input Row Container
class _InputRowContainer extends StatelessWidget {
  final String label;
  final Widget child;
  final bool showBorder;

  const _InputRowContainer({
    required this.label,
    required this.child,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: AppColors.borderColor.withOpacity(0.3),
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // حقل الإدخال على اليسار
          Expanded(child: child),
          const SizedBox(width: 16),
          // العنوان على اليمين
          Text(
            label,
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }
}
