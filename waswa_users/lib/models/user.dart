class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;
  final int status;
  
  // Essential fields for registration
  final String? nationalId;
  final String? city;
  final String? state;
  final String? country;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
    required this.status,
    this.nationalId,
    this.city,
    this.state,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'] ?? '', // Server doesn't return password for security
      role: json['role'] ?? 'USER',
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      photoUrl: json['photoUrl'],
      status: json['status'] ?? 1,
      nationalId: json['nationalId'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'photoUrl': photoUrl,
      'status': status,
      'nationalId': nationalId,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,
    int? status,
    String? nationalId,
    String? city,
    String? state,
    String? country,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      nationalId: nationalId ?? this.nationalId,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }
}
