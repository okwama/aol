class MockUser {
  final String email;
  final String password;
  final String region;
  final String name;
  final String phone;

  MockUser({
    required this.email,
    required this.password,
    required this.region,
    required this.name,
    required this.phone,
  });
}

class MockBursary {
  final String id;
  final String childName;
  final String school;
  final String parentIncome;
  final String status;
  final String applicationDate;

  MockBursary({
    required this.id,
    required this.childName,
    required this.school,
    required this.parentIncome,
    required this.status,
    required this.applicationDate,
  });
}

class MockEvent {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;
  final String time;

  MockEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.time,
  });
}

class MockAmbulanceRequest {
  final String id;
  final String location;
  final String emergencyType;
  final String status;
  final String eta;
  final String requestDate;

  MockAmbulanceRequest({
    required this.id,
    required this.location,
    required this.emergencyType,
    required this.status,
    required this.eta,
    required this.requestDate,
  });
}

class MockNotification {
  final String id;
  final String title;
  final String message;
  final String date;
  final bool isRead;

  MockNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
  });
}

// Mock Data
class MockData {
  static final List<MockUser> mockUsers = [
    MockUser(
      email: "user1@region.com",
      password: "123",
      region: "Region",
      name: "John Region Resident",
      phone: "+254700123456",
    ),
    MockUser(
      email: "user2@region.com",
      password: "123",
      region: "Region",
      name: "Mary Region Citizen",
      phone: "+254700789012",
    ),
    MockUser(
      email: "admin@region.com",
      password: "admin123",
      region: "Region",
      name: "Region Administrator",
      phone: "+254700345678",
    ),
  ];

  static final List<MockBursary> mockBursaries = [
    MockBursary(
      id: "1",
      childName: "Mary Kim",
      school: "Region Primary School",
      parentIncome: "25000",
      status: "Approved",
      applicationDate: "2023-10-15",
    ),
    MockBursary(
      id: "2",
      childName: "Peter Ochieng",
      school: "Region Secondary School",
      parentIncome: "30000",
      status: "Pending",
      applicationDate: "2023-11-01",
    ),
    MockBursary(
      id: "3",
      childName: "Sarah Wanjiku",
      school: "Region Girls High School",
      parentIncome: "20000",
      status: "Approved",
      applicationDate: "2023-09-20",
    ),
  ];

  static final List<MockEvent> mockEvents = [
    MockEvent(
      id: "1",
      title: "Health Camp",
      date: "2023-11-20",
      location: "Region Town Hall",
      description: "Free health checkup and consultation for all residents",
      time: "09:00 AM",
    ),
    MockEvent(
      id: "2",
      title: "Bursary Application Deadline",
      date: "2023-11-30",
      location: "JLW Foundation Office",
      description: "Last day to submit bursary applications for the year",
      time: "05:00 PM",
    ),
    MockEvent(
      id: "3",
      title: "Community Meeting",
      date: "2025-07-25",
      location: "Region Community Center",
      description: "Monthly community meeting to discuss local issues",
      time: "06:00 PM",
    ),
    MockEvent(
      id: "4",
      title: "Youth Empowerment Workshop",
      date: "2025-07-25",
      location: "Region Youth Center",
      description: "Skills development workshop for young people",
      time: "10:00 AM",
    ),
    MockEvent(
      id: "5",
      title: "Women in Business Forum",
      date: "2025-07-25",
      location: "Region Business Hub",
      description:
          "A soccer championship for the youth of Kitale",
      time: "02:00 PM",
    ),
  ];

  static final List<MockAmbulanceRequest> mockAmbulanceRequests = [
    MockAmbulanceRequest(
      id: "1",
      location: "Region Town Center",
      emergencyType: "Medical Emergency",
      status: "Completed",
      eta: "15 minutes",
      requestDate: "2023-11-15",
    ),
    MockAmbulanceRequest(
      id: "2",
      location: "Region Hospital",
      emergencyType: "Accident",
      status: "In Progress",
      eta: "8 minutes",
      requestDate: "2023-11-18",
    ),
  ];

  static final List<MockNotification> mockNotifications = [
    MockNotification(
      id: "1",
      title: "Bursary Approved",
      message: "Your bursary application for Mary Kim has been approved!",
      date: "2023-11-16",
      isRead: false,
    ),
    MockNotification(
      id: "2",
      title: "Health Camp Reminder",
      message: "Don't forget the free health camp tomorrow at Region Town Hall",
      date: "2023-11-19",
      isRead: true,
    ),
    MockNotification(
      id: "3",
      title: "Ambulance Service",
      message: "Your ambulance request has been confirmed. ETA: 15 minutes",
      date: "2023-11-15",
      isRead: true,
    ),
    MockNotification(
      id: "4",
      title: "Application Deadline",
      message:
          "Bursary application deadline is approaching. Submit by Nov 30th",
      date: "2023-11-25",
      isRead: false,
    ),
  ];

  // Emergency types for ambulance service
  static final List<String> emergencyTypes = [
    "Medical Emergency",
    "Accident",
    "Childbirth",
    "Heart Attack",
    "Stroke",
    "Other",
  ];

  // Locations in Region
  static final List<String> regionLocations = [
    "Region Town Center",
    "Region Hospital",
    "Region Market",
    "Region Bus Station",
    "Region Primary School",
    "Region Secondary School",
    "Region Girls High School",
    "Region Community Center",
    "Region Youth Center",
    "Region Town Hall",
    "Other",
  ];

  // Schools in Region
  static final List<String> regionSchools = [
    "Region Primary School",
    "Region Secondary School",
    "Region Girls High School",
    "Region Boys High School",
    "Region Academy",
    "Region International School",
    "Other",
  ];
}
