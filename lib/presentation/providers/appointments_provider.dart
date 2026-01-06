import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

/// نموذج موعد الراتب - Salary Appointment Model
class SalaryAppointment {
  final String title;
  final int dayOfMonth;
  final DateTime nextDate;
  final int daysRemaining;

  SalaryAppointment({
    required this.title,
    required this.dayOfMonth,
    required this.nextDate,
    required this.daysRemaining,
  });
}

/// مزود حالة المواعيد - Appointments State Provider
///
/// يدير هذا المزود:
/// - مواعيد الراتب والتقاعد
/// - حساب الأيام المتبقية
class AppointmentsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  int _salaryDay = 25;
  int _privatePensionDay = 1;
  int _publicPensionDay = 25;

  AppointmentsProvider(this._prefs) {
    _loadSettings();
  }

  // Getters
  int get salaryDay => _salaryDay;
  int get privatePensionDay => _privatePensionDay;
  int get publicPensionDay => _publicPensionDay;

  /// قائمة المواعيد
  List<SalaryAppointment> get appointments {
    final now = DateTime.now();
    return [
      _createAppointment(ArabicStrings.salary, _salaryDay, now),
      _createAppointment(ArabicStrings.privatePension, _privatePensionDay, now),
      _createAppointment(ArabicStrings.publicPension, _publicPensionDay, now),
    ];
  }

  SalaryAppointment _createAppointment(String title, int day, DateTime now) {
    DateTime nextDate = DateTime(now.year, now.month, day);

    // إذا مر الموعد هذا الشهر، انتقل للشهر القادم
    if (nextDate.isBefore(now) || nextDate.isAtSameMomentAs(now)) {
      if (now.month == 12) {
        nextDate = DateTime(now.year + 1, 1, day);
      } else {
        nextDate = DateTime(now.year, now.month + 1, day);
      }
    }

    final daysRemaining = nextDate.difference(now).inDays;

    return SalaryAppointment(
      title: title,
      dayOfMonth: day,
      nextDate: nextDate,
      daysRemaining: daysRemaining,
    );
  }

  void _loadSettings() {
    _salaryDay = _prefs.getInt(StorageKeys.salaryDay) ?? 25;
    _privatePensionDay = _prefs.getInt(StorageKeys.privatePensionDay) ?? 1;
    _publicPensionDay = _prefs.getInt(StorageKeys.publicPensionDay) ?? 25;
    notifyListeners();
  }

  Future<void> updateSalaryDay(int day) async {
    _salaryDay = day.clamp(1, 28);
    await _prefs.setInt(StorageKeys.salaryDay, _salaryDay);
    notifyListeners();
  }

  Future<void> updatePrivatePensionDay(int day) async {
    _privatePensionDay = day.clamp(1, 28);
    await _prefs.setInt(StorageKeys.privatePensionDay, _privatePensionDay);
    notifyListeners();
  }

  Future<void> updatePublicPensionDay(int day) async {
    _publicPensionDay = day.clamp(1, 28);
    await _prefs.setInt(StorageKeys.publicPensionDay, _publicPensionDay);
    notifyListeners();
  }

  /// تحديث يوم موعد معين
  Future<void> updateAppointmentDay(int index, int day) async {
    switch (index) {
      case 0:
        await updateSalaryDay(day);
        break;
      case 1:
        await updatePrivatePensionDay(day);
        break;
      case 2:
        await updatePublicPensionDay(day);
        break;
    }
  }

  /// الحصول على يوم الموعد حسب الفهرس
  int getDayByIndex(int index) {
    switch (index) {
      case 0:
        return _salaryDay;
      case 1:
        return _privatePensionDay;
      case 2:
        return _publicPensionDay;
      default:
        return 25;
    }
  }
}
