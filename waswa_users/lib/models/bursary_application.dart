class BursaryApplication {
  final int? id;
  final String childName;
  final String school;
  final double parentIncome;
  final String status;
  final DateTime applicationDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final int? userId; // Reference to the user who submitted the application

  BursaryApplication({
    this.id,
    required this.childName,
    required this.school,
    required this.parentIncome,
    this.status = 'pending',
    required this.applicationDate,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.userId,
  });

  factory BursaryApplication.fromJson(Map<String, dynamic> json) {
    return BursaryApplication(
      id: json['id'],
      childName: json['childName'],
      school: json['school'],
      parentIncome: json['parentIncome'].toDouble(),
      status: json['status'] ?? 'pending',
      applicationDate: DateTime.parse(json['applicationDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      notes: json['notes'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childName': childName,
      'school': school,
      'parentIncome': parentIncome,
      'status': status,
      'applicationDate': applicationDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
      'userId': userId,
    };
  }

  BursaryApplication copyWith({
    int? id,
    String? childName,
    String? school,
    double? parentIncome,
    String? status,
    DateTime? applicationDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    int? userId,
  }) {
    return BursaryApplication(
      id: id ?? this.id,
      childName: childName ?? this.childName,
      school: school ?? this.school,
      parentIncome: parentIncome ?? this.parentIncome,
      status: status ?? this.status,
      applicationDate: applicationDate ?? this.applicationDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
    );
  }
}
