import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../utils/theme.dart';

class EventDetailScreen extends StatelessWidget {
  final Activity event;
  final String host;
  final String purpose;
  final String imageUrl;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.host,
    required this.purpose,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.image, color: Colors.white70, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              event.title.isNotEmpty ? event.title : event.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: AppTheme.accentColor),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy').format(DateTime.parse(event.startDate)),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time,
                    size: 18, color: AppTheme.accentColor),
                const SizedBox(width: 6),
                Text(
                  _formatTime(event.startDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 18, color: AppTheme.accentColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.location,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: AppTheme.accentColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    host,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              purpose,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              event.description.isNotEmpty ? event.description : purpose,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return 'TBD';
    }
  }
}
