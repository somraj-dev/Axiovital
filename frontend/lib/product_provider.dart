import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String quantity;
  final double rating;
  final int ratingCount;
  final String deliveryDate;
  final double currentPrice;
  final double originalPrice;
  final int discount;
  final String imagePath;
  final String category;
  final bool isBestSeller;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.quantity,
    required this.rating,
    required this.ratingCount,
    required this.deliveryDate,
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
    required this.imagePath,
    required this.category,
    this.isBestSeller = false,
    this.description = '',
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      quantity: map['quantity'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      ratingCount: map['rating_count'] ?? 0,
      deliveryDate: map['delivery_date'] ?? 'Tomorrow',
      currentPrice: (map['current_price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (map['original_price'] as num?)?.toDouble() ?? 0.0,
      discount: map['discount'] ?? 0,
      imagePath: map['image_path'] ?? '',
      category: map['category'] ?? 'All',
      isBestSeller: map['is_best_seller'] ?? false,
      description: map['description'] ?? '',
    );
  }
}

class ProductProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);
      
      _allProducts = data.map((item) => Product.fromMap(item)).toList();
      
      // Extract unique categories
      final uniqueCats = _allProducts.map((p) => p.category).toSet().toList();
      _categories = ['All', ...uniqueCats];
      
      _filterProducts();
    } catch (e) {
      debugPrint('Error loading products from Supabase: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _filterProducts();
    notifyListeners();
  }

  void _filterProducts() {
    if (_selectedCategory == 'All') {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }
}
