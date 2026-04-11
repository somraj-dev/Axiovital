import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_provider.dart';
import 'cart_provider.dart';
import 'orders_provider.dart';
import 'orders_page.dart';

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
                    final cartItems = cart.items.values.toList();
                    final total = cart.totalAmount;
                    
                    // Start the 3-second processing sequence
                    _showProcessingOverlay(context, () {
                      orders.placeOrder(cartItems, total);
                      
                      // Trigger notification
                      notifProvider.addNotification(
                        title: 'Appointment Confirmed',
                        subtitle: 'Booking Successful',
                        description: 'Your appointment for ${cartItems.first.name} has been confirmed.',
                        type: NotificationType.admin,
                        metaData: {
                          'orderId': 'AXIO-${DateTime.now().millisecondsSinceEpoch}',
                          'items': cartItems.map((item) => {
                            'name': item.name,
                            'price': item.price,
                            'category': item.category,
                          }).toList(),
                          'date': 'Tomorrow, 10:30 AM',
                          'pin': '8842',
                          'confirmationNumber': 'CONF-7629-XB',
                        },
                      );
                      
                      // Immediate visual feedback for debugging and UX
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Appointment confirmed! Check your notifications.'),
                          backgroundColor: Color(0xFF039855),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      
                      cart.clear();
                      _showSuccessSheet(context);
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

  void _showSuccessSheet(BuildContext context) {
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
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed successfully.\nYour cart is now empty.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF667085), height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close sheet
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('View My Orders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
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
}
