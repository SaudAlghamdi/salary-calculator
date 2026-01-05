import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/commitment.dart';

/// صف الإلتزام المالي - Commitment Row Widget
///
/// يعرض إلتزام مالي واحد مع أيقونة ومبلغ
/// مع دعم التفعيل/التعطيل والسحب للحذف

/// صف الإلتزام
/// Commitment Row
class CommitmentRow extends StatelessWidget {
  /// الإلتزام
  final Commitment commitment;

  /// عند النقر
  final VoidCallback? onTap;

  /// عند التفعيل/التعطيل
  final VoidCallback? onToggle;

  /// عند الحذف
  final VoidCallback? onDelete;

  /// هل يظهر الحد السفلي
  final bool showBorder;

  /// المُنشئ
  const CommitmentRow({
    super.key,
    required this.commitment,
    this.onTap,
    this.onToggle,
    this.onDelete,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final isActive = commitment.isActive;

    return Dismissible(
      key: Key(commitment.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: AppColors.textRed,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: const Text(
              'حذف الإلتزام',
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: Text(
              'هل تريد حذف "${commitment.name}"؟',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  ArabicStrings.delete,
                  style: const TextStyle(color: AppColors.textRed),
                ),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) => onDelete?.call(),
      child: InkWell(
        onTap: onTap,
        onLongPress: onToggle,
        child: Container(
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
            children: [
              // المبلغ على اليسار
              Text(
                '${formatter.format(commitment.amount)} ${ArabicStrings.sar}',
                style: TextStyle(
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.ltr,
              ),
              const Spacer(),
              // الاسم والأيقونة على اليمين
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    commitment.name,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isActive ? Icons.description_outlined : Icons.block,
                    color: isActive
                        ? AppColors.textSecondary
                        : AppColors.textSecondary.withOpacity(0.5),
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// شريط المجموع الكلي
/// Total Bar Widget
class CommitmentsTotalBar extends StatelessWidget {
  /// المجموع الشهري
  final double totalMonthly;

  /// المُنشئ
  const CommitmentsTotalBar({
    super.key,
    required this.totalMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // المبلغ والدورة على اليسار
          Row(
            children: [
              Text(
                '(${ArabicStrings.monthly})',
                style: const TextStyle(
                  color: AppColors.textRed,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${formatter.format(totalMonthly)} ${ArabicStrings.sar}',
                style: const TextStyle(
                  color: AppColors.textRed,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
          // العنوان على اليمين
          const Text(
            ArabicStrings.totalCommitments,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
