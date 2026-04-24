import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_settings_page.dart';
import 'notification_provider.dart';
import 'appointment_slip_page.dart';
import 'reschedule_appointment_page.dart';
import 'invoice_page.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF98A2B3), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF98A2B3), size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notifProvider, _) {
          final notifications = notifProvider.notifications;
          final unreadCount = notifProvider.unreadCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2939),
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (unreadCount > 0)
                      GestureDetector(
                        onTap: () => notifProvider.markAllAsRead(),
                        child: const Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: Color(0xFF2E90FA),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),

                if (notifications.isEmpty)
                  _buildEmptyState(context)
                else ...[
                  // Dynamic Notifications
                  if (notifications.isNotEmpty) ...[
                    _buildSectionHeader('NEW UPDATES', badge: unreadCount > 0 ? '$unreadCount NEW' : null),
                    const SizedBox(height: 16),
                    ...notifications.map((notif) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildNotificationCard(context, notif, notifProvider),
                    )).toList(),
                    const SizedBox(height: 16),
                  ],

                  // Critical Alerts Section (Hardcoded for demo)
                  _buildSectionHeader('CRITICAL ALERTS'),
                  const SizedBox(height: 16),
                  _buildCriticalCard(
                    icon: Icons.favorite,
                    title: 'High Heart Rate Detected',
                    time: '2m ago',
                    description: 'Your resting heart rate exceeded 105 BPM for over 5 minutes. Please find a place to rest.',
                    actionLabel: 'View Live Data',
                    color: const Color(0xFFF04438),
                  ),
                  const SizedBox(height: 16),
                  _buildCriticalCard(
                    icon: Icons.thermostat,
                    title: 'Temperature Elevation',
                    time: '1h ago',
                    description: 'Mild fever detected (99.8°F). This matches your recovery profile markers.',
                    buttons: ['Log Symptoms', 'Dismiss'],
                    color: const Color(0xFFF79009),
                  ),
                  const SizedBox(height: 32),

                  // Administrative Section
                  _buildSectionHeader('ADMINISTRATIVE'),
                  const SizedBox(height: 16),
                  // Show dynamic admin notifications here too
                  ...notifications.where((n) => n.type == NotificationType.admin).map((notif) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildNotificationCard(context, notif, notifProvider),
                  )).toList(),
                  _buildAdminCard(
                    icon: Icons.description_outlined,
                    title: 'Invoice Available',
                    time: 'Yesterday',
                    description: 'Monthly VitalSync AI premium subscription statement.',
                    link: 'View Statement',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoicePage(
                            invoiceData: {
                              'invoiceNumber': 'AX-INV-SUB-9942',
                              'items': [{
                                'name': 'VitalSync AI Premium Subscription',
                                'qty': 1,
                                'cost': 1999.0,
                                'total': 1999.0,
                              }],
                              'subtotal': 1999.0,
                              'tax': 199.9,
                              'total': 2198.9,
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AxioNotification notif, NotificationProvider provider) {
    IconData icon;
    Color color;
    
    switch (notif.type) {
      case NotificationType.critical:
        icon = Icons.warning_rounded;
        color = const Color(0xFFF04438);
        break;
      case NotificationType.standard:
        icon = Icons.notifications_active;
        color = const Color(0xFF2E90FA);
        break;
      case NotificationType.admin:
        icon = Icons.calendar_today_rounded;
        color = const Color(0xFF475467);
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDetails(context, notif, provider),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
            ],
            border: notif.isRead ? null : Border.all(color: const Color(0xFF2E90FA).withOpacity(0.3), width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(_getTimeAgo(notif.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(notif.description, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              if (notif.title == 'Appointment Confirmed') ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          provider.markAsRead(notif.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RescheduleAppointmentPage(appointmentData: notif.metaData),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Reschedule', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openDetails(context, notif, provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Details', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, AxioNotification notif, NotificationProvider provider) {
    provider.markAsRead(notif.id);
    if (notif.title == 'Appointment Confirmed' && notif.metaData != null) {
      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening Appointment Slip...'),
          duration: Duration(milliseconds: 500),
        ),
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentSlipPage(appointmentData: notif.metaData!),
        ),
      );
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(timestamp);
  }

  Widget _buildSectionHeader(String title, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        if (badge != null)
          Text(
            badge,
            style: const TextStyle(
              color: Color(0xFFF04438),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
      ],
    );
  }

  Widget _buildCriticalCard({
    required IconData icon,
    required String title,
    required String time,
    required String description,
    required Color color,
    String? actionLabel,
    List<String>? buttons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(actionLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ],
          if (buttons != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade200),
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(buttons[0], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(buttons[1], style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String title,
    required String time,
    required String description,
    String? link,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
                child: Icon(icon, color: const Color(0xFF475467), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          if (link != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(link, style: const TextStyle(color: Color(0xFF4A80F0), fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.open_in_new, color: Color(0xFF4A80F0), size: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Image.asset(
            'assets/images/notification_empty.png',
            height: 240,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 48),
          const Text(
            "You've got no message",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2939),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "No messages in your inbox, just like every other day. Get some life, dude.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF667085),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
