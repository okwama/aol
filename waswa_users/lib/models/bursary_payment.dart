class BursaryPayment {
  final int id;
  final int studentId;
  final int schoolId;
  final double amount;
  final DateTime datePaid;
  final String? referenceNumber;
  final String? paidBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BursaryPayment({
    required this.id,
    required this.studentId,
    required this.schoolId,
    required this.amount,
    required this.datePaid,
    this.referenceNumber,
    this.paidBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BursaryPayment.fromJson(Map<String, dynamic> json) {
    return BursaryPayment(
      id: json['id'],
      studentId: json['studentId'],
      schoolId: json['schoolId'],
      amount: json['amount'].toDouble(),
      datePaid: DateTime.parse(json['datePaid']),
      referenceNumber: json['referenceNumber'],
      paidBy: json['paidBy'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'schoolId': schoolId,
      'amount': amount,
      'datePaid': datePaid.toIso8601String(),
      'referenceNumber': referenceNumber,
      'paidBy': paidBy,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BursaryPayment copyWith({
    int? id,
    int? studentId,
    int? schoolId,
    double? amount,
    DateTime? datePaid,
    String? referenceNumber,
    String? paidBy,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BursaryPayment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      schoolId: schoolId ?? this.schoolId,
      amount: amount ?? this.amount,
      datePaid: datePaid ?? this.datePaid,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      paidBy: paidBy ?? this.paidBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
