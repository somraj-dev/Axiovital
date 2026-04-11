import 'package:flutter/material.dart';
import 'cart_provider.dart';

class AxioOrder {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status; // 'Delivered', 'Refund completed', 'Shipped', etc.
  final String statusDate; // e.g., 'Oct 02, 2025'
  final String sharedBy;

  AxioOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.status = 'Delivered',
    required this.statusDate,
    this.sharedBy = 'Somraj lodhi',
  });
}

class OrdersProvider extends ChangeNotifier {
  final List<AxioOrder> _orders = [
    AxioOrder(
      id: 'ord_ins_1',
      items: [
        CartItem(
          id: 'ins_1',
          name: 'Gold Family Health Insurance',
          price: 15000,
          imagePath: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=200&auto=format&fit=crop',
          type: CartItemType.insurance,
        )
      ],
      totalAmount: 15000,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Active',
      statusDate: 'Apr 09, 2026',
    ),
    AxioOrder(
      id: 'ord_sub_1',
      items: [
        CartItem(
          id: 'sub_1',
          name: 'Axio Pro Platinum Membership',
          price: 999,
          imagePath: 'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=200&auto=format&fit=crop',
          type: CartItemType.subscription,
        )
      ],
      totalAmount: 999,
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Active',
      statusDate: 'Apr 06, 2026',
    ),
    AxioOrder(
      id: 'ord_app_1',
      items: [
        CartItem(
          id: 'app_1',
          name: 'Appointment with Dr. Jessica Smith',
          price: 500,
          imagePath: 'https://images.unsplash.com/photo-1559839734-2b71f1e3c770?q=80&w=200&auto=format&fit=crop',
          type: CartItemType.appointment,
        )
      ],
      totalAmount: 500,
      orderDate: DateTime.now().subtract(const Duration(hours: 4)),
      status: 'Confirmed',
      statusDate: 'Apr 11, 2026',
    ),
    AxioOrder(
      id: 'ord_lab_1',
      items: [
        CartItem(
          id: 'lab_1',
          name: 'Full Body Health Checkup',
          price: 2500,
          imagePath: 'https://images.unsplash.com/photo-1579154236594-c199f3665e8d?q=80&w=200&auto=format&fit=crop',
          type: CartItemType.labTest,
        )
      ],
      totalAmount: 2500,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Processing',
      statusDate: 'Apr 10, 2026',
    ),
    AxioOrder(
      id: 'ord_ess_1',
      items: [
        CartItem(
          id: 'test_1',
          name: 'The Derma Co Kojic Acid + ...',
          price: 204,
          imagePath: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=200&auto=format&fit=crop',
          type: CartItemType.essential,
        )
      ],
      totalAmount: 204,
      orderDate: DateTime(2025, 10, 2),
      status: 'Delivered',
      statusDate: 'Oct 02, 2025',
    ),
  ];

  List<AxioOrder> get orders => [..._orders].reversed.toList();

  void placeOrder(List<CartItem> cartItems, double totalAmount) {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final statusDate = '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';

    final newOrder = AxioOrder(
      id: 'AXIO-${now.millisecondsSinceEpoch}',
      items: List.from(cartItems),
      totalAmount: totalAmount,
      orderDate: now,
      status: 'Processing',
      statusDate: statusDate,
    );

    _orders.add(newOrder);
    notifyListeners();
  }
}
