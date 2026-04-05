import 'package:flutter/material.dart';

enum HealthAssistantStage { welcome, thinking, answered }

class HealthAssistantPage extends StatefulWidget {
  const HealthAssistantPage({super.key});

  @override
  State<HealthAssistantPage> createState() => _HealthAssistantPageState();
}

class _HealthAssistantPageState extends State<HealthAssistantPage> {
  HealthAssistantStage _stage = HealthAssistantStage.welcome;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _stage = HealthAssistantStage.thinking;
    });

    // Simulate AI thinking and answering
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _stage = HealthAssistantStage.answered;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMainContent()),
          _buildBottomInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: _stage == HealthAssistantStage.welcome 
          ? null 
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Health Assistant', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('for Somraj', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
      actions: [
        if (_stage != HealthAssistantStage.welcome)
          IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.black54), onPressed: () {}),
        IconButton(icon: const Icon(Icons.playlist_add_check, color: Colors.black54), onPressed: () {}),
      ],
    );
  }

  Widget _buildMainContent() {
    switch (_stage) {
      case HealthAssistantStage.welcome:
        return _buildWelcomeView();
      case HealthAssistantStage.thinking:
        return _buildChatView(isThinking: true);
      case HealthAssistantStage.answered:
        return _buildChatView(isThinking: false);
    }
  }

  Widget _buildWelcomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // AI Center Logo
          _buildAILogo(size: 150),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 28, color: Color(0xFF1D2939), height: 1.2),
              children: [
                TextSpan(text: 'Hi '),
                TextSpan(text: 'Somraj!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1570EF))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "I'm your Health Assistant",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D2939)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Disclaimers
          _buildDisclaimerRow("I can help you understand your lab reports"),
          _buildDisclaimerRow("Being AI driven, I may not always be right"),
          _buildDisclaimerRow("By messaging further you agree to T&Cs", isLink: true),
          
          const SizedBox(height: 48),
          
          // Suggested Questions
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSuggestionCard("How can I relieve stiffness from sitting at a desk all day?"),
                const SizedBox(width: 12),
                _buildSuggestionCard("What steps can I take to improve my overall health?"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView({required bool isThinking}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // User Message
        _buildMessageBubble("Hello!", isUser: true),
        const SizedBox(height: 24),
        
        // AI Response or Thinking
        if (isThinking)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thinking...', style: TextStyle(color: const Color(0xFF1570EF), fontWeight: FontWeight.w500)),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageBubble("Hello! How can I assist you with your health today?", isUser: false),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.copy_outlined, size: 20, color: Colors.grey.shade400),
                  const SizedBox(width: 16),
                  Icon(Icons.thumb_up_outlined, size: 20, color: Colors.grey.shade400),
                  const SizedBox(width: 16),
                  Icon(Icons.thumb_down_outlined, size: 20, color: Colors.grey.shade400),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAILogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF4B89FF), Color(0xFF1570EF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B89FF).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.filter_vintage, color: Colors.white, size: size * 0.5),
      ),
    );
  }

  Widget _buildDisclaimerRow(String text, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.radio_button_checked, color: Color(0xFF1570EF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14, 
                color: Colors.grey.shade600,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String text) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF344054), height: 1.4),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF1570EF) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: isUser ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFF1D2939),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: _stage != HealthAssistantStage.thinking,
                    decoration: InputDecoration(
                      hintText: _stage == HealthAssistantStage.thinking ? 'Loading results...' : 'Ask me anything...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF4B89FF), Color(0xFF1570EF)],
                      ),
                    ),
                    child: Icon(
                      _stage == HealthAssistantStage.thinking ? Icons.stop : Icons.arrow_forward, 
                      color: Colors.white, 
                      size: 20
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBetaFooter(),
      ],
    );
  }

  Widget _buildBetaFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Health Assistant is in beta version',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 12, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
