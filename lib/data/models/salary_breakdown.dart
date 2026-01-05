/// نموذج تفاصيل الراتب - Salary Breakdown Model
///
/// يحتوي على جميع مكونات الراتب المحسوبة
/// Contains all calculated salary components


/// نموذج تفاصيل الراتب
/// Salary Breakdown Model
///
/// يمثل النتائج النهائية لحساب الراتب بما في ذلك
/// جميع البدلات والخصومات
class SalaryBreakdown {
  /// الراتب الأساسي
  /// Basic salary
  final double basicSalary;

  /// بدل السكن
  /// Housing allowance
  final double housingAllowance;

  /// بدل المواصلات
  /// Transportation allowance
  final double transportationAllowance;

  /// إجمالي الراتب
  /// Total/Gross salary
  final double totalSalary;

  /// خصم التأمينات الاجتماعية
  /// GOSI insurance deduction
  final double insuranceDeduction;

  /// صافي الراتب
  /// Net salary
  final double netSalary;

  /// صافي الدخل السنوي
  /// Annual net income
  final double annualNetIncome;

  /// الزيادة على إجمالي الراتب
  /// Increase on total salary
  final double totalSalaryIncrease;

  /// الزيادة على صافي الراتب
  /// Increase on net salary
  final double netSalaryIncrease;

  /// إجمالي الراتب بعد الزيادة
  /// Total salary after increase
  final double totalSalaryAfterIncrease;

  /// صافي الراتب بعد الزيادة
  /// Net salary after increase
  final double netSalaryAfterIncrease;

  /// الراتب الأساسي بعد الزيادة
  /// Basic salary after increase
  final double basicSalaryAfterIncrease;

  /// بدل السكن بعد الزيادة
  /// Housing allowance after increase
  final double housingAllowanceAfterIncrease;

  /// بدل المواصلات بعد الزيادة
  /// Transportation allowance after increase
  final double transportationAllowanceAfterIncrease;

  /// خصم التأمينات بعد الزيادة
  /// Insurance deduction after increase
  final double insuranceDeductionAfterIncrease;

  /// المُنشئ
  /// Constructor
  const SalaryBreakdown({
    required this.basicSalary,
    required this.housingAllowance,
    required this.transportationAllowance,
    required this.totalSalary,
    required this.insuranceDeduction,
    required this.netSalary,
    required this.annualNetIncome,
    this.totalSalaryIncrease = 0.0,
    this.netSalaryIncrease = 0.0,
    this.totalSalaryAfterIncrease = 0.0,
    this.netSalaryAfterIncrease = 0.0,
    this.basicSalaryAfterIncrease = 0.0,
    this.housingAllowanceAfterIncrease = 0.0,
    this.transportationAllowanceAfterIncrease = 0.0,
    this.insuranceDeductionAfterIncrease = 0.0,
  });

  /// هل توجد زيادة سنوية؟
  /// Is there an annual increase?
  bool get hasAnnualIncrease => totalSalaryIncrease > 0;

  /// نسبة خصم التأمينات من الراتب
  /// Insurance deduction percentage from salary
  double get insuranceDeductionPercentage {
    if (totalSalary == 0) return 0;
    return (insuranceDeduction / totalSalary) * 100;
  }

  /// إنشاء نسخة فارغة
  /// Create an empty breakdown
  static const SalaryBreakdown empty = SalaryBreakdown(
    basicSalary: 0,
    housingAllowance: 0,
    transportationAllowance: 0,
    totalSalary: 0,
    insuranceDeduction: 0,
    netSalary: 0,
    annualNetIncome: 0,
  );

  /// إنشاء نسخة جديدة مع تعديل بعض القيم
  /// Create a copy with modified values
  SalaryBreakdown copyWith({
    double? basicSalary,
    double? housingAllowance,
    double? transportationAllowance,
    double? totalSalary,
    double? insuranceDeduction,
    double? netSalary,
    double? annualNetIncome,
    double? totalSalaryIncrease,
    double? netSalaryIncrease,
    double? totalSalaryAfterIncrease,
    double? netSalaryAfterIncrease,
    double? basicSalaryAfterIncrease,
    double? housingAllowanceAfterIncrease,
    double? transportationAllowanceAfterIncrease,
    double? insuranceDeductionAfterIncrease,
  }) {
    return SalaryBreakdown(
      basicSalary: basicSalary ?? this.basicSalary,
      housingAllowance: housingAllowance ?? this.housingAllowance,
      transportationAllowance:
          transportationAllowance ?? this.transportationAllowance,
      totalSalary: totalSalary ?? this.totalSalary,
      insuranceDeduction: insuranceDeduction ?? this.insuranceDeduction,
      netSalary: netSalary ?? this.netSalary,
      annualNetIncome: annualNetIncome ?? this.annualNetIncome,
      totalSalaryIncrease: totalSalaryIncrease ?? this.totalSalaryIncrease,
      netSalaryIncrease: netSalaryIncrease ?? this.netSalaryIncrease,
      totalSalaryAfterIncrease:
          totalSalaryAfterIncrease ?? this.totalSalaryAfterIncrease,
      netSalaryAfterIncrease:
          netSalaryAfterIncrease ?? this.netSalaryAfterIncrease,
      basicSalaryAfterIncrease:
          basicSalaryAfterIncrease ?? this.basicSalaryAfterIncrease,
      housingAllowanceAfterIncrease:
          housingAllowanceAfterIncrease ?? this.housingAllowanceAfterIncrease,
      transportationAllowanceAfterIncrease:
          transportationAllowanceAfterIncrease ??
              this.transportationAllowanceAfterIncrease,
      insuranceDeductionAfterIncrease:
          insuranceDeductionAfterIncrease ?? this.insuranceDeductionAfterIncrease,
    );
  }

  @override
  String toString() {
    return 'SalaryBreakdown(basicSalary: $basicSalary, totalSalary: $totalSalary, '
        'netSalary: $netSalary, insuranceDeduction: $insuranceDeduction)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SalaryBreakdown &&
        other.basicSalary == basicSalary &&
        other.housingAllowance == housingAllowance &&
        other.transportationAllowance == transportationAllowance &&
        other.totalSalary == totalSalary &&
        other.insuranceDeduction == insuranceDeduction &&
        other.netSalary == netSalary &&
        other.annualNetIncome == annualNetIncome;
  }

  @override
  int get hashCode {
    return Object.hash(
      basicSalary,
      housingAllowance,
      transportationAllowance,
      totalSalary,
      insuranceDeduction,
      netSalary,
      annualNetIncome,
    );
  }
}
