import 'package:flutter/material.dart';

class HealthAssistantPage extends StatefulWidget {
  const HealthAssistantPage({super.key});

  @override
  State<HealthAssistantPage> createState() => _HealthAssistantPageState();
}

class _HealthAssistantPageState extends State<HealthAssistantPage> {
  String _state = 'welcome'; // welcome, thinking, answered
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _state = 'thinking';
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _state = 'answered';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('AI Assistant', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMainContent()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_state == 'welcome') {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Color(0xFF6366F1)),
            const SizedBox(height: 24),
            const Text('Hi Somraj!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('How can I help you today?', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    } else if (_state == 'thinking') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xFF6366F1)),
            SizedBox(height: 24),
            Text('AI is thinking...', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildChatBubble('Your query about gut health', isUser: true),
          _buildChatBubble(
            'Based on your profile, increasing fiber and lean proteins will help. '
            'Also, recent sleep data shows 6h of sleep; aim for 8h to improve recovery.',
            isUser: false,
          ),
        ],
      );
    }
  }

  Widget _buildChatBubble(String message, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6366F1) : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(message, style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Type your question...', border: InputBorder.none),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF6366F1)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
