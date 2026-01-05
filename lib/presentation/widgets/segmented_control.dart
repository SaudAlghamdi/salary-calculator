import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// شريط التحكم المقسم - Segmented Control Widget
///
/// مكون واجهة مستخدم للتبديل بين خيارين
/// مشابه لـ UISegmentedControl في iOS


/// شريط التحكم المقسم
/// Segmented Control
///
/// يعرض خيارين قابلين للتبديل بينهما
/// مع تأثيرات انتقال سلسة
class SegmentedControl extends StatelessWidget {
  /// الخيار الأول
  final String firstOption;

  /// الخيار الثاني
  final String secondOption;

  /// الخيار المحدد (0 أو 1)
  final int selectedIndex;

  /// دالة الاستجابة عند تغيير الخيار
  final ValueChanged<int> onChanged;

  /// المُنشئ
  const SegmentedControl({
    super.key,
    required this.firstOption,
    required this.secondOption,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.segmentedControlBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // الخيار الثاني (على اليمين في RTL)
          Expanded(
            child: _SegmentButton(
              text: secondOption,
              isSelected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
          // الخيار الأول (على اليسار في RTL)
          Expanded(
            child: _SegmentButton(
              text: firstOption,
              isSelected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
        ],
      ),
    );
  }
}

/// زر القسم الفردي
/// Single Segment Button
class _SegmentButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedTab : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

/// شريط تحكم مقسم صغير للنوافذ المنبثقة
/// Small Segmented Control for Popups
class SmallSegmentedControl extends StatelessWidget {
  /// الخيار الأول
  final String firstOption;

  /// الخيار الثاني
  final String secondOption;

  /// الخيار المحدد (0 أو 1)
  final int selectedIndex;

  /// دالة الاستجابة عند تغيير الخيار
  final ValueChanged<int> onChanged;

  /// المُنشئ
  const SmallSegmentedControl({
    super.key,
    required this.firstOption,
    required this.secondOption,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.segmentedControlBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallSegmentButton(
            text: firstOption,
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _SmallSegmentButton(
            text: secondOption,
            isSelected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

/// زر القسم الصغير
/// Small Segment Button
class _SmallSegmentButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SmallSegmentButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedTab : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
