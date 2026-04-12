import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'type': type.index,
    'isRead': isRead,
    'metaData': metaData,
  };

  factory AxioNotification.fromJson(Map<String, dynamic> json) => AxioNotification(
    id: json['id'],
    title: json['title'],
    subtitle: json['subtitle'],
    description: json['description'],
    timestamp: DateTime.parse(json['timestamp']),
    type: NotificationType.values[json['type']],
    isRead: json['isRead'] ?? false,
    metaData: json['metaData'] != null ? Map<String, dynamic>.from(json['metaData']) : null,
  );
}

class NotificationProvider with ChangeNotifier {
  static const String _storageKey = 'axio_notifications';
  final List<AxioNotification> _notifications = [];

  NotificationProvider() {
    _loadNotifications();
  }

  List<AxioNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedData = prefs.getString(_storageKey);
      
      if (storedData != null) {
        final List<dynamic> decodedData = jsonDecode(storedData);
        _notifications.clear();
        _notifications.addAll(
          decodedData.map((item) => AxioNotification.fromJson(item)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        _notifications.map((n) => n.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

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
    _saveNotifications();
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    _saveNotifications();
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _saveNotifications();
    notifyListeners();
  }
}
