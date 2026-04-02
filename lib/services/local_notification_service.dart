import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();
  static final instance = LocalNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<void> scheduleDailyReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    var schedule = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (schedule.isBefore(now)) schedule = schedule.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      100,
      'Expense Tracker',
      'Don\'t forget to add today\'s transactions',
      schedule,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily-reminder',
          'Daily Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelDailyReminder() => _plugin.cancel(100);
}
