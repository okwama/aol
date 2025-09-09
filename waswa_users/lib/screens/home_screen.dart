import 'package:flutter/material.dart';
import '../di/service_locator.dart';
import '../utils/theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/notification_badge.dart';
import '../models/activity.dart';
import 'bursary_screen.dart';
import 'ambulance_screen.dart';
import 'events_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'event_detail_screen.dart'; // Added import for EventDetailScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _unreadNotifications = 0;
  final GlobalKey _servicesKey = GlobalKey();
  int _currentIndex = 0; // Track current tab index

  // List of screens for bottom navigation
  final List<Widget> _screens = [
    const HomeContent(), // Home content
    const NotificationsScreen(), // Notifications
    const ProfileScreen(), // Profile
  ];

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
    _listenToNotifications();
  }

  void _loadNotificationCount() {
    final notificationService = ServiceLocator().notificationServiceSafe;
    if (notificationService != null) {
      setState(() {
        _unreadNotifications = notificationService.unreadCount;
      });
    }
  }

  void _listenToNotifications() {
    final notificationService = ServiceLocator().notificationServiceSafe;
    if (notificationService != null) {
      notificationService.notificationsStream.listen((notifications) {
        if (mounted) {
          setState(() {
            _unreadNotifications = notificationService.unreadCount;
          });
        }
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      final authService = ServiceLocator().authServiceSafe;
      if (authService != null) {
        await authService.logout();
      }
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Logout error: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: _currentIndex == 0 ? [
          NotificationBadge(
            count: _unreadNotifications,
            onTap: () {
              setState(() {
                _currentIndex = 1; // Switch to notifications tab
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ] : null,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
                 ),
               ],
             ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'JLW Foundation';
      case 1:
        return 'Notifications';
      case 2:
        return 'Profile';
      default:
        return 'JLW Foundation';
    }
  }
}

// Separate widget for home content
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final GlobalKey _servicesKey = GlobalKey();
  int _bursaryCount = 0;
  int _eventCount = 0;
  int _notificationCount = 0;
  bool _isLoadingStats = true;
  String _userName = 'Region Resident';
  List<Activity> _upcomingEvents = [];
  bool _isLoadingEvents = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStats();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = ServiceLocator().authServiceSafe;
      if (authService != null) {
        final currentUser = authService.currentUser;
        if (currentUser != null && currentUser.name.isNotEmpty) {
          setState(() {
            _userName = currentUser.name;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadStats() async {
    try {
      final activityService = ServiceLocator().activityServiceSafe;
      final bursaryService = ServiceLocator().bursaryApplicationServiceSafe;
      final noticeService = ServiceLocator().noticeServiceSafe;

      if (activityService != null && bursaryService != null && noticeService != null) {
        // Load stats in parallel
        final results = await Future.wait([
          activityService.getAllActivities(),
          bursaryService.getAllApplications(),
          noticeService.getAllNotices(),
        ]);

        if (mounted) {
          setState(() {
            _eventCount = results[0].length;
            _bursaryCount = results[1].length;
            _notificationCount = results[2].length;
            _isLoadingStats = false;
          });
        }
        
        // Load upcoming events
        _loadUpcomingEvents();
      } else {
        // Set default values if services are not available
        if (mounted) {
          setState(() {
            _eventCount = 0;
            _bursaryCount = 0;
            _notificationCount = 0;
            _isLoadingStats = false;
          });
        }
      }
    } catch (e) {
      print('Error loading stats: $e');
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
        });
      }
    }
  }

  Future<void> _loadUpcomingEvents() async {
    try {
      print('HomeScreen: Loading upcoming events...');
      final activityService = ServiceLocator().activityServiceSafe;
      
      if (activityService != null) {
        // Add timeout to prevent infinite loading
        final allActivities = await activityService.getAllActivities().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            print('HomeScreen: Timeout loading activities');
            return <Activity>[];
          },
        );
        print('HomeScreen: Fetched ${allActivities.length} activities');
        
        final now = DateTime.now();
        final upcomingEvents = allActivities.where((activity) {
          try {
            final eventDate = DateTime.parse(activity.startDate);
            final isUpcoming = eventDate.isAfter(now);
            print('HomeScreen: Event "${activity.title}" on ${activity.startDate} - isUpcoming: $isUpcoming');
            return isUpcoming;
          } catch (e) {
            print('HomeScreen: Error parsing date for "${activity.title}": $e');
            return false;
          }
        }).toList();
        
        print('HomeScreen: Found ${upcomingEvents.length} upcoming events');
        
        // Sort by date (closest first)
        upcomingEvents.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.startDate);
            final dateB = DateTime.parse(b.startDate);
            return dateA.compareTo(dateB);
          } catch (e) {
            return 0;
          }
        });
        
        // Take only the next 3 events
        final nextEvents = upcomingEvents.take(3).toList();
        print('HomeScreen: Selected ${nextEvents.length} events to display');
        
        // If no upcoming events, show all events (they might be in the past but still relevant)
        final eventsToShow = nextEvents.isEmpty ? allActivities.take(3).toList() : nextEvents;
        print('HomeScreen: Final events to show: ${eventsToShow.length}');
        
        // If still no events, show empty list
        if (eventsToShow.isEmpty) {
          print('HomeScreen: No events found at all');
        }
        
        if (mounted) {
          setState(() {
            _upcomingEvents = eventsToShow;
            _isLoadingEvents = false;
          });
          print('HomeScreen: Updated UI with ${eventsToShow.length} events');
        }
      } else {
        // Set default values if service is not available
        if (mounted) {
          setState(() {
            _upcomingEvents = [];
            _isLoadingEvents = false;
          });
        }
      }
    } catch (e) {
      print('HomeScreen: Error loading upcoming events: $e');
      if (mounted) {
        setState(() {
          _isLoadingEvents = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
               padding: const EdgeInsets.all(16),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName == 'Region Resident' 
                                  ? 'Welcome!' 
                                  : 'Welcome back!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                            ),
                            Text(
                              _userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Access JLW Foundation services for Region',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Scrollable.ensureVisible(
                          _servicesKey.currentContext!,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.explore),
                      label: const Text('Explore Services'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Services Section
            Row(
              children: [
                const Icon(Icons.dashboard_customize,
                    color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text(
                  'Our Services',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tap a card to access services',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            _buildTodayEventPreview(context),
            // Service Cards
            _buildServiceCard(
              title: 'Apply for Bursary',
              subtitle: 'Educational support for students',
              icon: Icons.school,
              color: AppTheme.successColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BursaryScreen(),
                  ),
                );
              },
            ),
            _buildServiceCard(
              title: 'Request Ambulance',
              subtitle: 'Emergency medical assistance',
              icon: Icons.medical_services,
              color: AppTheme.errorColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AmbulanceScreen(),
                  ),
                );
              },
            ),
            _buildServiceCard(
              title: 'View Events',
              subtitle: 'Community events and activities',
              icon: Icons.event,
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventsScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            // Quick Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Quick Stats',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        onPressed: _loadStats,
                        tooltip: 'Refresh Stats',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Bursaries',
                          _isLoadingStats ? '...' : _bursaryCount.toString(),
                          Icons.school,
                          AppTheme.successColor,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Events',
                          _isLoadingStats ? '...' : _eventCount.toString(),
                          Icons.event,
                          AppTheme.accentColor,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Notifications',
                          _isLoadingStats ? '...' : _notificationCount.toString(),
                          Icons.notifications,
                          AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
        ),
      ],
    );
  }

     Widget _buildTodayEventPreview(BuildContext context) {
       return Card(
         color: AppTheme.surfaceColor,
         margin: const EdgeInsets.only(bottom: 16),
         child: Padding(
           padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Events',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  onPressed: _loadUpcomingEvents,
                  tooltip: 'Refresh Events',
                ),
                if (_upcomingEvents.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EventsScreen()),
                      );
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoadingEvents)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_upcomingEvents.isEmpty)
              Row(
             children: [
               const Icon(Icons.event_busy, color: AppTheme.textSecondaryColor),
               const SizedBox(width: 12),
               Expanded(
                 child: Text(
                      'No upcoming events scheduled.',
                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                         color: AppTheme.textSecondaryColor,
                       ),
                 ),
               ),
                ],
              )
            else
              ...(_upcomingEvents.map((event) => _buildEventItem(event)).toList()),
           ],
         ),
       ),
     );
   }

  Widget _buildEventItem(Activity event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? 'Event',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatEventDate(event.startDate ?? ''),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                  ],
                ),
                if (event.location != null && event.location.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference < 7) {
        return 'In $difference days';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Date TBD';
    }
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      key: title == 'Apply for Bursary' ? _servicesKey : null,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              // Animated arrow
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 8),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Padding(
                    padding: EdgeInsets.only(left: value),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondaryColor,
                      size: 16,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
