import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'call_provider.dart';

class IncomingCallSheet extends StatelessWidget {
  final CallParticipant caller;
  
  const IncomingCallSheet({super.key, required this.caller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1c1c1e),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(caller.avatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(caller.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${caller.role} • Incoming Call', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.close, 
                color: const Color(0xFFFF3B30), 
                label: 'Decline',
                onTap: () {
                  context.read<CallProvider>().declineIncomingCall();
                  Navigator.pop(context);
                }
              ),
              _buildActionButton(
                icon: Icons.chat_bubble, 
                color: Colors.white24, 
                label: 'Message',
                onTap: () {
                  context.read<CallProvider>().declineIncomingCall();
                  Navigator.pop(context);
                }
              ),
              _buildActionButton(
                icon: Icons.call, 
                color: const Color(0xFF34C759), 
                label: 'Accept',
                onTap: () {
                  context.read<CallProvider>().acceptIncomingCall();
                  Navigator.pop(context);
                  // Push to active call screen
                }
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
