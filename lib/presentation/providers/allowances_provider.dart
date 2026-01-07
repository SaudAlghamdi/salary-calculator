import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

/// نموذج البدل - Allowance Model
///
/// يحتوي على:
/// - المعرف الفريد
/// - الاسم
/// - القيمة (نسبة أو مبلغ)
/// - نوع القيمة (نسبة أو ثابت)
class Allowance {
  /// المعرف الفريد
  final String id;

  /// اسم البدل
  final String name;

  /// القيمة (نسبة من الراتب الأساسي أو مبلغ ثابت)
  final double value;

  /// هل القيمة نسبة مئوية؟
  final bool isPercentage;

  /// هل البدل أساسي (لا يمكن حذفه)؟
  final bool isDefault;

  /// المُنشئ
  const Allowance({
    required this.id,
    required this.name,
    required this.value,
    this.isPercentage = true,
    this.isDefault = false,
  });

  /// إنشاء نسخة معدلة
  Allowance copyWith({
    String? id,
    String? name,
    double? value,
    bool? isPercentage,
    bool? isDefault,
  }) {
    return Allowance(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      isPercentage: isPercentage ?? this.isPercentage,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// التحويل من JSON
  factory Allowance.fromJson(Map<String, dynamic> json) {
    return Allowance(
      id: json['id'] as String,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      isPercentage: json['isPercentage'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'isPercentage': isPercentage,
      'isDefault': isDefault,
    };
  }
}

/// مزود حالة البدلات - Allowances Provider
///
/// يدير البدلات المخصصة مع:
/// - إضافة بدلات جديدة
/// - تعديل البدلات
/// - حذف البدلات
/// - حفظ واسترجاع البدلات
class AllowancesProvider extends ChangeNotifier {
  /// التخزين المحلي
  final SharedPreferences _prefs;

  /// مفتاح التخزين
  static const String _storageKey = 'custom_allowances';

  /// قائمة البدلات
  List<Allowance> _allowances = [];

  /// المُنشئ
  AllowancesProvider(this._prefs) {
    _loadAllowances();
  }

  /// الحصول على قائمة البدلات
  List<Allowance> get allowances => List.unmodifiable(_allowances);

  /// الحصول على البدلات الافتراضية فقط
  List<Allowance> get defaultAllowances =>
      _allowances.where((a) => a.isDefault).toList();

  /// الحصول على البدلات المخصصة فقط
  List<Allowance> get customAllowances =>
      _allowances.where((a) => !a.isDefault).toList();

  /// تحميل البدلات من التخزين
  void _loadAllowances() {
    final savedData = _prefs.getString(_storageKey);

    if (savedData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(savedData);
        _allowances = jsonList
            .map((json) => Allowance.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        _initializeDefaultAllowances();
      }
    } else {
      _initializeDefaultAllowances();
    }

    notifyListeners();
  }

  /// تهيئة البدلات الافتراضية
  void _initializeDefaultAllowances() {
    _allowances = [
      Allowance(
        id: 'housing',
        name: ArabicStrings.housingAllowance,
        value: 0.25, // 25%
        isPercentage: true,
        isDefault: true,
      ),
      Allowance(
        id: 'transportation',
        name: ArabicStrings.transportationAllowance,
        value: 0.10, // 10%
        isPercentage: true,
        isDefault: true,
      ),
    ];
    _saveAllowances();
  }

  /// حفظ البدلات إلى التخزين
  Future<void> _saveAllowances() async {
    final jsonList = _allowances.map((a) => a.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// إضافة بدل جديد
  Future<void> addAllowance({
    required String name,
    double value = 0.0,
    bool isPercentage = true,
  }) async {
    final newAllowance = Allowance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      value: value,
      isPercentage: isPercentage,
      isDefault: false,
    );

    _allowances.add(newAllowance);
    await _saveAllowances();
    notifyListeners();
  }

  /// تحديث قيمة بدل
  Future<void> updateAllowanceValue(String id, double value) async {
    final index = _allowances.indexWhere((a) => a.id == id);
    if (index != -1) {
      _allowances[index] = _allowances[index].copyWith(value: value);
      await _saveAllowances();
      notifyListeners();
    }
  }

  /// تحديث نوع قيمة بدل (نسبة أو ثابت)
  Future<void> updateAllowanceType(String id, bool isPercentage) async {
    final index = _allowances.indexWhere((a) => a.id == id);
    if (index != -1) {
      _allowances[index] = _allowances[index].copyWith(isPercentage: isPercentage);
      await _saveAllowances();
      notifyListeners();
    }
  }

  /// تحديث بدل بالكامل
  Future<void> updateAllowance(String id, {
    String? name,
    double? value,
    bool? isPercentage,
  }) async {
    final index = _allowances.indexWhere((a) => a.id == id);
    if (index != -1) {
      _allowances[index] = _allowances[index].copyWith(
        name: name,
        value: value,
        isPercentage: isPercentage,
      );
      await _saveAllowances();
      notifyListeners();
    }
  }

  /// حذف بدل
  Future<void> deleteAllowance(String id) async {
    final allowance = _allowances.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception('Allowance not found'),
    );

    // لا يمكن حذف البدلات الافتراضية
    if (allowance.isDefault) {
      return;
    }

    _allowances.removeWhere((a) => a.id == id);
    await _saveAllowances();
    notifyListeners();
  }

  /// الحصول على بدل بواسطة المعرف
  Allowance? getAllowanceById(String id) {
    try {
      return _allowances.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// حساب إجمالي البدلات بناءً على الراتب الأساسي
  double calculateTotalAllowances(double basicSalary) {
    double total = 0;

    for (final allowance in _allowances) {
      if (allowance.isPercentage) {
        total += basicSalary * allowance.value;
      } else {
        total += allowance.value;
      }
    }

    return total;
  }

  /// إعادة تعيين البدلات إلى الافتراضية
  Future<void> resetToDefaults() async {
    _initializeDefaultAllowances();
    notifyListeners();
  }
}
