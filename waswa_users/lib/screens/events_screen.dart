import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../di/service_locator.dart';
import '../utils/theme.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Activity>> _events;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime(2025, 1, 15); // Focus on January 2025 where we have events
    _selectedDay = DateTime(2025, 1, 15);
    _events = {}; // Initialize the events map
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('EventsScreen: Loading events...');
      final activityService = ServiceLocator().activityService;
      final activities = await activityService.getAllActivities();
      print('EventsScreen: Received ${activities.length} activities');
      
      final eventsMap = _getEventsMap(activities);
      print('EventsScreen: Created events map with ${eventsMap.length} date keys');
      
      setState(() {
        _events = eventsMap;
        _isLoading = false;
      });
      
      // Force calendar to refresh by updating focused day
      setState(() {
        _focusedDay = DateTime(2025, 1, 15);
      });
      
      print('EventsScreen: Events loaded successfully');
    } catch (e) {
      print('EventsScreen: Error loading events: $e');
      setState(() {
        _error = 'Failed to load events: $e';
        _isLoading = false;
      });
    }
  }

  Map<DateTime, List<Activity>> _getEventsMap(List<Activity> activities) {
    final Map<DateTime, List<Activity>> events = {};

    for (final activity in activities) {
      print('EventsScreen: Processing activity: ${activity.title} with startDate: ${activity.startDate}');
      final date = DateTime.tryParse(activity.startDate);
      if (date != null) {
        final key = DateTime(date.year, date.month, date.day);
        print('EventsScreen: Parsed date: $key for activity: ${activity.title}');

        if (events[key] == null) {
          events[key] = [];
        }
        events[key]!.add(activity);
        print('EventsScreen: Added activity to date $key');
      } else {
        print('EventsScreen: Failed to parse date for activity: ${activity.title}, startDate: ${activity.startDate}');
      }
    }

    print('EventsScreen: Final events map: ${events.keys.map((k) => k.toString()).join(', ')}');
    return events;
  }

  List<Activity> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final events = _events[key] ?? [];
    print('EventsScreen: Checking events for day $day (key: $key) - found ${events.length} events');
    if (events.isNotEmpty) {
      print('EventsScreen: Events for $key: ${events.map((e) => e.title).join(', ')}');
    }
    return events;
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return 'TBD';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('EventsScreen: Building with isLoading: $_isLoading, error: $_error, events count: ${_events.length}');
    print('EventsScreen: Events map keys: ${_events.keys.map((k) => k.toString()).join(', ')}');
    print('EventsScreen: Current focused day: $_focusedDay');
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Events Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(2025, 1, 15); // Navigate to January 2025
              });
            },
            tooltip: 'Go to January 2025',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadEvents,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
        children: [
          // Calendar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar<Activity>(
              key: ValueKey(_focusedDay), // Force rebuild when focused day changes
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                final events = _getEventsForDay(day);
                print('EventsScreen: Calendar requesting events for $day - returning ${events.length} events');
                return events;
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
                holidayTextStyle: TextStyle(color: Colors.red),
                selectedDecoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerSize: 10,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          // Events for selected day
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildEventsList()),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _focusedDay = DateTime(2025, 1, 15); // Navigate to January 2025
          });
        },
        child: const Icon(Icons.event),
        tooltip: 'Go to Events (Jan 2025)',
      ),
    );
  }

  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No events for ${DateFormat('MMM dd, yyyy').format(_selectedDay)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final activity = events[index];
        final String host = activity.name.isNotEmpty ? activity.name : "JLW Foundation";
        final String purpose = activity.description.isNotEmpty ? activity.description : "Community event organized by JLW Foundation.";
        final String imageUrl = activity.imageUrl.isNotEmpty ? activity.imageUrl : "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80";
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.event, color: AppTheme.accentColor, size: 24),
            ),
            title: Text(
              activity.title.isNotEmpty ? activity.title : activity.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(activity.startDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        activity.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                DateFormat('MMM dd').format(DateTime.parse(activity.startDate)),
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(
                    event: activity,
                    host: host,
                    purpose: purpose,
                    imageUrl: imageUrl,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
