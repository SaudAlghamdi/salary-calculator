import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

/// مستودع الإعدادات - Settings Repository
///
/// يوفر هذا المستودع واجهة للتخزين والاسترجاع
/// للإعدادات المحفوظة محليًا على الجهاز
///
/// This repository provides an interface for storing and retrieving
/// settings saved locally on the device


/// واجهة مستودع الإعدادات
/// Settings Repository Interface
///
/// تعريف العقد الأساسي لمستودع الإعدادات (Dependency Inversion Principle)
abstract class ISettingsRepository {
  /// حفظ نسبة بدل السكن
  Future<void> saveHousingAllowancePercentage(double percentage);

  /// استرجاع نسبة بدل السكن
  Future<double> getHousingAllowancePercentage();

  /// حفظ نسبة بدل المواصلات
  Future<void> saveTransportationAllowancePercentage(double percentage);

  /// استرجاع نسبة بدل المواصلات
  Future<double> getTransportationAllowancePercentage();

  /// حفظ آخر راتب مدخل
  Future<void> saveLastTotalSalary(double salary);

  /// استرجاع آخر راتب مدخل
  Future<double> getLastTotalSalary();

  /// حفظ نسبة الزيادة السنوية
  Future<void> saveLastAnnualIncrease(double percentage);

  /// استرجاع نسبة الزيادة السنوية
  Future<double> getLastAnnualIncrease();

  /// حفظ عدد رواتب البونص
  Future<void> saveLastBonusSalaries(int count);

  /// استرجاع عدد رواتب البونص
  Future<int> getLastBonusSalaries();
}

/// تطبيق مستودع الإعدادات باستخدام SharedPreferences
/// Settings Repository Implementation using SharedPreferences
class SettingsRepository implements ISettingsRepository {
  /// الكائن SharedPreferences
  final SharedPreferences _prefs;

  /// المُنشئ
  /// Constructor
  SettingsRepository(this._prefs);

  /// إنشاء كائن المستودع بشكل غير متزامن
  /// Create repository instance asynchronously
  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }

  @override
  Future<void> saveHousingAllowancePercentage(double percentage) async {
    await _prefs.setDouble(StorageKeys.housingAllowancePercentage, percentage);
  }

  @override
  Future<double> getHousingAllowancePercentage() async {
    return _prefs.getDouble(StorageKeys.housingAllowancePercentage) ??
        AllowanceConstants.defaultHousingAllowancePercentage;
  }

  @override
  Future<void> saveTransportationAllowancePercentage(double percentage) async {
    await _prefs.setDouble(
        StorageKeys.transportationAllowancePercentage, percentage);
  }

  @override
  Future<double> getTransportationAllowancePercentage() async {
    return _prefs.getDouble(StorageKeys.transportationAllowancePercentage) ??
        AllowanceConstants.defaultTransportationAllowancePercentage;
  }

  @override
  Future<void> saveLastTotalSalary(double salary) async {
    await _prefs.setDouble(StorageKeys.lastTotalSalary, salary);
  }

  @override
  Future<double> getLastTotalSalary() async {
    return _prefs.getDouble(StorageKeys.lastTotalSalary) ?? 10000.0;
  }

  @override
  Future<void> saveLastAnnualIncrease(double percentage) async {
    await _prefs.setDouble(StorageKeys.lastAnnualIncrease, percentage);
  }

  @override
  Future<double> getLastAnnualIncrease() async {
    return _prefs.getDouble(StorageKeys.lastAnnualIncrease) ?? 0.0;
  }

  @override
  Future<void> saveLastBonusSalaries(int count) async {
    await _prefs.setInt(StorageKeys.lastBonusSalaries, count);
  }

  @override
  Future<int> getLastBonusSalaries() async {
    return _prefs.getInt(StorageKeys.lastBonusSalaries) ?? 0;
  }
}
