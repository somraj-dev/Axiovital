import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lab_booking_provider.dart';
import 'lab_tests_page.dart';

class TestBookingsPage extends StatefulWidget {
  const TestBookingsPage({super.key});

  @override
  State<TestBookingsPage> createState() => _TestBookingsPageState();
}

class _TestBookingsPageState extends State<TestBookingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LabBookingProvider>(context, listen: false).fetchMyLabBookings();
    });
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
          'Test Bookings',
          style: TextStyle(color: Color(0xFF1D2939), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<LabBookingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5247)));
          }

          if (provider.bookings.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            color: const Color(0xFFFF5247),
            onRefresh: () => provider.fetchMyLabBookings(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.bookings.length,
              itemBuilder: (context, index) {
                final booking = provider.bookings[index];
                return _buildBookingCard(booking);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(LabBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.science, color: Color(0xFFE11D48), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.packageName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1D2939))),
                const SizedBox(height: 4),
                Text('${booking.displayDate} • ${booking.collectionSlot}', style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
                const SizedBox(height: 4),
                Text('₹${booking.amount.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: booking.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(booking.statusLabel, style: TextStyle(color: booking.statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), shape: BoxShape.circle),
            child: const Icon(Icons.science_outlined, size: 56, color: Color(0xFF98A2B3)),
          ),
          const SizedBox(height: 32),
          const Text(
            'No test bookings found',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Start booking lab tests at discounted prices',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085), fontSize: 15, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LabTestsPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D2939),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
              elevation: 0,
            ),
            child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
