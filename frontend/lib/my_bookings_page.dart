import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orders_provider.dart';
import 'cart_provider.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D2939)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, ordersProvider, child) {
          final appointments = ordersProvider.orders
              .where((o) => o.items.any((i) => i.type == CartItemType.appointment))
              .toList();

          return Column(
            children: [
              // Tab Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 100,
                      height: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEAECF0)),
              
              if (ordersProvider.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (appointments.isEmpty)
                _buildEmptyState(context)
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final order = appointments[index];
                      final item = order.items.firstWhere((i) => i.type == CartItemType.appointment);
                      return _buildBookingCard(context, order, item);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, AxioOrder order, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                child: const Icon(Icons.calendar_month, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(order.statusDate, style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE7FDF0), borderRadius: BorderRadius.circular(6)),
                child: Text(order.status, style: const TextStyle(color: Color(0xFF039855), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID: ${order.id}', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12)),
              const Text('Reschedule', style: TextStyle(color: Color(0xFF1B80BF), fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200, width: 200,
                decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(24)),
                child: const Center(child: Icon(Icons.calendar_month, size: 100, color: Color(0xFF2E90FA))),
              ),
              const SizedBox(height: 32),
              const Text('You haven’t booked any appointments yet', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
              const SizedBox(height: 12),
              const Text('Start by looking for doctors near you, read patient stories and book appointments', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF667085), height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B80BF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                  child: const Text('Book Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
