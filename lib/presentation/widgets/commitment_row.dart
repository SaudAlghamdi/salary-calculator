import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/commitment.dart';

/// صف الإلتزام المالي - Commitment Row Widget
///
/// يعرض إلتزام مالي واحد مع أيقونة ومبلغ
/// مع دعم التفعيل/التعطيل والسحب للحذف والتعديل

/// صف الإلتزام
/// Commitment Row
class CommitmentRow extends StatefulWidget {
  /// الإلتزام
  final Commitment commitment;

  /// عند النقر
  final VoidCallback? onTap;

  /// عند التفعيل/التعطيل
  final VoidCallback? onToggle;

  /// عند الحذف
  final VoidCallback? onDelete;

  /// عند التعديل
  final VoidCallback? onEdit;

  /// هل يظهر الحد السفلي
  final bool showBorder;

  /// المُنشئ
  const CommitmentRow({
    super.key,
    required this.commitment,
    this.onTap,
    this.onToggle,
    this.onDelete,
    this.onEdit,
    this.showBorder = true,
  });

  @override
  State<CommitmentRow> createState() => _CommitmentRowState();
}

class _CommitmentRowState extends State<CommitmentRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.5, 0),
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
    setState(() {
      _isRevealed = !_isRevealed;
      if (_isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _closeReveal() {
    if (_isRevealed) {
      setState(() {
        _isRevealed = false;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final isActive = widget.commitment.isActive;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          // Swipe left (negative velocity in RTL context)
          if (details.primaryVelocity! < -200) {
            _toggleReveal();
          }
          // Swipe right (positive velocity)
          else if (details.primaryVelocity! > 200) {
            _closeReveal();
          }
        }
      },
      onTap: () {
        if (_isRevealed) {
          _closeReveal();
        } else {
          widget.onTap?.call();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: widget.showBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.3),
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Stack(
          children: [
            // الخلفية مع الأزرار
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // زر الحذف
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _closeReveal();
                        _showDeleteConfirmation(context);
                      },
                      child: Container(
                        color: AppColors.textRed,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ArabicStrings.delete,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // زر التعديل
                  InkWell(
                    onTap: () {
                      _closeReveal();
                      widget.onEdit?.call();
                    },
                    child: Container(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ArabicStrings.edit,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // زر التفعيل/التعطيل
                  InkWell(
                    onTap: () {
                      _closeReveal();
                      widget.onToggle?.call();
                    },
                    child: Container(
                      color: isActive
                          ? AppColors.textSecondary.withOpacity(0.5)
                          : AppColors.textGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isActive
                                ? ArabicStrings.disable
                                : ArabicStrings.enable,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isActive ? Icons.block : Icons.check_circle_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // المحتوى الرئيسي (يتحرك)
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                color: AppColors.cardBackground,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // المبلغ على اليسار
                    Text(
                      '${formatter.format(widget.commitment.amount)} ${ArabicStrings.sar}',
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
                          widget.commitment.name,
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
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'حذف الإلتزام',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'هل تريد حذف "${widget.commitment.name}"؟',
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
    );

    if (confirmed == true) {
      widget.onDelete?.call();
    }
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
