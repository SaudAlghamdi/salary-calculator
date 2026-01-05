/// ثوابت التطبيق - Application Constants
///
/// يحتوي هذا الملف على جميع الثوابت المستخدمة في التطبيق
/// بما في ذلك نسب التأمينات الاجتماعية (GOSI) والحدود المالية

/// ثوابت التأمينات الاجتماعية السعودية (GOSI)
/// Saudi GOSI Constants
///
/// المصدر: المؤسسة العامة للتأمينات الاجتماعية
/// Source: General Organization for Social Insurance
class GosiConstants {
  GosiConstants._();

  /// نسبة خصم التأمينات من الموظف (9.75%)
  /// Employee contribution rate for social insurance
  static const double employeeContributionRate = 0.0975;

  /// نسبة مساهمة صاحب العمل (11.75%)
  /// Employer contribution rate for social insurance
  static const double employerContributionRate = 0.1175;

  /// الحد الأقصى للراتب الخاضع للتأمينات (45,000 ريال)
  /// Maximum salary subject to GOSI deduction
  static const double maxInsurableSalary = 45000.0;

  /// الحد الأدنى للراتب الخاضع للتأمينات (1,500 ريال)
  /// Minimum salary subject to GOSI deduction
  static const double minInsurableSalary = 1500.0;
}

/// ثوابت البدلات الافتراضية
/// Default Allowance Constants
class AllowanceConstants {
  AllowanceConstants._();

  /// نسبة بدل السكن الافتراضية (25% من الراتب الأساسي)
  /// Default housing allowance percentage
  static const double defaultHousingAllowancePercentage = 0.25;

  /// نسبة بدل المواصلات الافتراضية (10% من الراتب الأساسي)
  /// Default transportation allowance percentage
  static const double defaultTransportationAllowancePercentage = 0.10;
}

/// ثوابت النصوص العربية
/// Arabic Text Constants
class ArabicStrings {
  ArabicStrings._();

  // عناوين التطبيق - App Titles
  static const String appTitle = 'حاسبة الراتب';
  static const String calculator = 'الحاسبة';
  static const String settings = 'الإعدادات';
  static const String appointments = 'المواعيد';
  static const String commitments = 'الإلتزامات';

  // المدخلات - Inputs
  static const String inputs = 'المدخلات';
  static const String totalSalary = 'إجمالي الراتب';
  static const String basicSalary = 'الراتب الأساسي';
  static const String annualIncrease = 'الزيادة السنوية';
  static const String annualBonus = 'البونص السنوي';
  static const String numberOfSalaries = 'عدد الرواتب';

  // تفاصيل الراتب - Salary Details
  static const String salaryDetails = 'تفاصيل الراتب';
  static const String housingAllowance = 'بدل السكن';
  static const String transportationAllowance = 'بدل المواصلات';
  static const String insuranceDeduction = 'خصم التأمينات';
  static const String netSalary = 'صافي الراتب';

  // تفاصيل إضافية - Additional Details
  static const String additionalDetails = 'تفاصيل إضافية';
  static const String annualNetIncome = 'صافي الدخل سنويًا';
  static const String annualIncreaseOn = 'الزيادة السنوية على';
  static const String applyNewSalary = 'إعتماد الراتب الجديد في المدخلات';

  // الإعدادات - Settings
  static const String allowancesSettings = 'إعدادات البدلات';
  static const String housingAllowancePercentage = 'نسبة بدل السكن';
  static const String transportationAllowancePercentage = 'نسبة بدل المواصلات';
  static const String customizeMessage = 'يمكنك تخصيص البدلات والبونص السنوي من الإعدادات.';

  // أنماط الإدخال - Input Modes
  static const String fixedPercentage = 'نسبة ثابتة';
  static const String custom = 'مخصص';

  // العملة - Currency
  static const String sar = 'ريال';
  static const String sarSymbol = 'ر.س.';
  static const String saudiRiyal = 'ريال سعودي';

  // الإلتزامات المالية - Financial Commitments
  static const String financialCommitments = 'الإلتزامات المالية';
  static const String monthlyCommitments = 'الإلتزامات الشهرية';
  static const String disabledCommitments = 'الإلتزامات المعطلة';
  static const String totalCommitments = 'مجموع الإلتزامات';
  static const String monthly = 'شهريًا';
  static const String newCommitment = 'التزام مالي جديد';
  static const String commitmentDetails = 'الإلتزام المالي';
  static const String commitmentName = 'الإسم';
  static const String enterName = 'ادخل الاسم';
  static const String commitmentType = 'نوع الإلتزام المالي';
  static const String commitmentCycle = 'دورة الإلتزام المالي';
  static const String commitmentValue = 'قيمة الإلتزام المالي';
  static const String save = 'حفظ';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String enable = 'تفعيل';
  static const String disable = 'تعطيل';
}

/// مفاتيح التخزين المحلي
/// Local Storage Keys
class StorageKeys {
  StorageKeys._();

  static const String housingAllowancePercentage = 'housing_allowance_percentage';
  static const String transportationAllowancePercentage = 'transportation_allowance_percentage';
  static const String lastTotalSalary = 'last_total_salary';
  static const String lastAnnualIncrease = 'last_annual_increase';
  static const String lastBonusSalaries = 'last_bonus_salaries';
  static const String inputMode = 'input_mode';
  static const String commitments = 'commitments';
}
