class Activity {
  final int id;
  final int myActivityId;
  final String name;
  final int status;
  final String title;
  final String description;
  final String location;
  final String startDate;
  final String endDate;
  final String imageUrl;
  final int userId;
  final int clientId;
  final String activityType;
  final double budgetTotal;

  Activity({
    required this.id,
    required this.myActivityId,
    required this.name,
    required this.status,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.userId,
    required this.clientId,
    required this.activityType,
    required this.budgetTotal,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      myActivityId: int.tryParse(json['myActivityId']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      userId: int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      clientId: int.tryParse(json['clientId']?.toString() ?? '0') ?? 0,
      activityType: json['activityType']?.toString() ?? '',
      budgetTotal: double.tryParse(json['budgetTotal']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'myActivityId': myActivityId,
      'name': name,
      'status': status,
      'title': title,
      'description': description,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'imageUrl': imageUrl,
      'userId': userId,
      'clientId': clientId,
      'activityType': activityType,
      'budgetTotal': budgetTotal,
    };
  }

  Activity copyWith({
    int? id,
    int? myActivityId,
    String? name,
    int? status,
    String? title,
    String? description,
    String? location,
    String? startDate,
    String? endDate,
    String? imageUrl,
    int? userId,
    int? clientId,
    String? activityType,
    double? budgetTotal,
  }) {
    return Activity(
      id: id ?? this.id,
      myActivityId: myActivityId ?? this.myActivityId,
      name: name ?? this.name,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      activityType: activityType ?? this.activityType,
      budgetTotal: budgetTotal ?? this.budgetTotal,
    );
  }
}
