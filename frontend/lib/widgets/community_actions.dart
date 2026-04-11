import 'package:flutter/material.dart';

class CommunityActions {
  static void showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionItem(
                context, 
                icon: Icons.chat_bubble_outline, 
                title: 'New Chat', 
                subtitle: 'Send a message to your contact',
                onTap: () {
                  Navigator.pop(context);
                  _showNewChatModal(context);
                }
              ),
              const Divider(height: 1, indent: 56, endIndent: 24, color: Color(0xFFF2F4F7)),
              _buildActionItem(
                context, 
                icon: Icons.person_add_alt_1_outlined, 
                title: 'New Contact', 
                subtitle: 'Add a contact to be able to send message',
                onTap: () {
                  Navigator.pop(context);
                  _showNewContactModal(context);
                }
              ),
              const Divider(height: 1, indent: 56, endIndent: 24, color: Color(0xFFF2F4F7)),
              _buildActionItem(
                context, 
                icon: Icons.people_outline, 
                title: 'New Community', 
                subtitle: 'Join or create the community around you',
                onTap: () {
                  Navigator.pop(context);
                  _showNewCommunityModal(context);
                }
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                   width: double.infinity,
                   child: TextButton(
                     onPressed: () => Navigator.pop(context),
                     style: TextButton.styleFrom(
                       backgroundColor: const Color(0xFFF2F4F7),
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                     ),
                     child: const Text('Cancel', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                   ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildActionItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showNewChatModal(BuildContext context) {
    _showMockSheet(context, 'Start New Chat', 'Select an allowed contact or doctor.');
  }

  static void _showNewContactModal(BuildContext context) {
    _showMockSheet(context, 'Add New Contact', 'Search globally and send a request.');
  }

  static void _showNewCommunityModal(BuildContext context) {
    _showMockSheet(context, 'Create Community', 'Build a focused patient support or fitness group.');
  }

  static void _showMockSheet(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 300,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D2939), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
