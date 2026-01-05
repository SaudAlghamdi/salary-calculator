import 'package:flutter/foundation.dart';

import '../../data/models/salary_breakdown.dart';
import '../../data/models/salary_input.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/gosi_calculator_service.dart';

/// مزود حالة الراتب - Salary State Provider
///
/// يدير هذا المزود حالة حاسبة الراتب بما في ذلك:
/// - مدخلات المستخدم
/// - نتائج الحسابات
/// - الإعدادات
///
/// يتبع نمط Single Source of Truth


/// مزود حالة الراتب
/// Salary Provider
///
/// يدير جميع عمليات حساب الراتب وحالة التطبيق
/// باستخدام ChangeNotifier للإشعار بالتغييرات
class SalaryProvider extends ChangeNotifier {
  /// خدمة حساب الراتب
  final ISalaryCalculatorService _calculatorService;

  /// مستودع الإعدادات
  final ISettingsRepository _settingsRepository;

  /// مدخلات الراتب الحالية
  SalaryInput _currentInput;

  /// تفاصيل الراتب المحسوبة
  SalaryBreakdown _breakdown;

  /// حالة التحميل
  bool _isLoading = false;

  /// المُنشئ
  /// Constructor
  SalaryProvider({
    required ISalaryCalculatorService calculatorService,
    required ISettingsRepository settingsRepository,
    SalaryInput? initialInput,
  })  : _calculatorService = calculatorService,
        _settingsRepository = settingsRepository,
        _currentInput = initialInput ?? SalaryInput.defaultInput,
        _breakdown = SalaryBreakdown.empty {
    // حساب القيم الأولية
    _calculateSalary();
  }

  // =====================
  // Getters - القيم الحالية
  // =====================

  /// مدخلات الراتب الحالية
  SalaryInput get currentInput => _currentInput;

  /// تفاصيل الراتب المحسوبة
  SalaryBreakdown get breakdown => _breakdown;

  /// حالة التحميل
  bool get isLoading => _isLoading;

  /// طريقة الإدخال الحالية
  SalaryInputMode get inputMode => _currentInput.inputMode;

  /// الراتب المدخل
  double get inputSalary => _currentInput.inputSalary;

  /// نسبة الزيادة السنوية
  double get annualIncreasePercentage => _currentInput.annualIncreasePercentage;

  /// نوع الزيادة السنوية
  AnnualIncreaseType get annualIncreaseType => _currentInput.annualIncreaseType;

  /// عدد رواتب البونص
  int get bonusSalaries => _currentInput.bonusSalaries;

  /// نسبة بدل السكن
  double get housingAllowancePercentage =>
      _currentInput.housingAllowancePercentage;

  /// نسبة بدل المواصلات
  double get transportationAllowancePercentage =>
      _currentInput.transportationAllowancePercentage;

  // =====================
  // تحميل البيانات المحفوظة
  // Load Saved Data
  // =====================

  /// تحميل الإعدادات المحفوظة
  /// Load saved settings
  Future<void> loadSavedSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final housingPercentage =
          await _settingsRepository.getHousingAllowancePercentage();
      final transportationPercentage =
          await _settingsRepository.getTransportationAllowancePercentage();
      final lastSalary = await _settingsRepository.getLastTotalSalary();
      final lastIncrease = await _settingsRepository.getLastAnnualIncrease();
      final lastBonus = await _settingsRepository.getLastBonusSalaries();

      _currentInput = _currentInput.copyWith(
        inputSalary: lastSalary,
        housingAllowancePercentage: housingPercentage,
        transportationAllowancePercentage: transportationPercentage,
        annualIncreasePercentage: lastIncrease,
        bonusSalaries: lastBonus,
      );

      _calculateSalary();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================
  // تحديث المدخلات
  // Update Inputs
  // =====================

  /// تحديث طريقة الإدخال (إجمالي أو أساسي)
  /// Update input mode (total or basic)
  void updateInputMode(SalaryInputMode mode) {
    if (_currentInput.inputMode == mode) return;

    // تحويل القيمة عند تغيير الوضع
    double newInputSalary;
    if (mode == SalaryInputMode.totalSalary) {
      // تحويل من أساسي إلى إجمالي
      newInputSalary = _breakdown.totalSalary;
    } else {
      // تحويل من إجمالي إلى أساسي
      newInputSalary = _breakdown.basicSalary;
    }

    _currentInput = _currentInput.copyWith(
      inputMode: mode,
      inputSalary: newInputSalary,
    );
    _calculateSalary();
    notifyListeners();
  }

  /// تحديث قيمة الراتب المدخل
  /// Update input salary value
  void updateInputSalary(double salary) {
    if (salary <= 0) return;

    _currentInput = _currentInput.copyWith(inputSalary: salary);
    _calculateSalary();
    _settingsRepository.saveLastTotalSalary(
      inputMode == SalaryInputMode.totalSalary
          ? salary
          : _breakdown.totalSalary,
    );
    notifyListeners();
  }

  /// تحديث نسبة الزيادة السنوية
  /// Update annual increase percentage
  void updateAnnualIncrease(double percentage, {AnnualIncreaseType? type}) {
    _currentInput = _currentInput.copyWith(
      annualIncreasePercentage: percentage,
      annualIncreaseType: type ?? _currentInput.annualIncreaseType,
    );
    _calculateSalary();
    _settingsRepository.saveLastAnnualIncrease(percentage);
    notifyListeners();
  }

  /// تحديث نوع الزيادة السنوية
  /// Update annual increase type
  void updateAnnualIncreaseType(AnnualIncreaseType type) {
    _currentInput = _currentInput.copyWith(annualIncreaseType: type);
    notifyListeners();
  }

  /// تحديث عدد رواتب البونص
  /// Update bonus salaries count
  void updateBonusSalaries(int count) {
    if (count < 0) return;

    _currentInput = _currentInput.copyWith(bonusSalaries: count);
    _calculateSalary();
    _settingsRepository.saveLastBonusSalaries(count);
    notifyListeners();
  }

  /// تحديث نسبة بدل السكن
  /// Update housing allowance percentage
  void updateHousingAllowancePercentage(double percentage) {
    if (percentage < 0 || percentage > 1) return;

    _currentInput =
        _currentInput.copyWith(housingAllowancePercentage: percentage);
    _calculateSalary();
    _settingsRepository.saveHousingAllowancePercentage(percentage);
    notifyListeners();
  }

  /// تحديث نسبة بدل المواصلات
  /// Update transportation allowance percentage
  void updateTransportationAllowancePercentage(double percentage) {
    if (percentage < 0 || percentage > 1) return;

    _currentInput =
        _currentInput.copyWith(transportationAllowancePercentage: percentage);
    _calculateSalary();
    _settingsRepository.saveTransportationAllowancePercentage(percentage);
    notifyListeners();
  }

  /// اعتماد الراتب الجديد بعد الزيادة
  /// Apply new salary after increase
  void applyNewSalaryAfterIncrease() {
    if (!_breakdown.hasAnnualIncrease) return;

    _currentInput = _currentInput.copyWith(
      inputSalary: inputMode == SalaryInputMode.totalSalary
          ? _breakdown.totalSalaryAfterIncrease
          : _breakdown.basicSalaryAfterIncrease,
      annualIncreasePercentage: 0,
    );
    _calculateSalary();
    _settingsRepository.saveLastTotalSalary(_breakdown.totalSalary);
    _settingsRepository.saveLastAnnualIncrease(0);
    notifyListeners();
  }

  // =====================
  // الحسابات الداخلية
  // Internal Calculations
  // =====================

  /// حساب تفاصيل الراتب
  /// Calculate salary breakdown
  void _calculateSalary() {
    _breakdown = _calculatorService.calculateSalary(_currentInput);
  }

  /// إعادة تعيين جميع القيم إلى الافتراضية
  /// Reset all values to default
  void resetToDefaults() {
    _currentInput = SalaryInput.defaultInput;
    _calculateSalary();
    notifyListeners();
  }
}
