import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    // Initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'leafhealth_channel',
      'LeafHealth Notifications',
      channelDescription: 'Notifications for disease detection results',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> showScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'leafhealth_scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Scheduled reminders for plant care',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      scheduledDate.millisecondsSinceEpoch,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> showPeriodicNotification({
    required String title,
    required String body,
    required RepeatInterval interval,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'leafhealth_periodic_channel',
      'Periodic Reminders',
      channelDescription: 'Regular reminders for plant monitoring',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.periodicallyShow(
      1001,
      title,
      body,
      interval,
      details,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Sample notification for disease detection
  Future<void> showDiseaseDetectedNotification(String diseaseName, double confidence) async {
    await showInstantNotification(
      title: 'Disease Detected!',
      body: '$diseaseName detected with ${confidence.toStringAsFixed(1)}% confidence',
      payload: 'disease_result',
    );
  }

  // Sample notification for plant care reminder
  Future<void> scheduleCareReminder() async {
    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, 9, 0); // 9 AM

    if (scheduledDate.isBefore(now)) {
      // If time already passed, schedule for next day
      await showScheduledNotification(
        title: '🌱 Plant Care Reminder',
        body: 'Time to check your apple trees for any disease symptoms!',
        scheduledDate: scheduledDate.add(Duration(days: 1)),
      );
    } else {
      await showScheduledNotification(
        title: '🌱 Plant Care Reminder',
        body: 'Time to check your apple trees for any disease symptoms!',
        scheduledDate: scheduledDate,
      );
    }
  }
}