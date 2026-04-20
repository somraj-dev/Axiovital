import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final ChatUserRole? specificRole;

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
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _subscription;
  
  List<ChatThread> _threads = [];
  List<ChatUser> _contacts = [];
  
  List<ChatThread> get threads => _threads;
  List<ChatUser> get contacts => _contacts;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  CommunityProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchThreads();
    _setupRealtime();
  }

  void _setupRealtime() {
    _subscription = _supabase
        .channel('public:community_messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'community_messages',
          callback: (payload) {
            final newMessage = payload.newRecord;
            _handleIncomingMessage(newMessage);
          },
        )
        .subscribe();
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    final threadId = data['thread_id'];
    final threadIndex = _threads.indexWhere((t) => t.id == threadId);
    
    if (threadIndex != -1) {
      final message = ChatMessage(
        id: data['id'],
        senderId: data['sender_id'],
        text: data['text'],
        timestamp: DateTime.parse(data['created_at']),
        status: MessageStatus.delivered,
        isCallLog: data['is_call_log'] ?? false,
      );
      
      _threads[threadIndex].messages.insert(0, message);
      if (message.senderId != currentUserId) {
        _threads[threadIndex].unreadCount++;
      }
      notifyListeners();
    }
  }

  Future<void> fetchThreads() async {
    try {
      final List<dynamic> data = await _supabase
          .from('community_threads')
          .select('*, community_messages(*)');

      _threads = data.map((json) {
        final List<dynamic> msgData = json['community_messages'] ?? [];
        final messages = msgData.map((m) => ChatMessage(
          id: m['id'],
          senderId: m['sender_id'],
          text: m['text'],
          timestamp: DateTime.parse(m['created_at']),
          status: _parseStatus(m['status']),
          isCallLog: m['is_call_log'] ?? false,
        )).toList();

        // Sort messages by time descending
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ChatThread(
          id: json['id'],
          title: json['title'],
          avatarUrl: json['avatar_url'],
          type: json['type'] == 'group' ? ChatType.group : ChatType.oneOnOne,
          participants: [], // In real app, fetch from community_participants
          messages: messages,
          unreadCount: 0,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching threads: $e');
    }
  }

  Future<void> sendMessage(String threadId, String text) async {
    if (currentUserId == null) return;

    try {
      await _supabase.from('community_messages').insert({
        'thread_id': threadId,
        'sender_id': currentUserId,
        'text': text,
        'status': 'sent',
      });
      // UI will update via Realtime subscription
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  Future<void> addCallLog(String threadId, String text) async {
    if (currentUserId == null) return;
    try {
      await _supabase.from('community_messages').insert({
        'thread_id': threadId,
        'sender_id': currentUserId,
        'text': text,
        'is_call_log': true,
        'status': 'sent',
      });
    } catch (e) {
      debugPrint('Error adding call log: $e');
    }
  }

  void markThreadAsRead(String threadId) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    if (thread.unreadCount > 0) {
      thread.unreadCount = 0;
      notifyListeners();
      // In real app, update DB as well
    }
  }

  MessageStatus _parseStatus(String? status) {
    switch (status) {
      case 'read': return MessageStatus.read;
      case 'delivered': return MessageStatus.delivered;
      default: return MessageStatus.sent;
    }
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }
}
