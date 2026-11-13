import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appointment_provider.dart';
import 'lab_booking_provider.dart';
import 'appointment_slip_page.dart';
import 'invoice_page.dart';
import 'reschedule_appointment_page.dart';
import 'find_doctor_page.dart';
import 'lab_tests_page.dart';
import 'theme_provider.dart';

class MyVisitsPage extends StatefulWidget {
  final int initialTab;
  const MyVisitsPage({super.key, this.initialTab = 0});

  @override
  State<MyVisitsPage> createState() => _MyVisitsPageState();
}

class _MyVisitsPageState extends State<MyVisitsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All'; // 'All', 'Upcoming', 'Past'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
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
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = themeProvider.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF101828) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'My Visits',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh visits',
            icon: Icon(Icons.refresh_rounded, color: theme.colorScheme.onSurface),
            onPressed: () {
              Provider.of<AppointmentProvider>(context, listen: false).fetchMyAppointments();
              Provider.of<LabBookingProvider>(context, listen: false).fetchMyLabBookings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Visits refreshed'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEAECF0),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Doctor Visits'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.science_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Lab Visits'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(isDark, primaryColor),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _DoctorVisitsTab(filter: _selectedFilter),
                _LabVisitsTab(filter: _selectedFilter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark, Color primaryColor) {
    final filters = ['All', 'Upcoming', 'Past'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey.shade300 : const Color(0xFF475467)),
                ),
              ),
              selected: isSelected,
              selectedColor: primaryColor,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFD0D5DD)),
                ),
              ),
              onSelected: (_) => setState(() => _selectedFilter = f),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DOCTOR VISITS TAB
// ─────────────────────────────────────────────────────────────

class _DoctorVisitsTab extends StatelessWidget {
  final String filter;
  const _DoctorVisitsTab({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Appointment> list;
        if (filter == 'Upcoming') {
          list = provider.upcomingAppointments;
        } else if (filter == 'Past') {
          list = provider.pastAppointments;
        } else {
          list = provider.appointments;
        }

        if (list.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.calendar_month_outlined,
            title: filter == 'Upcoming' ? 'No Upcoming Visits' : 'No Visits Recorded',
            subtitle: 'Schedule a consultation with our verified doctors & specialists.',
            btnText: 'Find a Doctor',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FindDoctorPage()),
              );
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchMyAppointments(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _DoctorVisitCard(
                appointment: list[index],
                isDark: isDark,
              );
            },
          ),
        );
      },
    );
  }
}

class _DoctorVisitCard extends StatelessWidget {
  final Appointment appointment;
  final bool isDark;

  const _DoctorVisitCard({
    required this.appointment,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final primaryColor = themeProvider.primaryColor;
    final isUpcoming = appointment.isUpcoming && appointment.status != 'cancelled';
    final isCancelled = appointment.status == 'cancelled';
    final isVideo = appointment.slotType == 'video';

    Color statusBg;
    Color statusText;
    String statusLabel;

    if (isCancelled) {
      statusBg = const Color(0xFFFEF3F2);
      statusText = const Color(0xFFD92D20);
      statusLabel = 'Cancelled';
    } else if (isUpcoming) {
      statusBg = const Color(0xFFECFDF3);
      statusText = const Color(0xFF027A48);
      statusLabel = 'Confirmed';
    } else {
      statusBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F7);
      statusText = isDark ? Colors.grey.shade300 : const Color(0xFF475467);
      statusLabel = 'Completed';
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFEAECF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Details & Status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 52,
                    height: 52,
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF8FF),
                    child: appointment.doctorImageUrl.isNotEmpty
                        ? Image.network(
                            appointment.doctorImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person_rounded,
                              size: 32,
                              color: primaryColor,
                            ),
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 32,
                            color: primaryColor,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Doctor Name + Specialty
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.doctorSpecialty,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Visit Type Badge (Clinic vs Video)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isVideo
                              ? const Color(0xFFEEF4FF)
                              : const Color(0xFFF4F3FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isVideo ? Icons.videocam_rounded : Icons.local_hospital_rounded,
                              size: 13,
                              color: isVideo ? const Color(0xFF3538CD) : const Color(0xFF5925DC),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isVideo ? 'Video Consultation' : 'In-Person Clinic Visit',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isVideo ? const Color(0xFF3538CD) : const Color(0xFF5925DC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Date & Time Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF2F4F7),
                ),
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF2F4F7),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  appointment.displayDate,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF344054),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time_rounded, size: 14, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  appointment.slotTime,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF344054),
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${appointment.amount.toInt()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // Slip
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentSlipPage(
                            appointmentData: {
                              'orderId': appointment.confirmationCode,
                              'items': [
                                {
                                  'name': appointment.doctorName,
                                  'price': appointment.amount,
                                  'category': appointment.doctorSpecialty,
                                  'doctorName': appointment.doctorName,
                                }
                              ],
                              'date': '${appointment.displayDate}, ${appointment.slotTime}',
                              'slot': appointment.slotTime,
                              'pin': appointment.pinCode,
                              'confirmationNumber': appointment.confirmationCode,
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.receipt_long_rounded, size: 16, color: primaryColor),
                    label: Text(
                      'Slip',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFEAECF0),
                ),
                // Invoice
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoicePage(
                            invoiceData: {
                              'invoiceNumber': 'AX-INV-${appointment.confirmationCode}',
                              'items': [
                                {
                                  'name': 'Consultation with ${appointment.doctorName}',
                                  'qty': 1,
                                  'cost': appointment.amount,
                                  'total': appointment.amount,
                                }
                              ],
                              'subtotal': appointment.amount,
                              'tax': appointment.amount * 0.1,
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.description_outlined, size: 16, color: primaryColor),
                    label: Text(
                      'Invoice',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isUpcoming && !isCancelled) ...[
                  Container(
                    width: 1,
                    height: 20,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFEAECF0),
                  ),
                  // Reschedule
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RescheduleAppointmentPage(
                              appointmentData: {
                                'doctorName': appointment.doctorName,
                                'date': appointment.displayDate,
                                'time': appointment.slotTime,
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_calendar_rounded, size: 14, color: Color(0xFFF79009)),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Reschedule',
                          style: TextStyle(
                            color: Color(0xFFF79009),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LAB VISITS TAB
// ─────────────────────────────────────────────────────────────

class _LabVisitsTab extends StatelessWidget {
  final String filter;
  const _LabVisitsTab({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<LabBookingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<LabBooking> list;
        if (filter == 'Upcoming') {
          list = provider.upcomingBookings;
        } else if (filter == 'Past') {
          list = provider.pastBookings;
        } else {
          list = provider.bookings;
        }

        if (list.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.science_outlined,
            title: filter == 'Upcoming' ? 'No Upcoming Lab Visits' : 'No Lab Visits Recorded',
            subtitle: 'Book full body tests or health checkups with doorstep sample collection.',
            btnText: 'Explore Lab Tests',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LabTestsPage()),
              );
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchMyLabBookings(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _LabVisitCard(
                booking: list[index],
                isDark: isDark,
              );
            },
          ),
        );
      },
    );
  }
}

class _LabVisitCard extends StatelessWidget {
  final LabBooking booking;
  final bool isDark;

  const _LabVisitCard({
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final primaryColor = themeProvider.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFEAECF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.biotech_rounded,
                    size: 30,
                    color: Color(0xFF12B76A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.packageName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.collectionAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: booking.statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Date & Time Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF2F4F7),
                ),
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF2F4F7),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: const Color(0xFF12B76A)),
                const SizedBox(width: 6),
                Text(
                  booking.displayDate,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF344054),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule_rounded, size: 14, color: const Color(0xFF12B76A)),
                const SizedBox(width: 6),
                Text(
                  booking.collectionSlot,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF344054),
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${booking.amount.toInt()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12B76A),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentSlipPage(
                            appointmentData: {
                              'orderId': booking.confirmationCode,
                              'items': [
                                {
                                  'name': booking.packageName,
                                  'price': booking.amount,
                                  'category': 'Diagnostic Test',
                                  'doctorName': 'AxioVital Certified Lab',
                                }
                              ],
                              'date': '${booking.displayDate}, ${booking.collectionSlot}',
                              'slot': booking.collectionSlot,
                              'pin': '8842',
                              'confirmationNumber': booking.confirmationCode,
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.receipt_long_rounded, size: 16, color: primaryColor),
                    label: Text(
                      'Slip',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFEAECF0),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoicePage(
                            invoiceData: {
                              'invoiceNumber': 'AX-LAB-${booking.confirmationCode}',
                              'items': [
                                {
                                  'name': booking.packageName,
                                  'qty': 1,
                                  'cost': booking.amount,
                                  'total': booking.amount,
                                }
                              ],
                              'subtotal': booking.amount,
                              'tax': booking.amount * 0.05,
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.description_outlined, size: 16, color: primaryColor),
                    label: Text(
                      'Invoice',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EMPTY STATE WIDGET
// ─────────────────────────────────────────────────────────────

Widget _buildEmptyState(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required String btnText,
  required VoidCallback onAction,
}) {
  final theme = Theme.of(context);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final primaryColor = themeProvider.primaryColor;
  final isDark = theme.brightness == Brightness.dark;

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.08),
            ),
            child: Icon(icon, size: 64, color: primaryColor),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(btnText),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    ),
  );
}

