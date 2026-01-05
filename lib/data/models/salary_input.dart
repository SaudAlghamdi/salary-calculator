/// نموذج بيانات مدخلات الراتب - Salary Input Model
///
/// يمثل هذا النموذج جميع المدخلات المطلوبة لحساب الراتب
/// This model represents all inputs required for salary calculation


/// طريقة إدخال الراتب
/// Salary Input Mode
enum SalaryInputMode {
  /// إدخال إجمالي الراتب وحساب الأساسي
  /// Input total salary and calculate basic
  totalSalary,

  /// إدخال الراتب الأساسي وحساب الإجمالي
  /// Input basic salary and calculate total
  basicSalary,
}

/// نوع الزيادة السنوية
/// Annual Increase Type
enum AnnualIncreaseType {
  /// نسبة ثابتة محددة مسبقًا
  /// Fixed predefined percentage
  fixedPercentage,

  /// نسبة مخصصة يدخلها المستخدم
  /// Custom percentage entered by user
  custom,
}

/// نموذج مدخلات الراتب
/// Salary Input Model
///
/// يحتوي على جميع البيانات المدخلة من المستخدم لحساب الراتب
class SalaryInput {
  /// الراتب المدخل (إجمالي أو أساسي حسب الوضع)
  /// Input salary (total or basic depending on mode)
  final double inputSalary;

  /// طريقة الإدخال (إجمالي أو أساسي)
  /// Input mode (total or basic)
  final SalaryInputMode inputMode;

  /// نسبة الزيادة السنوية (0-100)
  /// Annual increase percentage (0-100)
  final double annualIncreasePercentage;

  /// نوع الزيادة السنوية
  /// Annual increase type
  final AnnualIncreaseType annualIncreaseType;

  /// عدد رواتب البونص السنوي
  /// Number of bonus salaries
  final int bonusSalaries;

  /// نسبة بدل السكن (من الراتب الأساسي)
  /// Housing allowance percentage (of basic salary)
  final double housingAllowancePercentage;

  /// نسبة بدل المواصلات (من الراتب الأساسي)
  /// Transportation allowance percentage (of basic salary)
  final double transportationAllowancePercentage;

  /// المُنشئ
  /// Constructor
  const SalaryInput({
    required this.inputSalary,
    this.inputMode = SalaryInputMode.totalSalary,
    this.annualIncreasePercentage = 0.0,
    this.annualIncreaseType = AnnualIncreaseType.fixedPercentage,
    this.bonusSalaries = 0,
    this.housingAllowancePercentage = 0.25,
    this.transportationAllowancePercentage = 0.10,
  });

  /// إنشاء نسخة جديدة مع تعديل بعض القيم
  /// Create a copy with modified values
  SalaryInput copyWith({
    double? inputSalary,
    SalaryInputMode? inputMode,
    double? annualIncreasePercentage,
    AnnualIncreaseType? annualIncreaseType,
    int? bonusSalaries,
    double? housingAllowancePercentage,
    double? transportationAllowancePercentage,
  }) {
    return SalaryInput(
      inputSalary: inputSalary ?? this.inputSalary,
      inputMode: inputMode ?? this.inputMode,
      annualIncreasePercentage:
          annualIncreasePercentage ?? this.annualIncreasePercentage,
      annualIncreaseType: annualIncreaseType ?? this.annualIncreaseType,
      bonusSalaries: bonusSalaries ?? this.bonusSalaries,
      housingAllowancePercentage:
          housingAllowancePercentage ?? this.housingAllowancePercentage,
      transportationAllowancePercentage:
          transportationAllowancePercentage ?? this.transportationAllowancePercentage,
    );
  }

  /// القيم الافتراضية
  /// Default values
  static const SalaryInput defaultInput = SalaryInput(
    inputSalary: 10000.0,
    inputMode: SalaryInputMode.totalSalary,
    annualIncreasePercentage: 0.0,
    annualIncreaseType: AnnualIncreaseType.fixedPercentage,
    bonusSalaries: 0,
    housingAllowancePercentage: 0.25,
    transportationAllowancePercentage: 0.10,
  );

  @override
  String toString() {
    return 'SalaryInput(inputSalary: $inputSalary, inputMode: $inputMode, '
        'annualIncreasePercentage: $annualIncreasePercentage, '
        'bonusSalaries: $bonusSalaries)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SalaryInput &&
        other.inputSalary == inputSalary &&
        other.inputMode == inputMode &&
        other.annualIncreasePercentage == annualIncreasePercentage &&
        other.annualIncreaseType == annualIncreaseType &&
        other.bonusSalaries == bonusSalaries &&
        other.housingAllowancePercentage == housingAllowancePercentage &&
        other.transportationAllowancePercentage == transportationAllowancePercentage;
  }

  @override
  int get hashCode {
    return Object.hash(
      inputSalary,
      inputMode,
      annualIncreasePercentage,
      annualIncreaseType,
      bonusSalaries,
      housingAllowancePercentage,
      transportationAllowancePercentage,
    );
  }
}
