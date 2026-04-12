import 'package:flutter/material.dart';

enum CartItemType { labTest, appointment, essential, insurance, subscription }

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final CartItemType type;
  final String subtitle;
  final String timing;
  final String fulfilledBy;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.type,
    this.subtitle = '',
    this.timing = '',
    this.fulfilledBy = 'AxioVital Labs',
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String _address = 'Gwalior';
  String? _fullAddress;
  String? _appliedCoupon;
  double _couponDiscount = 0.0;
  
  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;
  String get address => _address;
  String? get fullAddress => _fullAddress;
  String? get appliedCoupon => _appliedCoupon;

  double get totalMRP {
    double total = 0.0;
    _items.forEach((key, item) {
      // Assuming original price is roughly 1.7x for mock purposes
      total += (item.price * 1.7) * item.quantity;
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return (total - _couponDiscount).clamp(0.0, double.infinity);
  }

  double get totalSavings => (totalMRP - totalAmount).clamp(0.0, double.infinity);
  double get couponDiscountAmount => _couponDiscount;

  void applyCoupon(String code, double discountAmount) {
    _appliedCoupon = code;
    _couponDiscount = discountAmount;
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _couponDiscount = 0.0;
    notifyListeners();
  }

  void setAddress(String city, String full) {
    _address = city;
    _fullAddress = full;
    notifyListeners();
  }

  void addItem({
    required String productId,
    required String name,
    required double price,
    required String imagePath,
    required CartItemType type,
    String subtitle = '',
    String timing = '',
    String fulfilledBy = 'AxioVital Labs',
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          imagePath: existing.imagePath,
          type: existing.type,
          subtitle: existing.subtitle,
          timing: existing.timing,
          fulfilledBy: existing.fulfilledBy,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          name: name,
          price: price,
          imagePath: imagePath,
          type: type,
          subtitle: subtitle,
          timing: timing,
          fulfilledBy: fulfilledBy,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items.update(
          productId,
          (existing) => CartItem(
            id: existing.id,
            name: existing.name,
            price: existing.price,
            imagePath: existing.imagePath,
            type: existing.type,
            subtitle: existing.subtitle,
            timing: existing.timing,
            fulfilledBy: existing.fulfilledBy,
            quantity: quantity,
          ),
        );
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Grouped getters
  List<CartItem> get labTests => _items.values.where((i) => i.type == CartItemType.labTest).toList();
  List<CartItem> get appointments => _items.values.where((i) => i.type == CartItemType.appointment).toList();
  List<CartItem> get essentials => _items.values.where((i) => i.type == CartItemType.essential).toList();
  List<CartItem> get subscriptions => _items.values.where((i) => i.type == CartItemType.subscription).toList();
}
