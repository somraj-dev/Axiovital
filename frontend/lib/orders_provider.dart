import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_provider.dart';

class AxioOrder {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final String statusDate;
  final String sharedBy;

  AxioOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.statusDate,
    this.sharedBy = 'Somraj lodhi',
  });
}

class OrdersProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<AxioOrder> _orders = [];
  bool _isLoading = false;

  List<AxioOrder> get orders => _orders;
  bool get isLoading => _isLoading;

  OrdersProvider() {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> ordersData = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', user.id)
          .order('order_date', ascending: false);

      _orders = ordersData.map((o) {
        final List<dynamic> itemsData = o['order_items'] ?? [];
        final items = itemsData.map((i) => CartItem(
          id: i['product_id'],
          name: i['name'],
          price: (i['price'] as num).toDouble(),
          imagePath: '', // Usually stored in catalogs, not order history for brevity
          type: _parseCartItemType(i['item_type']),
          subtitle: i['time_slot'] ?? '',
        )).toList();

        final date = DateTime.parse(o['order_date']);
        
        return AxioOrder(
          id: o['id'],
          items: items,
          totalAmount: (o['total_amount'] as num).toDouble(),
          orderDate: date,
          status: o['status'],
          statusDate: '${_monthName(date.month)} ${date.day.toString().padLeft(2, '0')}, ${date.year}',
        );
      }).toList();

    } catch (e) {
      debugPrint('Error fetching orders: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> placeOrder(List<CartItem> cartItems, double totalAmount, {String? paymentMethod, String? patientId, String? appointmentDate, String? timeSlot}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Insert Order
      final orderResponse = await _supabase.from('orders').insert({
        'user_id': user.id,
        'total_amount': totalAmount,
        'payment_method': paymentMethod ?? 'UPI',
        'status': 'Confirmed',
      }).select().single();

      final orderId = orderResponse['id'];

      // 2. Insert Order Items
      final itemsToInsert = cartItems.map((item) => {
        'order_id': orderId,
        'product_id': item.id,
        'item_type': item.type.name,
        'name': item.name,
        'price': item.price,
        'patient_id': patientId,
        'appointment_date': appointmentDate,
        'time_slot': timeSlot,
      }).toList();

      await _supabase.from('order_items').insert(itemsToInsert);

      await fetchOrders();
    } catch (e) {
      debugPrint('Error placing order: $e');
    }
  }

  CartItemType _parseCartItemType(String type) {
    return CartItemType.values.firstWhere((e) => e.name == type, orElse: () => CartItemType.essential);
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
