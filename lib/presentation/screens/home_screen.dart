import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import 'appointments_screen.dart';
import 'calculator_screen.dart';
import 'commitments_screen.dart';
import 'settings_screen.dart';

/// الشاشة الرئيسية - Home Screen
///
/// الشاشة الرئيسية التي تحتوي على شريط التنقل السفلي
/// للتبديل بين الشاشات المختلفة:
/// - الحاسبة (الافتراضية)
/// - الإلتزامات
/// - المواعيد
/// - الإعدادات


/// الشاشة الرئيسية
/// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// الفهرس الحالي للشاشة المحددة
  /// يبدأ من الحاسبة (الفهرس 0 من اليمين = 3 من اليسار)
  int _currentIndex = 3;

  /// قائمة الشاشات
  final List<Widget> _screens = const [
    SettingsScreen(),
    AppointmentsScreen(),
    CommitmentsScreen(),
    CalculatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            border: Border(
              top: BorderSide(
                color: AppColors.borderColor.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: ArabicStrings.settings,
                    isSelected: _currentIndex == 0,
                    onTap: () => _onItemTapped(0),
                  ),
                  _NavBarItem(
                    icon: Icons.calendar_today_outlined,
                    selectedIcon: Icons.calendar_today,
                    label: ArabicStrings.appointments,
                    isSelected: _currentIndex == 1,
                    onTap: () => _onItemTapped(1),
                  ),
                  _NavBarItem(
                    icon: Icons.description_outlined,
                    selectedIcon: Icons.description,
                    label: ArabicStrings.commitments,
                    isSelected: _currentIndex == 2,
                    onTap: () => _onItemTapped(2),
                  ),
                  _NavBarItem(
                    icon: Icons.calculate_outlined,
                    selectedIcon: Icons.calculate,
                    label: ArabicStrings.calculator,
                    isSelected: _currentIndex == 3,
                    onTap: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

/// عنصر شريط التنقل
/// Navigation Bar Item
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.inputBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
