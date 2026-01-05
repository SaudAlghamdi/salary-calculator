import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';
import '../../data/models/commitment.dart';

/// أنواع الترتيب - Sort Types
enum CommitmentSortType {
  newest,     // الأحدث
  oldest,     // الأقدم
  priceHighest, // السعر (الأعلى)
  priceLowest,  // السعر (الأدنى)
}

/// مزود حالة الإلتزامات المالية - Commitments State Provider
///
/// يدير هذا المزود:
/// - قائمة الإلتزامات المالية
/// - إضافة وحذف وتعديل الإلتزامات
/// - حساب المجموع الشهري

/// مزود الإلتزامات
/// Commitments Provider
class CommitmentsProvider extends ChangeNotifier {
  /// التخزين المحلي
  final SharedPreferences _prefs;

  /// قائمة الإلتزامات
  List<Commitment> _commitments = [];

  /// نوع الترتيب الحالي
  CommitmentSortType _sortType = CommitmentSortType.newest;

  /// ترتيب القائمة (تصاعدي/تنازلي)
  bool _sortAscending = true;

  /// المُنشئ
  CommitmentsProvider(this._prefs) {
    _loadCommitments();
  }

  // =====================
  // Getters - القيم الحالية
  // =====================

  /// جميع الإلتزامات
  List<Commitment> get commitments => List.unmodifiable(_commitments);

  /// الإلتزامات المفعّلة
  List<Commitment> get activeCommitments =>
      _commitments.where((c) => c.isActive).toList();

  /// الإلتزامات المعطّلة
  List<Commitment> get disabledCommitments =>
      _commitments.where((c) => !c.isActive).toList();

  /// مجموع الإلتزامات الشهرية (للمفعّلة فقط)
  double get totalMonthlyCommitments {
    return activeCommitments.fold(0.0, (sum, c) => sum + c.monthlyAmount);
  }

  /// ترتيب القائمة
  bool get sortAscending => _sortAscending;

  /// نوع الترتيب الحالي
  CommitmentSortType get sortType => _sortType;

  // =====================
  // تحميل وحفظ البيانات
  // =====================

  /// تحميل الإلتزامات من التخزين المحلي
  void _loadCommitments() {
    final jsonString = _prefs.getString(StorageKeys.commitments);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _commitments = jsonList
            .map((item) => Commitment.fromJson(item as Map<String, dynamic>))
            .toList();
        _sortCommitments();
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading commitments: $e');
        _commitments = [];
      }
    }
  }

  /// حفظ الإلتزامات في التخزين المحلي
  Future<void> _saveCommitments() async {
    final jsonList = _commitments.map((c) => c.toJson()).toList();
    await _prefs.setString(StorageKeys.commitments, json.encode(jsonList));
  }

  // =====================
  // إدارة الإلتزامات
  // =====================

  /// إضافة إلتزام جديد
  Future<void> addCommitment({
    required String name,
    required CommitmentType type,
    required CommitmentCycle cycle,
    required double amount,
  }) async {
    final commitment = Commitment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      cycle: cycle,
      amount: amount,
      isActive: true,
      createdAt: DateTime.now(),
    );

    _commitments.add(commitment);
    _sortCommitments();
    await _saveCommitments();
    notifyListeners();
  }

  /// تحديث إلتزام
  Future<void> updateCommitment(Commitment commitment) async {
    final index = _commitments.indexWhere((c) => c.id == commitment.id);
    if (index != -1) {
      _commitments[index] = commitment;
      _sortCommitments();
      await _saveCommitments();
      notifyListeners();
    }
  }

  /// حذف إلتزام
  Future<void> deleteCommitment(String id) async {
    _commitments.removeWhere((c) => c.id == id);
    await _saveCommitments();
    notifyListeners();
  }

  /// تفعيل/تعطيل إلتزام
  Future<void> toggleCommitmentStatus(String id) async {
    final index = _commitments.indexWhere((c) => c.id == id);
    if (index != -1) {
      _commitments[index] = _commitments[index].copyWith(
        isActive: !_commitments[index].isActive,
      );
      await _saveCommitments();
      notifyListeners();
    }
  }

  /// تبديل ترتيب القائمة
  void toggleSort() {
    _sortAscending = !_sortAscending;
    _sortCommitments();
    notifyListeners();
  }

  /// تغيير نوع الترتيب
  void setSortType(CommitmentSortType type) {
    _sortType = type;
    _sortCommitments();
    notifyListeners();
  }

  /// ترتيب الإلتزامات
  void _sortCommitments() {
    _commitments.sort((a, b) {
      switch (_sortType) {
        case CommitmentSortType.newest:
          return b.createdAt.compareTo(a.createdAt);
        case CommitmentSortType.oldest:
          return a.createdAt.compareTo(b.createdAt);
        case CommitmentSortType.priceHighest:
          return b.monthlyAmount.compareTo(a.monthlyAmount);
        case CommitmentSortType.priceLowest:
          return a.monthlyAmount.compareTo(b.monthlyAmount);
      }
    });
  }

  /// حذف جميع الإلتزامات
  Future<void> clearAllCommitments() async {
    _commitments.clear();
    await _saveCommitments();
    notifyListeners();
  }
}
