import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appointment_provider.dart';
import 'lab_booking_provider.dart';
import 'appointment_slip_page.dart';

class MyBookingsPage extends StatefulWidget {
  final int initialTab;
  const MyBookingsPage({super.key, this.initialTab = 0});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    // Fetch data on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).fetchMyAppointments();
      Provider.of<LabBookingProvider>(context, listen: false).fetchMyLabBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF2F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFF5247),
          unselectedLabelColor: const Color(0xFF667085),
          indicatorColor: const Color(0xFFFF5247),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Appointments'),
            Tab(text: 'Lab Tests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AppointmentsTab(),
          _LabTestsTab(),
        ],
      ),
    );
  }
}

// ─── APPOINTMENTS TAB ───────────────────────────────────────────

class _AppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5247)));
        }

        if (provider.appointments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.calendar_month_outlined,
            title: 'No appointments yet',
            subtitle: 'Book a doctor appointment to see it here',
          );
        }

        final upcoming = provider.upcomingAppointments;
        final past = provider.pastAppointments;

        return RefreshIndicator(
          color: const Color(0xFFFF5247),
          onRefresh: () => provider.fetchMyAppointments(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (upcoming.isNotEmpty) ...[
                const _SectionHeader(title: 'Upcoming'),
                ...upcoming.map((a) => _AppointmentCard(appointment: a, isUpcoming: true)),
                const SizedBox(height: 24),
              ],
              if (past.isNotEmpty) ...[
                const _SectionHeader(title: 'Past'),
                ...past.map((a) => _AppointmentCard(appointment: a, isUpcoming: false)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isUpcoming;

  const _AppointmentCard({required this.appointment, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final isCancelled = appointment.status == 'cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor avatar
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F5FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: appointment.doctorImageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            appointment.doctorImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Color(0xFF2E90FA), size: 28),
                          ),
                        )
                      : const Icon(Icons.person, color: Color(0xFF2E90FA), size: 28),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.doctorSpecialty,
                        style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Color(0xFF667085)),
                          const SizedBox(width: 4),
                          Text(
                            appointment.displayDate,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time, size: 14, color: Color(0xFF667085)),
                          const SizedBox(width: 4),
                          Text(
                            appointment.slotTime,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? const Color(0xFFFEF3F2)
                        : isUpcoming
                            ? const Color(0xFFE7FDF0)
                            : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    appointment.status.substring(0, 1).toUpperCase() + appointment.status.substring(1),
                    style: TextStyle(
                      color: isCancelled
                          ? const Color(0xFFD92D20)
                          : isUpcoming
                              ? const Color(0xFF039855)
                              : const Color(0xFF667085),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action bar
          if (isUpcoming && !isCancelled) ...[
            const Divider(height: 1, color: Color(0xFFF2F4F7)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentSlipPage(
                              appointmentData: {
                                'orderId': appointment.confirmationCode,
                                'items': [{
                                  'name': appointment.doctorName,
                                  'price': appointment.amount,
                                  'category': 'appointment',
                                  'doctorName': appointment.doctorName,
                                }],
                                'date': '${appointment.displayDate}, ${appointment.slotTime}',
                                'slot': appointment.slotTime,
                                'pin': appointment.pinCode,
                                'confirmationNumber': appointment.confirmationCode,
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long, size: 16, color: Color(0xFF1570EF)),
                      label: const Text('View Slip', style: TextStyle(color: Color(0xFF1570EF), fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(width: 1, height: 24, color: const Color(0xFFF2F4F7)),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showCancelDialog(context, appointment),
                      icon: const Icon(Icons.close, size: 16, color: Color(0xFFD92D20)),
                      label: const Text('Cancel', style: TextStyle(color: Color(0xFFD92D20), fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to cancel your appointment with ${appointment.doctorName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep It', style: TextStyle(color: Color(0xFF667085))),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AppointmentProvider>(ctx, listen: false).cancelAppointment(appointment.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment cancelled'), backgroundColor: Color(0xFFD92D20)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD92D20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── LAB TESTS TAB ──────────────────────────────────────────────

class _LabTestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LabBookingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5247)));
        }

        if (provider.bookings.isEmpty) {
          return _buildEmptyState(
            icon: Icons.science_outlined,
            title: 'No lab test bookings',
            subtitle: 'Start booking lab tests at discounted prices',
          );
        }

        final upcoming = provider.upcomingBookings;
        final past = provider.pastBookings;

        return RefreshIndicator(
          color: const Color(0xFFFF5247),
          onRefresh: () => provider.fetchMyLabBookings(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (upcoming.isNotEmpty) ...[
                const _SectionHeader(title: 'Upcoming'),
                ...upcoming.map((b) => _LabBookingCard(booking: b, isUpcoming: true)),
                const SizedBox(height: 24),
              ],
              if (past.isNotEmpty) ...[
                const _SectionHeader(title: 'Past'),
                ...past.map((b) => _LabBookingCard(booking: b, isUpcoming: false)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LabBookingCard extends StatelessWidget {
  final LabBooking booking;
  final bool isUpcoming;

  const _LabBookingCard({required this.booking, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lab icon
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.science, color: Color(0xFFE11D48), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.packageName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${booking.amount.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF1D2939)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Color(0xFF667085)),
                          const SizedBox(width: 4),
                          Text(booking.displayDate, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time, size: 14, color: Color(0xFF667085)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              booking.collectionSlot,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (booking.collectionAddress.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.home_outlined, size: 14, color: Color(0xFF667085)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                booking.collectionAddress,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.statusLabel,
                    style: TextStyle(color: booking.statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Confirmation code bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(top: BorderSide(color: Color(0xFFF2F4F7))),
            ),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number_outlined, size: 14, color: Color(0xFF667085)),
                const SizedBox(width: 6),
                Text(booking.confirmationCode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF344054))),
                const Spacer(),
                if (isUpcoming && booking.status != 'cancelled')
                  GestureDetector(
                    onTap: () => _showCancelDialog(context, booking),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFFD92D20), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                if (booking.status == 'report_ready')
                  GestureDetector(
                    onTap: () {},
                    child: const Text('View Report', style: TextStyle(color: Color(0xFF6941C6), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, LabBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Lab Booking', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to cancel ${booking.packageName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep It', style: TextStyle(color: Color(0xFF667085))),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<LabBookingProvider>(ctx, listen: false).cancelLabBooking(booking.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lab booking cancelled'), backgroundColor: Color(0xFFD92D20)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD92D20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── SHARED WIDGETS ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
      ),
    );
  }
}

Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), shape: BoxShape.circle),
          child: Icon(icon, size: 48, color: const Color(0xFF98A2B3)),
        ),
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1D2939))),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF667085), fontSize: 14)),
        ),
        const SizedBox(height: 60),
      ],
    ),
  );
}
