import 'dart:async';
import 'package:flutter/foundation.dart';

enum ChatType { oneOnOne, group }
enum ChatUserRole { patient, doctor, contact }
enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  MessageStatus status;
  final bool isCallLog;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.isCallLog = false,
  });
}

class ChatUser {
  final String id;
  final String name;
  final String avatarUrl;
  final ChatUserRole role;
  final bool isOnline;

  ChatUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
    this.isOnline = false,
  });
}

class ChatThread {
  final String id;
  final String title;
  final String? avatarUrl;
  final ChatType type;
  final List<ChatUser> participants;
  final List<ChatMessage> messages;
  int unreadCount;
  final ChatUserRole? specificRole; // Doctor etc label

  ChatThread({
    required this.id,
    required this.title,
    this.avatarUrl,
    required this.type,
    required this.participants,
    required this.messages,
    this.unreadCount = 0,
    this.specificRole,
  });
}

class CommunityProvider extends ChangeNotifier {
  final String currentUserId = 'user_me';
  
  List<ChatThread> _threads = [];
  List<ChatUser> _contacts = [];
  
  List<ChatThread> get threads => _threads;
  List<ChatUser> get contacts => _contacts;

  CommunityProvider() {
    _initMockData();
  }

  void _initMockData() {
    // Mock contacts including doctors and group members
    final drSaad = ChatUser(id: 'dr_1', name: 'Dr. Saad Shaikh', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774299.png', role: ChatUserRole.doctor, isOnline: true);
    final rafael = ChatUser(id: 'usr_1', name: 'Rafael Mante', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', role: ChatUserRole.contact);
    final katherine = ChatUser(id: 'usr_2', name: 'Katherine Bernhard', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135768.png', role: ChatUserRole.contact, isOnline: true);
    
    _contacts = [drSaad, rafael, katherine];

    _threads = [
      ChatThread(
        id: 'thread_1',
        title: 'Rafael Mante',
        avatarUrl: rafael.avatarUrl,
        type: ChatType.oneOnOne,
        participants: [rafael],
        messages: [
          ChatMessage(id: 'm1', senderId: 'usr_1', text: 'Thanks for adding me to the FitLeague group!', timestamp: DateTime.now().subtract(const Duration(minutes: 45))),
        ],
        unreadCount: 0,
      ),
      ChatThread(
        id: 'thread_2',
        title: 'Katherine Bernhard',
        avatarUrl: katherine.avatarUrl,
        type: ChatType.oneOnOne,
        participants: [katherine],
        messages: [
          ChatMessage(id: 'm2', senderId: 'usr_2', text: 'Are we still walking tomorrow?', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
          ChatMessage(id: 'm3', senderId: 'user_me', text: 'Yes, 8 AM!', timestamp: DateTime.now().subtract(const Duration(minutes: 58))),
        ],
        unreadCount: 0,
      ),
      ChatThread(
        id: 'thread_3',
        title: 'Dr. Saad Shaikh',
        avatarUrl: drSaad.avatarUrl,
        type: ChatType.oneOnOne,
        participants: [drSaad],
        specificRole: ChatUserRole.doctor,
        messages: [
          ChatMessage(id: 'm4', senderId: 'dr_1', text: 'Please remember to take your fasting blood test tomorrow.', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
        ],
        unreadCount: 1, // Has unread
      ),
      ChatThread(
        id: 'thread_4',
        title: 'Diabetes Support Community',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3214/3214539.png',
        type: ChatType.group,
        participants: [drSaad, rafael, katherine],
        messages: [
          ChatMessage(id: 'm5', senderId: 'usr_1', text: 'Has anyone tried the new sugar alternative?', timestamp: DateTime.now().subtract(const Duration(days: 1))),
        ],
        unreadCount: 2,
      ),
    ];
  }

  void sendMessage(String threadId, String text) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    thread.messages.insert(0, ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    ));
    
    notifyListeners();

    // Mock bot reply after 1.5 seconds for interaction feel
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (thread.title.startsWith("Dr.") || thread.type == ChatType.group) {
        thread.messages.insert(0, ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: thread.participants.first.id,
          text: 'This is an automated mock response to: "$text".',
          timestamp: DateTime.now(),
        ));
        thread.unreadCount++;
        notifyListeners();
      }
    });
  }

  void markThreadAsRead(String threadId) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    if (thread.unreadCount > 0) {
      thread.unreadCount = 0;
      notifyListeners();
    }
  }

  void addCallLog(String threadId, String logText) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    thread.messages.insert(0, ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      text: logText,
      timestamp: DateTime.now(),
      isCallLog: true,
    ));
    notifyListeners();
  }

  // Access Control Simulation
  bool canCreateNewChatWith(ChatUser user) {
    // Logic: Only allowed with active doctor or approved group members
    return user.role == ChatUserRole.doctor || user.role == ChatUserRole.contact;
  }
}
