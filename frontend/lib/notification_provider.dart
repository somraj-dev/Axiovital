import 'package:flutter/material.dart';

enum NotificationType { critical, standard, admin }

class AxioNotification {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;
  final Map<String, dynamic>? metaData;

  AxioNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.metaData,
  });
}

class NotificationProvider with ChangeNotifier {
  final List<AxioNotification> _notifications = [
    AxioNotification(
      id: 'initial_demo',
      title: 'Appointment Confirmed',
      subtitle: 'Booking Successful',
      description: 'Dr. Aris (Cardiology) • Tomorrow, 10:30 AM',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: NotificationType.admin,
      isRead: false,
      metaData: {
        'orderId': 'AXIO-DEMO-123',
        'items': [
          {'name': 'Dr. Aris (Cardiology)', 'price': 500, 'category': 'Cardiology'}
        ],
        'date': 'Tomorrow, 10:30 AM',
        'pin': '8842',
        'confirmationNumber': 'CONF-7629-XB',
      },
    ),
  ];

  List<AxioNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String subtitle,
    required String description,
    required NotificationType type,
    Map<String, dynamic>? metaData,
  }) {
    final notification = AxioNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: subtitle,
      description: description,
      timestamp: DateTime.now(),
      type: type,
      metaData: metaData,
    );
    _notifications.insert(0, notification);
    debugPrint('Notification added: $title');
    notifyListeners();
  }

  void simulateNotification() {
    addNotification(
      title: 'Appointment Confirmed',
      subtitle: 'Booking Successful',
      description: 'Your test appointment with Dr. Somraj has been confirmed.',
      type: NotificationType.admin,
      metaData: {
        'orderId': 'SIM-TEST-999',
        'items': [
          {'name': 'Dr. Somraj Dev', 'price': 1200, 'category': 'Developer Diagnostics'}
        ],
        'date': 'Next Week, 09:00 AM',
        'pin': '1234',
        'confirmationNumber': 'SIM-999-OK',
      },
    );
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
