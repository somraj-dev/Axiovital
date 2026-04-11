import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'call_provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallProvider>(
      builder: (context, provider, child) {
        final session = provider.currentSession;
        
        // Auto-pop off navigation when call is completely finalized and state is cleared
        if (session == null && provider.status == CallStatus.none) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });
          return const Scaffold(backgroundColor: Colors.black);
        }

        final isEnded = provider.status == CallStatus.ended;

        return Scaffold(
          backgroundColor: const Color(0xFF1c1c1e), // Deep charcoal tone
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background Blur Effect layer 1
              if (session != null && session.target.avatarUrl.isNotEmpty)
                Opacity(
                  opacity: 0.4,
                  child: Image.network(
                    session.target.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c,e,s) => Container(color: Colors.black),
                  ),
                ),
              // Blur Filter layer 2
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ]
                    )
                  ),
                ),
              ),
              
              // Top Action Bar
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                          onPressed: () {
                            if (!isEnded) {
                              // If minimizing, pop screen but keep provider active.
                              // In a real app we'd show a floating widget. For now, pop.
                              Navigator.pop(context); 
                            }
                          },
                        ),
                        const Icon(Icons.more_horiz, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                ),
              ),

              // Center Profile Information
              if (session != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar with conditional pulse ringing effect
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: (provider.status == CallStatus.dialing || provider.status == CallStatus.ringing) 
                                 ? _pulseAnimation.value 
                                 : 1.0,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.1), width: 4),
                              image: DecorationImage(
                                image: NetworkImage(session.target.avatarUrl),
                                fit: BoxFit.cover,
                              )
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 32),
                    Text(
                      session.target.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.getDisplayStatus(),
                      style: TextStyle(
                        color: isEnded ? Colors.redAccent : Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

              // Bottom Control Bar
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                          isActive: provider.isMuted,
                          onTap: provider.toggleMute,
                          activeColor: Colors.white,
                          activeIconColor: Colors.black,
                        ),
                        _buildControlButton(
                          icon: provider.isSpeakerOn ? Icons.volume_up : Icons.volume_mute,
                          isActive: provider.isSpeakerOn,
                          onTap: provider.toggleSpeaker,
                          activeColor: Colors.white,
                          activeIconColor: Colors.black,
                        ),
                        // End Call Button (Red, prominent)
                        GestureDetector(
                          onTap: isEnded ? null : provider.endCall,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF3B30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.call_end, color: Colors.white, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildControlButton({
    required IconData icon, 
    required bool isActive, 
    required VoidCallback onTap,
    Color activeColor = Colors.white,
    Color activeIconColor = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon, 
          color: isActive ? activeIconColor : Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
