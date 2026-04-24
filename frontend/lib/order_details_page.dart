import 'package:flutter/material.dart';
import 'orders_provider.dart';
import 'cart_provider.dart';
import 'invoice_page.dart';

class OrderDetailsPage extends StatelessWidget {
  final AxioOrder order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Determine the primary type of the order from the first item
    final type = order.items.isNotEmpty ? order.items.first.type : CartItemType.essential;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoicePage(
                    invoiceData: {
                      'invoiceNumber': 'AX-INV-${order.items.isNotEmpty ? order.items.first.name.substring(0,3).toUpperCase() : "ORD"}-${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}',
                      'items': order.items.map((item) => {
                        'name': item.name,
                        'qty': item.quantity,
                        'cost': item.price,
                        'total': item.price * item.quantity,
                      }).toList(),
                      'subtotal': order.totalAmount,
                      'tax': order.totalAmount * 0.1,
                      'total': order.totalAmount * 1.1,
                    },
                  ),
                ),
              );
            },
            tooltip: 'View Invoice',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTrackingHeader(type),
            const SizedBox(height: 24),
            _buildHorizontalTracker(type),
            const SizedBox(height: 32),
            _buildActionButton(type),
            const SizedBox(height: 32),
            _buildDynamicDetailsCard(type),
            const SizedBox(height: 24),
            _buildPersonnelCard(type),
            const SizedBox(height: 24),
            _buildDynamicTimeline(type),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingHeader(CartItemType type) {
    String label = 'Tracking ID:';
    if (type == CartItemType.appointment || type == CartItemType.labTest) label = 'Booking ID:';
    if (type == CartItemType.insurance) label = 'Policy ID:';
    if (type == CartItemType.subscription) label = 'Subscriber ID:';

    String statusText = 'In Transit';
    Color statusColor = const Color(0xFF175CD3);
    Color bgColor = const Color(0xFFEFF8FF);

    if (order.status == 'Processing') {
      statusText = 'Processing';
      statusColor = const Color(0xFFB54708);
      bgColor = const Color(0xFFFFFAEB);
    } else if (order.status == 'Confirmed' || order.status == 'Active') {
      statusText = order.status;
      statusColor = const Color(0xFF039855);
      bgColor = const Color(0xFFECFDF3);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              type == CartItemType.appointment ? Icons.calendar_today : 
              type == CartItemType.labTest ? Icons.biotech : 
              type == CartItemType.essential ? Icons.inventory_2 : Icons.verified_user,
              color: const Color(0xFF1D2939)
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      order.items.isNotEmpty ? 'AXV-${order.items.first.name.substring(0,3).toUpperCase()}-P21' : 'AXV-ORD-P21',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF98A2B3)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalTracker(CartItemType type) {
    List<String> steps = ['Received', 'In Transit', 'Delivered'];
    if (type == CartItemType.appointment) steps = ['Booked', 'Arrived', 'Consulting'];
    if (type == CartItemType.labTest) steps = ['Collected', 'Processing', 'Shared'];
    if (type == CartItemType.subscription || type == CartItemType.insurance) steps = ['Paid', 'Verified', 'Active'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _trackerCircle(true),
              _trackerLine(true),
              _trackerCircle(order.status != 'Processing'),
              _trackerLine(order.status != 'Processing' && order.status != 'Confirmed'),
              _trackerCircle(order.status == 'Delivered' || order.status == 'Active'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _trackerLabel(steps[0], '10:30am'),
              _trackerLabel(steps[1], order.status == 'Processing' ? 'Pending' : '12:00pm'),
              _trackerLabel(steps[2], (order.status == 'Delivered' || order.status == 'Active') ? 'Done' : 'Pending'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trackerCircle(bool completed) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: completed ? const Color(0xFF1D2939) : const Color(0xFFD0D5DD),
        shape: BoxShape.circle,
      ),
      child: completed ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
    );
  }

  Widget _trackerLine(bool completed) {
    return Expanded(
      child: Container(
        height: 2,
        color: completed ? const Color(0xFF1D2939) : const Color(0xFFD0D5DD),
      ),
    );
  }

  Widget _trackerLabel(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1D2939))),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
      ],
    );
  }

  Widget _buildActionButton(CartItemType type) {
    String text = 'Track Shipping';
    IconData icon = Icons.location_searching_rounded;

    if (type == CartItemType.appointment) {
      text = 'Join Consultation';
      icon = Icons.videocam_outlined;
    } else if (type == CartItemType.labTest) {
      text = 'Track Technician';
      icon = Icons.person_search_outlined;
    } else if (type == CartItemType.insurance || type == CartItemType.subscription) {
      text = 'Download Certificate';
      icon = Icons.file_download_outlined;
    }

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF101828),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicDetailsCard(CartItemType type) {
    String title = 'Delivery Details';
    IconData titleIcon = Icons.local_shipping_outlined;
    List<Widget> rows = [];

    if (type == CartItemType.appointment) {
      title = 'Appointment Details';
      titleIcon = Icons.medical_services_outlined;
      rows = [
        _detailRow('Patient', 'John Doe'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Provider', 'Dr. Jessica Smith'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Location', 'Axio Center, MG Road'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Time Slot', 'Tomorrow, 4:00 PM'),
      ];
    } else if (type == CartItemType.labTest) {
      title = 'Lab Test Details';
      titleIcon = Icons.biotech_outlined;
      rows = [
        _detailRow('Patient', 'John Doe'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Test Name', order.items.isNotEmpty ? order.items.first.name : 'Full Body Checkup'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Collection', 'Home Collection'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Assigned Lab', 'Axio Diagnostics'),
      ];
    } else if (type == CartItemType.insurance) {
      title = 'Policy Details';
      titleIcon = Icons.shield_outlined;
      rows = [
        _detailRow('Policy Holder', 'John Doe'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Plan Name', 'Gold Family Shield'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Sum Insured', '₹ 10,00,000'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Validity', 'Ends 12 Apr 2027'),
      ];
    } else if (type == CartItemType.subscription) {
      title = 'Membership Details';
      titleIcon = Icons.stars_outlined;
      rows = [
        _detailRow('Member', 'John Doe'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Plan', 'Axio Pro Platinum'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Benefits', 'Free Home Samples'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Renewal', 'Oct 2026'),
      ];
    } else {
      // Essential
      rows = [
        _detailRow('Receiver', 'John Doe'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Address', '12, Palm Groove'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Contact', '+234 - 123 - 201 - 419'),
        const Divider(height: 24, color: Color(0xFFF2F4F7)),
        _detailRow('Item', order.items.isNotEmpty ? order.items.first.name : 'Essential Pack'),
      ];
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(titleIcon, color: const Color(0xFF98A2B3), size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(color: Color(0xFF98A2B3), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ...rows,
                const Divider(height: 24, color: Color(0xFFF2F4F7)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Note', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w500)),
                    Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded, color: Color(0xFFFDA29B), size: 16),
                        SizedBox(width: 4),
                        Text('Fragile', style: TextStyle(color: Color(0xFFF04438), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildPersonnelCard(CartItemType type) {
    String name = 'Mr John';
    String role = 'Contact Rider';
    String avatar = 'https://i.pravatar.cc/150?u=rider';

    if (type == CartItemType.appointment) {
      name = 'Dr. Jessica Smith';
      role = 'Dermatologist';
      avatar = 'https://i.pravatar.cc/150?u=doc';
    } else if (type == CartItemType.labTest) {
      name = 'Amit Sharma';
      role = 'Lab Technician';
      avatar = 'https://i.pravatar.cc/150?u=tech';
    } else if (type == CartItemType.insurance || type == CartItemType.subscription) {
      name = 'Axio Support';
      role = 'Service Manager';
      avatar = 'https://i.pravatar.cc/150?u=support';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1D2939))),
                Text(role, style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12)),
              ],
            ),
          ),
          _iconButton(Icons.chat_bubble_outline),
          const SizedBox(width: 8),
          _iconButton(Icons.call_outlined, isBlack: true),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {bool isBlack = false}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isBlack ? const Color(0xFF101828) : Colors.white,
        shape: BoxShape.circle,
        border: isBlack ? null : Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Icon(icon, color: isBlack ? Colors.white : const Color(0xFF101828), size: 20),
    );
  }

  Widget _buildDynamicTimeline(CartItemType type) {
    List<Widget> timelineItems = [];

    if (type == CartItemType.appointment) {
      timelineItems = [
        _timelineItem('9:30am', 'Today', 'Payment confirmed. Appointment booked with Dr. Jessica.', true),
        _timelineItem('10:00am', 'Today', 'Digital consultation room prepared.', true),
        _timelineItem('Pending', '--', 'Doctor will join the session at the scheduled time.', false, isLast: true),
      ];
    } else if (type == CartItemType.labTest) {
      timelineItems = [
        _timelineItem('9:30am', 'Yesterday', 'Order placed. Technician assigned for home collection.', true),
        _timelineItem('8:00am', 'Today', 'Technician is out for sample collection.', true),
        _timelineItem('Pending', '--', 'Sample will be sent to the lab for analysis.', false, isLast: true),
      ];
    } else if (type == CartItemType.insurance || type == CartItemType.subscription) {
      timelineItems = [
        _timelineItem('9:30am', '11 Apr', 'Payment successful. Onboarding process initiated.', true),
        _timelineItem('11:00am', '11 Apr', 'KYC and documents verified successfully.', true),
        _timelineItem('Done', '12 Apr', 'Policy/Subscription is now fully active.', true, isLast: true),
      ];
    } else {
      timelineItems = [
        _timelineItem('9:30am', '16 Jan 2026', 'The package has reached the local delivery center and is being sorted.', true),
        _timelineItem('12:00pm', '16 Jan 2026', 'The package is out for delivery. Estimated delivery by today.', true),
        _timelineItem('3:45pm', '20 Jun 2026', 'The package arrived distribution center. Item is being processed.', false, isLast: true),
      ];
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7).withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFD0D5DD), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          ...timelineItems,
        ],
      ),
    );
  }

  Widget _timelineItem(String time, String date, String desc, bool completed, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1D2939), fontSize: 14)),
                Text(date, style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: completed ? const Color(0xFF1D2939) : Colors.white,
                  shape: BoxShape.circle,
                  border: completed ? null : Border.all(color: const Color(0xFFD0D5DD), width: 2),
                ),
                child: Icon(Icons.check, color: completed ? Colors.white : Colors.transparent, size: 12),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, color: const Color(0xFFD0D5DD)),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                desc,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 12, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
