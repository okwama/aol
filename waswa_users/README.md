# JLW Foundation Flutter App

A Flutter application for the JLW Foundation, serving Kitale Region Constituency citizens with educational support, emergency services, and community events.

## 🎨 Design Theme

- **Background**: Clean white background
- **Accents**: Dark blue color scheme for elegance
- **Typography**: Poppins font family
- **Target Users**: Kitale Region Constituency residents only

## ✨ Features

### 🔐 Authentication
- **Restricted Login/Signup**: Mock validation for Kitale region residents
- **Region Lock**: ID number must contain "Kitale" for access
- **Demo Credentials**:
  - Email: `user1@kitale.com`
  - Password: `123`
  - ID: `Kitale123456`

### 📚 Bursary Application
- **Educational Support**: Apply for student bursaries
- **Form Fields**: Child's name, school selection, parent income
- **Status Tracking**: View application status (Pending/Approved)
- **Mock Data**: Predefined applications for testing

### 🚑 Ambulance Service
- **Emergency Requests**: Request emergency medical assistance
- **Location Selection**: Kitale region locations dropdown
- **Emergency Types**: Medical, accident, childbirth, etc.
- **ETA Tracking**: Mock response times and status updates

### 📅 Event Calendar
- **Community Events**: View upcoming events and activities
- **Calendar Integration**: Using `table_calendar` package
- **Event Details**: Location, time, and descriptions
- **Mock Events**: Health camps, deadlines, community meetings

### 🔔 Notifications
- **Hardcoded Alerts**: Bursary approvals, event reminders
- **Status Indicators**: Read/unread notification states
- **Toast Messages**: Success confirmations and alerts

### 👤 Profile Management
- **User Information**: Mock user details display
- **Statistics**: Application and request counts
- **Settings**: Notification preferences, privacy, help
- **Logout**: Session management with SharedPreferences

## 🛠️ Technical Stack

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  shared_preferences: ^2.2.2      # Local storage
  table_calendar: ^3.0.9          # Calendar widget
  fluttertoast: ^8.2.4           # Toast notifications
  intl: ^0.18.1                  # Date formatting
  cached_network_image: ^3.3.0   # Image optimization
```

### Architecture
- **Mock Data**: All data is hardcoded for demonstration
- **State Management**: Local state with setState
- **Navigation**: Named routes and MaterialPageRoute
- **Storage**: SharedPreferences for login persistence
- **UI Components**: Custom widgets and Material Design

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd jlw_foundation
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   └── mock_data.dart        # Mock data models
├── screens/
│   ├── splash_screen.dart    # Loading screen
│   ├── login_screen.dart     # Authentication
│   ├── home_screen.dart      # Dashboard
│   ├── bursary_screen.dart   # Bursary applications
│   ├── ambulance_screen.dart # Emergency services
│   ├── events_screen.dart    # Calendar & events
│   ├── notifications_screen.dart # Notifications
│   └── profile_screen.dart   # User profile
├── utils/
│   └── theme.dart           # App theme configuration
└── widgets/
    ├── dashboard_card.dart   # Service cards
    └── notification_badge.dart # Notification indicator
```

## 🎯 Mock Data

### Sample Users
- `user1@kitale.com` / `123` - John Kitale Resident
- `user2@kitale.com` / `123` - Mary Kitale Citizen
- `admin@kitale.com` / `admin123` - Kitale Administrator

### Sample Events
- Health Camp (Nov 20, 2023)
- Bursary Deadline (Nov 30, 2023)
- Community Meeting (Dec 5, 2023)
- Youth Workshop (Dec 10, 2023)

### Sample Applications
- Mary Kim - Kitale Primary (Approved)
- Peter Ochieng - Kitale Secondary (Pending)
- Sarah Wanjiku - Kitale Girls High (Approved)

## 🔧 Customization

### Adding New Features
1. Create new screen in `lib/screens/`
2. Add mock data to `lib/models/mock_data.dart`
3. Update navigation in `lib/main.dart`
4. Add route to home screen if needed

### Theme Customization
- Colors: Modify `lib/utils/theme.dart`
- Fonts: Update `pubspec.yaml` and theme
- Icons: Replace Material Icons as needed

### Mock Data Updates
- Edit `MockData` class in `lib/models/mock_data.dart`
- Add new model classes for new features
- Update existing screens to use new data

## 📱 Performance Optimizations

### Implemented
- **Loading States**: Skeleton UI and progress indicators
- **Image Optimization**: Cached network images
- **State Management**: Efficient setState usage
- **Navigation**: Optimized route management

### Recommended
- **Pagination**: For large data sets
- **Caching**: API response caching
- **Lazy Loading**: For lists and grids
- **Debouncing**: Search operations

## 🧪 Testing

### Manual Testing
1. **Login Flow**: Test with demo credentials
2. **Region Validation**: Try non-Kitale ID numbers
3. **Form Submissions**: Test all application forms
4. **Navigation**: Verify all screen transitions
5. **Data Display**: Check mock data rendering

### Demo Scenarios
- Apply for bursary → Check status
- Request ambulance → View ETA
- Browse events → Select dates
- Check notifications → Mark as read
- Update profile → Logout/login

## 📄 License

This project is for demonstration purposes. All data is mock and should not be used in production.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📞 Support

For questions or issues:
- Check the demo credentials
- Verify Flutter installation
- Review console logs for errors
- Ensure all dependencies are installed

---

**Note**: This is a mock application for demonstration purposes. All data is hardcoded and no real API calls are made. 