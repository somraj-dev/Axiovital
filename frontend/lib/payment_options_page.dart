import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_provider.dart';
import 'cart_provider.dart';
import 'orders_provider.dart';
import 'orders_page.dart';
import 'notification_provider.dart';
import 'appointment_provider.dart';
import 'lab_booking_provider.dart';
import 'appointment_slip_page.dart';
import 'my_bookings_page.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
          ),
        ),
        title: const Text('Payment Options', style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF2F4F7), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPriceBanner(),
            _buildSavingsBanner(),
            const SizedBox(height: 24),
            _paymentSection('Pay by any UPI app', [
              _paymentItem(context, 'Paytm UPI', 'https://cdn-icons-png.flaticon.com/512/825/825454.png', true),
              _paymentItem(context, 'GooglePay', 'https://cdn-icons-png.flaticon.com/512/6124/6124997.png', false),
              _paymentItem(context, 'Phonepe UPI', 'https://cdn-icons-png.flaticon.com/512/5968/5968364.png', false),
            ]),
            _paymentSection('Cards', [
              _paymentItem(context, 'Add new card', null, false, action: 'Add', subtitle: 'Add New Card For Payment'),
            ]),
            _paymentSection('Wallets', [
              _paymentItem(context, 'Mobikwik', 'https://cdn-icons-png.flaticon.com/512/9334/9334542.png', false, action: 'Link'),
              _paymentItem(context, 'Amazon Pay Balance', 'https://cdn-icons-png.flaticon.com/512/5968/5968269.png', false, action: 'Link'),
              _paymentItem(context, 'Airtel Payments Bank', 'https://cdn-icons-png.flaticon.com/512/9334/9334627.png', false),
            ]),
            const SizedBox(height: 24),
            _paymentSection('More ways to pay', [
              _moreWaysItem(context, 'Pay Later', Icons.history, const Color(0xFFFEF3F2), const Color(0xFFB42318), true),
              _moreWaysItem(context, 'Netbanking', Icons.account_balance, const Color(0xFFF9FAFB), Colors.black, true),
              _moreWaysItem(context, 'Cash on delivery', Icons.payments_outlined, const Color(0xFFF9FAFB), Colors.black, false, isRadio: true),
            ]),
            const SizedBox(height: 48),
            _buildShieldFooter(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _moreWaysItem(BuildContext context, String name, IconData icon, Color bgColor, Color iconColor, bool hasChevron, {bool isRadio = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7)))),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF2F4F7))),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          if (hasChevron) const Icon(Icons.chevron_right, color: Color(0xFF667085), size: 24),
          if (isRadio) Icon(Icons.circle_outlined, color: Colors.grey.shade300, size: 24),
        ],
      ),
    );
  }

  Widget _buildShieldFooter() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 120, height: 120, decoration: BoxDecoration(color: Colors.grey.shade50.withOpacity(0.5), shape: BoxShape.circle)),
            Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.3), shape: BoxShape.circle)),
            const Icon(Icons.shield_outlined, size: 100, color: Color(0xFFEAECF0)),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Secure payments • Easy returns',
          style: TextStyle(color: Color(0xFF98A2B3), fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPriceBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(color: Color(0xFFF9FAFB), border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7)))),
      child: Row(
        children: const [
          Text('To be paid', style: TextStyle(color: Color(0xFF667085), fontSize: 14)),
          Spacer(),
          Text('₹198', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildSavingsBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFE7FDF0), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, color: Color(0xFF039855), size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Maximize savings!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF039855))),
              Text('with payment offers', style: TextStyle(fontSize: 12, color: Color(0xFF039855))),
            ],
          ),
          const Spacer(),
          const CircleAvatar(radius: 12, backgroundColor: Color(0xFF039855), child: Icon(Icons.arrow_forward, color: Colors.white, size: 14)),
        ],
      ),
    );
  }

  Widget _paymentSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 12), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        ...items,
      ],
    );
  }

  Widget _paymentItem(BuildContext context, String name, String? icon, bool isSelected, {String? action, String? subtitle}) {
    final cart = Provider.of<CartProvider>(context);
    final orders = Provider.of<OrdersProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7)))),
      child: Column(
        children: [
          Row(
            children: [
              if (icon != null) Image.network(icon, width: 44, height: 44)
              else Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.credit_card),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    if (subtitle != null) Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              if (action != null) Text(action, style: const TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold))
              else Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? const Color(0xFFFF5247) : Colors.grey.shade300),
            ],
          ),
          if (name == 'Paytm UPI' && isSelected) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (cart.items.isNotEmpty) {
                    final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
                    final checkout = Provider.of<CheckoutProvider>(context, listen: false);
                    final appointmentProv = Provider.of<AppointmentProvider>(context, listen: false);
                    final labBookingProv = Provider.of<LabBookingProvider>(context, listen: false);
                    final cartItems = cart.items.values.toList();
                    final total = cart.totalAmount;
                    
                    final hasAppointments = cartItems.any((i) => i.type == CartItemType.appointment);
                    final hasLabTests = cartItems.any((i) => i.type == CartItemType.labTest);
                    
                    // Start the 3-second processing sequence
                    _showProcessingOverlay(context, () async {
                      Appointment? bookedAppointment;
                      LabBooking? bookedLabTest;
                      
                      // --- Book doctor appointments ---
                      if (hasAppointments) {
                        for (final item in cartItems.where((i) => i.type == CartItemType.appointment)) {
                          // Set date/slot from checkout provider into appointment provider
                          appointmentProv.setSelectedDate(checkout.selectedDate);
                          if (checkout.selectedTimeSlot != null) {
                            appointmentProv.setSelectedSlot(checkout.selectedTimeSlot!);
                          }
                          
                          bookedAppointment = await appointmentProv.bookAppointment(
                            doctorId: item.id.replaceFirst('apt_', ''),
                            doctorName: item.name.replaceFirst('Appointment with ', ''),
                            doctorSpecialty: item.subtitle,
                            doctorImageUrl: '',
                            patientId: checkout.selectedPatientIds.isNotEmpty ? checkout.selectedPatientIds.first : '',
                            amount: item.price,
                            paymentMethod: 'Paytm UPI',
                          );
                        }
                        appointmentProv.resetBookingState();
                      }
                      
                      // --- Book lab tests ---
                      if (hasLabTests) {
                        final dateStr = '${checkout.selectedDate.year}-${checkout.selectedDate.month.toString().padLeft(2, '0')}-${checkout.selectedDate.day.toString().padLeft(2, '0')}';
                        for (final item in cartItems.where((i) => i.type == CartItemType.labTest)) {
                          bookedLabTest = await labBookingProv.bookLabTest(
                            packageName: item.name,
                            amount: item.price,
                            patientId: checkout.selectedPatientIds.isNotEmpty ? checkout.selectedPatientIds.first : '',
                            collectionDate: dateStr,
                            collectionSlot: checkout.selectedTimeSlot ?? '7:00 AM - 8:00 AM',
                            collectionAddress: cart.fullAddress ?? cart.address,
                            paymentMethod: 'Paytm UPI',
                          );
                        }
                      }
                      
                      // --- Also place in orders for general tracking ---
                      await orders.placeOrder(
                        cartItems, 
                        total,
                        paymentMethod: 'Paytm UPI',
                        patientId: checkout.selectedPatientIds.isNotEmpty ? checkout.selectedPatientIds.first : null,
                        appointmentDate: checkout.selectedDate.toIso8601String(),
                        timeSlot: checkout.selectedTimeSlot,
                      );
                      
                      // Build notification metadata
                      final notifMeta = <String, dynamic>{
                        'orderId': 'AXIO-${DateTime.now().millisecondsSinceEpoch}',
                        'items': cartItems.map((item) => {
                          'name': item.name,
                          'price': item.price,
                          'category': item.type.name,
                        }).toList(),
                        'date': checkout.selectedDate.toString(),
                        'slot': checkout.selectedTimeSlot,
                      };
                      
                      if (bookedAppointment != null) {
                        notifMeta['pin'] = bookedAppointment.pinCode;
                        notifMeta['confirmationNumber'] = bookedAppointment.confirmationCode;
                      }
                      
                      // Trigger notification
                      notifProvider.addNotification(
                        title: hasAppointments ? 'Appointment Confirmed' : 'Lab Test Booked',
                        subtitle: 'Booking Successful',
                        description: hasAppointments
                          ? 'Your appointment for ${cartItems.first.name} has been confirmed.'
                          : 'Your lab test ${cartItems.first.name} has been booked.',
                        type: NotificationType.admin,
                        metaData: notifMeta,
                      );
                      
                      cart.clear();
                      
                      // Navigate to appropriate confirmation page
                      if (bookedAppointment != null) {
                        _showAppointmentSuccessSheet(context, bookedAppointment);
                      } else {
                        _showSuccessSheet(context, isLabTest: hasLabTests);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Pay ₹${cart.totalAmount.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]
        ],
      ),
    );
  }

  void _showProcessingOverlay(BuildContext context, VoidCallback onComplete) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pop(context); // Close processing sheet
            onComplete();
          }
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Paper Plane with Motion Lines
              Stack(
                alignment: Alignment.center,
                children: [
                  // Motion Lines (3 lines)
                  Transform.translate(
                    offset: const Offset(-45, 15),
                    child: Column(
                      children: [
                        _motionLine(40, const Color(0xFF039855)),
                        const SizedBox(height: 8),
                        _motionLine(30, const Color(0xFF1D2939)),
                        const SizedBox(height: 8),
                        _motionLine(25, const Color(0xFF039855).withOpacity(0.5)),
                      ],
                    ),
                  ),
                  // The Plane
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOutSine,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(value * 4, value * -4),
                        child: Transform.rotate(
                          angle: -0.1,
                          child: const Icon(Icons.send_rounded, color: Color(0xFF039855), size: 100),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'Processing...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your transfer is processing',
                style: TextStyle(fontSize: 16, color: Color(0xFF667085), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 100), // Push content slightly up
            ],
          ),
        );
      },
    );
  }

  Widget _motionLine(double width, Color color) {
    return Transform.rotate(
      angle: -0.5,
      child: Container(
        width: width,
        height: 3,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  void _showSuccessSheet(BuildContext context, {bool isLabTest = false}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: Color(0xFFE7FDF0), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Color(0xFF039855), size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              isLabTest ? 'Lab Test Booked!' : 'Payment Successful!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
            ),
            const SizedBox(height: 8),
            Text(
              isLabTest
                ? 'Your lab test has been booked successfully.\nWe\'ll collect the sample at your doorstep.'
                : 'Your order has been placed successfully.\nYour cart is now empty.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085), height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close sheet
                  if (isLabTest) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyBookingsPage(initialTab: 1)));
                  } else {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(isLabTest ? 'View My Bookings' : 'View My Orders', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 54,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEAECF0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Go to Home', style: TextStyle(color: Color(0xFF344054), fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAppointmentSuccessSheet(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: Color(0xFFE7FDF0), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Color(0xFF039855), size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'Appointment Confirmed!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment with ${appointment.doctorName}\nis confirmed for ${appointment.displayDate} at ${appointment.slotTime}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085), height: 1.5),
            ),
            const SizedBox(height: 12),
            // Confirmation & PIN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAECF0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    const Text('Confirmation', style: TextStyle(color: Color(0xFF667085), fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(appointment.confirmationCode, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ]),
                  Container(width: 1, height: 32, color: const Color(0xFFEAECF0)),
                  Column(children: [
                    const Text('PIN', style: TextStyle(color: Color(0xFF667085), fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(appointment.pinCode, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  Navigator.pushReplacement(
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
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('View Appointment Slip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 54,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyBookingsPage(initialTab: 0)));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEAECF0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View My Bookings', style: TextStyle(color: Color(0xFF344054), fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
