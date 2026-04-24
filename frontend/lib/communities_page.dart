import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'community_provider.dart';
import 'call_provider.dart';
import 'widgets/community_actions.dart';
import 'user_provider.dart';
import 'widgets/axio_avatar.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  bool _showWelcome = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // Local provider if not provided at root, but assuming root provides it now as per plan
      create: (_) => CommunityProvider(),
      child: Consumer<CommunityProvider>(
        builder: (context, communityProvider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showWelcome) _buildWelcomeBanner(context),
                      _buildActiveContactsList(communityProvider),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Chats', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2939))),
                            Icon(Icons.more_horiz, color: Colors.black54),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100), // Space for FAB
                          itemCount: communityProvider.threads.length,
                          itemBuilder: (context, index) {
                            return _buildChatListItem(context, communityProvider.threads[index]);
                          },
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => CommunityActions.showOptionsModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D2939),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))
                            ]
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi ${userProvider.name}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1D2939))),
                const Text('02 unread messages', style: TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300)
            ),
            child: AxioAvatar(radius: 20, imageUrl: userProvider.avatarUrl, name: userProvider.name),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F5FB), // Light blue medical tint
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, ${userProvider.name.split(" ").first}!', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF026AA2))),
                const SizedBox(height: 4),
                const Text('Connect securely with your doctors, groups, and health communities.', style: TextStyle(fontSize: 12, color: Color(0xFF026AA2))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => _showWelcome = false),
            child: const Icon(Icons.close, color: Color(0xFF026AA2), size: 18),
          )
        ],
      ),
    );
  }

  Widget _buildActiveContactsList(CommunityProvider provider) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: provider.contacts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2), // Dashed look if possible, solid for now
                    ),
                    child: const Icon(Icons.add, color: Colors.black45),
                  ),
                  const SizedBox(height: 8),
                  const Text('Add Story', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                ],
              ),
            );
          }
          final contact = provider.contacts[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: contact.isOnline ? Colors.green : Colors.transparent, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(contact.avatarUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.person)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(contact.name.split(" ").first, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: Colors.black87)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatListItem(BuildContext context, ChatThread thread) {
    final lastMessage = thread.messages.isNotEmpty ? thread.messages.first : null;
    final timeStr = lastMessage != null 
        ? '${lastMessage.timestamp.hour.toString().padLeft(2, '0')}:${lastMessage.timestamp.minute.toString().padLeft(2, '0')}' 
        : '';

    return InkWell(
      onTap: () {
        context.read<CommunityProvider>().markThreadAsRead(thread.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailScreen(thread: thread)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: thread.avatarUrl != null 
                  ? Image.network(thread.avatarUrl!, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.group))
                  : const Icon(Icons.person, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.title, 
                    style: TextStyle(fontSize: 16, fontWeight: thread.unreadCount > 0 ? FontWeight.w800 : FontWeight.bold, color: Colors.black87),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (thread.specificRole == ChatUserRole.doctor)
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.verified, color: Colors.blue, size: 12),
                        ),
                      Expanded(
                        child: Text(
                          lastMessage?.text ?? 'No messages yet', 
                          style: TextStyle(
                            fontSize: 13, 
                            color: thread.unreadCount > 0 ? Colors.black87 : Colors.black45,
                            fontWeight: thread.unreadCount > 0 ? FontWeight.bold : FontWeight.normal
                          ),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeStr, style: TextStyle(fontSize: 11, color: thread.unreadCount > 0 ? const Color(0xFFE11D48) : Colors.black38, fontWeight: thread.unreadCount > 0 ? FontWeight.bold : FontWeight.normal)),
                const SizedBox(height: 6),
                if (thread.unreadCount > 0)
                  Container(
                    width: 20, height: 20,
                    decoration: const BoxDecoration(color: Color(0xFFE11D48), shape: BoxShape.circle),
                    child: Center(child: Text('${thread.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------------- //
// CHAT DETAIL SCREEN
// -------------------------------------------------------------------------------- //
class ChatDetailScreen extends StatefulWidget {
  final ChatThread thread;
  const ChatDetailScreen({super.key, required this.thread});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.thread.avatarUrl != null ? NetworkImage(widget.thread.avatarUrl!) : null,
              child: widget.thread.avatarUrl == null ? const Icon(Icons.group, size: 18) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.thread.title, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                    if (widget.thread.specificRole == ChatUserRole.doctor)
                      const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.verified, color: Colors.blue, size: 14)),
                  ],
                ),
                Text(widget.thread.type == ChatType.group ? 'Community Group' : (widget.thread.specificRole == ChatUserRole.doctor ? 'Verified Doctor' : 'Patient/Contact'), style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined), 
            onPressed: () {
              final callProvider = Provider.of<CallProvider>(context, listen: false);
              callProvider.startOutgoingCall(
                context, 
                CallParticipant(
                  id: widget.thread.id, 
                  name: widget.thread.title, 
                  avatarUrl: widget.thread.avatarUrl ?? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', 
                  role: widget.thread.type == ChatType.group ? 'Community Group' : 'Contact'
                ), 
                widget.thread.type == ChatType.group ? CallType.group : CallType.friend
              );
              
              // Automatically inject log into chat history for context
              Provider.of<CommunityProvider>(context, listen: false).addCallLog(widget.thread.id, 'Audio call started');
            }
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Consumer<CommunityProvider>(
        builder: (context, provider, child) {
          // Relookup thread from provider for real-time updates
          final activeThread = provider.threads.firstWhere((t) => t.id == widget.thread.id);
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  reverse: true, // New messages at bottom
                  itemCount: activeThread.messages.length,
                  itemBuilder: (context, index) {
                    final message = activeThread.messages[index];
                    final isMe = message.senderId == provider.currentUserId;
                    
                    return _buildMessageBubble(message, isMe);
                  },
                ),
              ),
              _buildInputArea(provider),
            ],
          );
        }
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    if (message.isCallLog) {
      final isEnd = message.text.toLowerCase().contains('ended') || message.text.toLowerCase().contains('missed');
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1c1c1e).withOpacity(0.9), // Dark grey from reference
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: Icon(isEnd ? Icons.call_missed : Icons.call, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11)
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1D2939) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            if (!isMe) BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
          ]
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text, 
              style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 14)
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: isMe ? Colors.white54 : Colors.black38, fontSize: 10)
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(CommunityProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: Colors.grey.shade500, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.black38),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                if (_msgController.text.trim().isNotEmpty) {
                  provider.sendMessage(widget.thread.id, _msgController.text.trim());
                  _msgController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D2939),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
