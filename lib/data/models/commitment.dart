/// نموذج الإلتزام المالي - Commitment Model
///
/// يمثل هذا النموذج الإلتزامات المالية الشهرية مثل:
/// - الفواتير والخدمات
/// - القروض والأقساط
/// - الإيجارات
/// - وغيرها من الإلتزامات

/// نوع الإلتزام المالي
/// Commitment Type
enum CommitmentType {
  /// خدمات
  services('خدمات'),
  /// قروض
  loans('قروض'),
  /// إيجار
  rent('إيجار'),
  /// رواتب
  salaries('رواتب'),
  /// استثمار
  investment('استثمار'),
  /// التزامات عائلية
  family('التزامات عائلية'),
  /// صحي
  health('صحي'),
  /// تعليم
  education('تعليم'),
  /// ترفيه
  entertainment('ترفيه'),
  /// تقنية
  technology('تقنية'),
  /// تسوق
  shopping('تسوق'),
  /// تنقل
  transportation('تنقل');

  final String arabicName;
  const CommitmentType(this.arabicName);
}

/// دورة الإلتزام المالي
/// Commitment Cycle
enum CommitmentCycle {
  /// اسبوعيًا
  weekly('اسبوعيًا', 4.33),
  /// شهريًا
  monthly('شهريًا', 1.0),
  /// ربع سنوي
  quarterly('ربع سنوي', 0.33),
  /// نصف سنوي
  semiAnnually('نصف سنوي', 0.167),
  /// سنويًا
  yearly('سنويًا', 0.083);

  final String arabicName;
  /// معامل التحويل إلى شهري
  /// Conversion factor to monthly
  final double monthlyFactor;

  const CommitmentCycle(this.arabicName, this.monthlyFactor);
}

/// نموذج الإلتزام المالي
/// Commitment Model
class Commitment {
  /// معرف فريد
  final String id;

  /// اسم الإلتزام
  final String name;

  /// نوع الإلتزام
  final CommitmentType type;

  /// دورة الإلتزام
  final CommitmentCycle cycle;

  /// قيمة الإلتزام
  final double amount;

  /// هل الإلتزام مفعّل؟
  final bool isActive;

  /// تاريخ الإنشاء
  final DateTime createdAt;

  /// المُنشئ
  const Commitment({
    required this.id,
    required this.name,
    required this.type,
    required this.cycle,
    required this.amount,
    this.isActive = true,
    required this.createdAt,
  });

  /// حساب القيمة الشهرية
  /// Calculate monthly amount
  double get monthlyAmount => amount * cycle.monthlyFactor;

  /// إنشاء نسخة جديدة مع تعديل بعض القيم
  /// Create a copy with modified values
  Commitment copyWith({
    String? id,
    String? name,
    CommitmentType? type,
    CommitmentCycle? cycle,
    double? amount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Commitment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      cycle: cycle ?? this.cycle,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// تحويل إلى Map للتخزين
  /// Convert to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'cycle': cycle.index,
      'amount': amount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// إنشاء من Map
  /// Create from Map
  factory Commitment.fromJson(Map<String, dynamic> json) {
    return Commitment(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CommitmentType.values[json['type'] as int],
      cycle: CommitmentCycle.values[json['cycle'] as int],
      amount: (json['amount'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Commitment(id: $id, name: $name, type: ${type.arabicName}, '
        'amount: $amount, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Commitment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
