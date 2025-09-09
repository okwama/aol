enum AmbulanceRequestStatus {
  pending,
  approved,
  rejected,
  assigned,
  completed,
  cancelled,
}

class AmbulanceRequest {
  final int id;
  final int userId;
  final int? ambulanceId;
  final String purpose;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final String? address;
  final AmbulanceRequestStatus status;
  final int? assignedBy;
  final DateTime? assignedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AmbulanceRequest({
    required this.id,
    required this.userId,
    this.ambulanceId,
    required this.purpose,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.notes,
    this.latitude,
    this.longitude,
    this.address,
    required this.status,
    this.assignedBy,
    this.assignedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AmbulanceRequest.fromJson(Map<String, dynamic> json) {
    return AmbulanceRequest(
      id: json['id'],
      userId: json['userId'],
      ambulanceId: json['ambulanceId'],
      purpose: json['purpose'],
      destination: json['destination'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      notes: json['notes'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      address: json['address'],
      status: AmbulanceRequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AmbulanceRequestStatus.pending,
      ),
      assignedBy: json['assignedBy'],
      assignedAt: json['assignedAt'] != null 
          ? DateTime.parse(json['assignedAt']) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'ambulanceId': ambulanceId,
      'purpose': purpose,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status.toString().split('.').last,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AmbulanceRequest copyWith({
    int? id,
    int? userId,
    int? ambulanceId,
    String? purpose,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    double? latitude,
    double? longitude,
    String? address,
    AmbulanceRequestStatus? status,
    int? assignedBy,
    DateTime? assignedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AmbulanceRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ambulanceId: ambulanceId ?? this.ambulanceId,
      purpose: purpose ?? this.purpose,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
