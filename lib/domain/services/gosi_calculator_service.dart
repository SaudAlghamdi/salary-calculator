import '../../core/constants.dart';
import '../../data/models/salary_breakdown.dart';
import '../../data/models/salary_input.dart';

/// خدمة حساب التأمينات الاجتماعية (GOSI)
/// GOSI Calculator Service
///
/// تقوم هذه الخدمة بحساب تفاصيل الراتب بما في ذلك:
/// - تحليل الراتب إلى أساسي وبدلات
/// - حساب خصم التأمينات الاجتماعية
/// - حساب صافي الراتب
/// - حساب الزيادة السنوية
///
/// المعادلات المستخدمة:
/// - الراتب الأساسي = إجمالي الراتب / (1 + نسبة بدل السكن + نسبة بدل المواصلات)
/// - خصم التأمينات = (الراتب الأساسي + بدل السكن) × 9.75%
/// - صافي الراتب = إجمالي الراتب - خصم التأمينات
///
/// This service calculates salary details including:
/// - Breaking down salary into basic and allowances
/// - Calculating GOSI insurance deduction
/// - Calculating net salary
/// - Calculating annual increase


/// واجهة خدمة حساب الرواتب
/// Salary Calculator Service Interface
///
/// تعريف العقد الأساسي لخدمات حساب الرواتب (Interface Segregation Principle)
abstract class ISalaryCalculatorService {
  /// حساب تفاصيل الراتب
  /// Calculate salary breakdown
  SalaryBreakdown calculateSalary(SalaryInput input);

  /// حساب خصم التأمينات
  /// Calculate GOSI deduction
  double calculateGosiDeduction(double basicSalary, double housingAllowance);

  /// تحويل إجمالي الراتب إلى راتب أساسي
  /// Convert total salary to basic salary
  double totalToBasicSalary(
    double totalSalary,
    double housingPercentage,
    double transportationPercentage,
  );

  /// تحويل الراتب الأساسي إلى إجمالي
  /// Convert basic salary to total salary
  double basicToTotalSalary(
    double basicSalary,
    double housingPercentage,
    double transportationPercentage,
  );
}

/// خدمة حساب التأمينات الاجتماعية السعودية
/// Saudi GOSI Calculator Service
///
/// تطبيق خدمة حساب الرواتب وفق نظام التأمينات الاجتماعية السعودي
/// Implementation of salary calculation service according to Saudi GOSI system
class GosiCalculatorService implements ISalaryCalculatorService {
  /// المُنشئ
  /// Constructor
  const GosiCalculatorService();

  /// حساب تفاصيل الراتب الكاملة
  /// Calculate complete salary breakdown
  ///
  /// [input] مدخلات الراتب من المستخدم
  /// Returns [SalaryBreakdown] containing all salary components
  ///
  /// المعادلات:
  /// 1. إذا كان المدخل إجمالي الراتب:
  ///    - الأساسي = الإجمالي / (1 + نسبة السكن + نسبة المواصلات)
  /// 2. إذا كان المدخل الراتب الأساسي:
  ///    - الإجمالي = الأساسي × (1 + نسبة السكن + نسبة المواصلات)
  /// 3. خصم التأمينات = (الأساسي + السكن) × 9.75%
  /// 4. الصافي = الإجمالي - خصم التأمينات
  @override
  SalaryBreakdown calculateSalary(SalaryInput input) {
    // حساب الراتب الأساسي والإجمالي حسب طريقة الإدخال
    double basicSalary;
    double totalSalary;

    if (input.inputMode == SalaryInputMode.totalSalary) {
      totalSalary = input.inputSalary;
      basicSalary = totalToBasicSalary(
        totalSalary,
        input.housingAllowancePercentage,
        input.transportationAllowancePercentage,
      );
    } else {
      basicSalary = input.inputSalary;
      totalSalary = basicToTotalSalary(
        basicSalary,
        input.housingAllowancePercentage,
        input.transportationAllowancePercentage,
      );
    }

    // حساب البدلات
    final housingAllowance = basicSalary * input.housingAllowancePercentage;
    final transportationAllowance =
        basicSalary * input.transportationAllowancePercentage;

    // حساب خصم التأمينات
    final insuranceDeduction = calculateGosiDeduction(
      basicSalary,
      housingAllowance,
    );

    // حساب صافي الراتب
    final netSalary = totalSalary - insuranceDeduction;

    // حساب صافي الدخل السنوي (12 شهر + البونص)
    final annualNetIncome =
        (netSalary * 12) + (netSalary * input.bonusSalaries);

    // حساب الزيادة السنوية إذا كانت موجودة
    double totalSalaryIncrease = 0;
    double netSalaryIncrease = 0;
    double totalSalaryAfterIncrease = totalSalary;
    double netSalaryAfterIncrease = netSalary;
    double basicSalaryAfterIncrease = basicSalary;
    double housingAllowanceAfterIncrease = housingAllowance;
    double transportationAllowanceAfterIncrease = transportationAllowance;
    double insuranceDeductionAfterIncrease = insuranceDeduction;

    if (input.annualIncreasePercentage > 0) {
      // حساب الزيادة كنسبة مئوية من الإجمالي
      final increaseRate = input.annualIncreasePercentage / 100;
      totalSalaryIncrease = totalSalary * increaseRate;
      totalSalaryAfterIncrease = totalSalary + totalSalaryIncrease;

      // إعادة حساب التفاصيل بعد الزيادة
      basicSalaryAfterIncrease = totalToBasicSalary(
        totalSalaryAfterIncrease,
        input.housingAllowancePercentage,
        input.transportationAllowancePercentage,
      );

      housingAllowanceAfterIncrease =
          basicSalaryAfterIncrease * input.housingAllowancePercentage;
      transportationAllowanceAfterIncrease =
          basicSalaryAfterIncrease * input.transportationAllowancePercentage;

      insuranceDeductionAfterIncrease = calculateGosiDeduction(
        basicSalaryAfterIncrease,
        housingAllowanceAfterIncrease,
      );

      netSalaryAfterIncrease =
          totalSalaryAfterIncrease - insuranceDeductionAfterIncrease;
      netSalaryIncrease = netSalaryAfterIncrease - netSalary;
    }

    return SalaryBreakdown(
      basicSalary: _roundToTwoDecimals(basicSalary),
      housingAllowance: _roundToTwoDecimals(housingAllowance),
      transportationAllowance: _roundToTwoDecimals(transportationAllowance),
      totalSalary: _roundToTwoDecimals(totalSalary),
      insuranceDeduction: _roundToTwoDecimals(insuranceDeduction),
      netSalary: _roundToTwoDecimals(netSalary),
      annualNetIncome: _roundToTwoDecimals(annualNetIncome),
      totalSalaryIncrease: _roundToTwoDecimals(totalSalaryIncrease),
      netSalaryIncrease: _roundToTwoDecimals(netSalaryIncrease),
      totalSalaryAfterIncrease: _roundToTwoDecimals(totalSalaryAfterIncrease),
      netSalaryAfterIncrease: _roundToTwoDecimals(netSalaryAfterIncrease),
      basicSalaryAfterIncrease: _roundToTwoDecimals(basicSalaryAfterIncrease),
      housingAllowanceAfterIncrease:
          _roundToTwoDecimals(housingAllowanceAfterIncrease),
      transportationAllowanceAfterIncrease:
          _roundToTwoDecimals(transportationAllowanceAfterIncrease),
      insuranceDeductionAfterIncrease:
          _roundToTwoDecimals(insuranceDeductionAfterIncrease),
    );
  }

  /// حساب خصم التأمينات الاجتماعية (GOSI)
  /// Calculate GOSI social insurance deduction
  ///
  /// الخصم يحتسب على (الراتب الأساسي + بدل السكن) بنسبة 9.75%
  /// مع مراعاة الحد الأقصى 45,000 ريال
  ///
  /// [basicSalary] الراتب الأساسي
  /// [housingAllowance] بدل السكن
  /// Returns the GOSI deduction amount
  @override
  double calculateGosiDeduction(double basicSalary, double housingAllowance) {
    // الراتب الخاضع للتأمينات = الأساسي + بدل السكن
    double insurableSalary = basicSalary + housingAllowance;

    // التأكد من الحد الأقصى (45,000 ريال)
    if (insurableSalary > GosiConstants.maxInsurableSalary) {
      insurableSalary = GosiConstants.maxInsurableSalary;
    }

    // التأكد من الحد الأدنى (1,500 ريال)
    if (insurableSalary < GosiConstants.minInsurableSalary) {
      insurableSalary = GosiConstants.minInsurableSalary;
    }

    // حساب الخصم (9.75%)
    return insurableSalary * GosiConstants.employeeContributionRate;
  }

  /// تحويل إجمالي الراتب إلى الراتب الأساسي
  /// Convert total salary to basic salary
  ///
  /// المعادلة: الأساسي = الإجمالي / (1 + نسبة السكن + نسبة المواصلات)
  ///
  /// [totalSalary] إجمالي الراتب
  /// [housingPercentage] نسبة بدل السكن (مثال: 0.25 = 25%)
  /// [transportationPercentage] نسبة بدل المواصلات (مثال: 0.10 = 10%)
  @override
  double totalToBasicSalary(
    double totalSalary,
    double housingPercentage,
    double transportationPercentage,
  ) {
    final totalPercentage = 1 + housingPercentage + transportationPercentage;
    return totalSalary / totalPercentage;
  }

  /// تحويل الراتب الأساسي إلى إجمالي الراتب
  /// Convert basic salary to total salary
  ///
  /// المعادلة: الإجمالي = الأساسي × (1 + نسبة السكن + نسبة المواصلات)
  ///
  /// [basicSalary] الراتب الأساسي
  /// [housingPercentage] نسبة بدل السكن
  /// [transportationPercentage] نسبة بدل المواصلات
  @override
  double basicToTotalSalary(
    double basicSalary,
    double housingPercentage,
    double transportationPercentage,
  ) {
    final totalPercentage = 1 + housingPercentage + transportationPercentage;
    return basicSalary * totalPercentage;
  }

  /// تقريب الرقم إلى خانتين عشريتين
  /// Round number to two decimal places
  double _roundToTwoDecimals(double value) {
    return (value * 100).round() / 100;
  }
}
