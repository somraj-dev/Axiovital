import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final List<Map<String, dynamic>> availableCoupons = [
      {
        'code': '1MGNEW',
        'title': 'Get 15% off on your first order of lab tests',
        'discount': 50.0, // Mock fixed discount
      },
      {
        'code': '1MGNEWG',
        'title': 'Get upto 15% off on your lab tests',
        'discount': 30.0,
      },
      {
        'code': '1MGSUPER',
        'title': 'Get Upto Rs 650 off on all lab tests',
        'discount': 100.0,
      },
      {
        'code': '1MGSUPERMAX',
        'title': 'Get Upto Rs 1500 off on all lab tests',
        'discount': 250.0,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Coupons & offers',
          style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEAECF0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Coupon Code',
                        hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5247),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Available coupons',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939)),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: availableCoupons.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const Divider(height: 32, thickness: 1),
              itemBuilder: (context, index) {
                final coupon = availableCoupons[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('AXIO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        const Text('LABS', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            cartProvider.applyCoupon(coupon['code'], coupon['discount']);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Coupon ${coupon['code']} applied!'),
                                backgroundColor: const Color(0xFF039855),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      coupon['code'],
                      style: const TextStyle(color: Color(0xFF039855), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coupon['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Terms & conditions',
                      style: TextStyle(color: Color(0xFF667085), fontSize: 12, decoration: TextDecoration.underline),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
