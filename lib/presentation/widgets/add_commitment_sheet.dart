import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/commitment.dart';

/// ورقة إضافة إلتزام جديد - Add Commitment Bottom Sheet
///
/// تتيح للمستخدم إدخال بيانات إلتزام مالي جديد:
/// - الاسم
/// - النوع
/// - الدورة
/// - المبلغ

/// ورقة إضافة إلتزام
/// Add Commitment Sheet
class AddCommitmentSheet extends StatefulWidget {
  /// إلتزام للتعديل (اختياري)
  final Commitment? editCommitment;

  /// المُنشئ
  const AddCommitmentSheet({
    super.key,
    this.editCommitment,
  });

  @override
  State<AddCommitmentSheet> createState() => _AddCommitmentSheetState();
}

class _AddCommitmentSheetState extends State<AddCommitmentSheet> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  CommitmentType _selectedType = CommitmentType.services;
  CommitmentCycle _selectedCycle = CommitmentCycle.monthly;

  bool get _isEditing => widget.editCommitment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController = TextEditingController(text: widget.editCommitment!.name);
      _amountController = TextEditingController(
        text: widget.editCommitment!.amount.toString(),
      );
      _selectedType = widget.editCommitment!.type;
      _selectedCycle = widget.editCommitment!.cycle;
    } else {
      _nameController = TextEditingController();
      _amountController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // المقبض
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // العنوان
              Center(
                child: Text(
                  _isEditing ? ArabicStrings.edit : ArabicStrings.newCommitment,
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              const SizedBox(height: 24),

              // قسم تفاصيل الإلتزام
              Text(
                ArabicStrings.commitmentDetails,
                style: AppTextStyles.secondaryLabel,
              ),
              const SizedBox(height: 8),

              // بطاقة التفاصيل
              Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // حقل الاسم
                    _buildInputRow(
                      label: ArabicStrings.commitmentName,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: ArabicStrings.enterName,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),

                    _buildDivider(),

                    // منتقي النوع
                    _buildInputRow(
                      label: ArabicStrings.commitmentType,
                      child: _buildDropdownButton<CommitmentType>(
                        value: _selectedType,
                        items: CommitmentType.values,
                        getLabel: (type) => type.arabicName,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        },
                      ),
                    ),

                    _buildDivider(),

                    // منتقي الدورة
                    _buildInputRow(
                      label: ArabicStrings.commitmentCycle,
                      child: _buildDropdownButton<CommitmentCycle>(
                        value: _selectedCycle,
                        items: CommitmentCycle.values,
                        getLabel: (cycle) => cycle.arabicName,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCycle = value);
                          }
                        },
                      ),
                      showBorder: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // قسم القيمة
              Text(
                ArabicStrings.commitmentValue,
                style: AppTextStyles.secondaryLabel,
              ),
              const SizedBox(height: 8),

              // بطاقة القيمة
              Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // منتقي العملة
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.segmentedControlBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.unfold_more,
                            color: AppColors.textGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            ArabicStrings.sar,
                            style: TextStyle(
                              color: AppColors.textGreen,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // حقل المبلغ
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          color: AppColors.textGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00 ${ArabicStrings.saudiRiyal}',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.5),
                            fontSize: 24,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave ? _onSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canSave
                        ? AppColors.inputBackground
                        : AppColors.inputBackground.withOpacity(0.5),
                    foregroundColor: _canSave
                        ? AppColors.textGreen
                        : AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    ArabicStrings.save,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canSave {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text);
    return name.isNotEmpty && amount != null && amount > 0;
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;

    Navigator.of(context).pop({
      'name': name,
      'type': _selectedType,
      'cycle': _selectedCycle,
      'amount': amount,
      if (_isEditing) 'id': widget.editCommitment!.id,
    });
  }

  Widget _buildInputRow({
    required String label,
    required Widget child,
    bool showBorder = true,
  }) {
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
          Expanded(child: child),
          const SizedBox(width: 16),
          Text(
            label,
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      thickness: 0.5,
      color: AppColors.borderColor.withOpacity(0.3),
    );
  }

  Widget _buildDropdownButton<T>({
    required T value,
    required List<T> items,
    required String Function(T) getLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onChanged,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      position: PopupMenuPosition.under,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.unfold_more,
            color: AppColors.textGreen,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            getLabel(value),
            style: const TextStyle(
              color: AppColors.textGreen,
              fontSize: 14,
            ),
          ),
        ],
      ),
      itemBuilder: (context) => items.map((item) {
        final isSelected = item == value;
        return PopupMenuItem<T>(
          value: item,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                getLabel(item),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
