import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      quantity: json['quantity'],
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'],
      deliveryDate: json['deliveryDate'],
      currentPrice: (json['currentPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discount: json['discount'],
      imagePath: json['imagePath'],
      category: json['category'],
      isBestSeller: json['isBestSeller'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class ProductProvider with ChangeNotifier {
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
      final String response = await rootBundle.loadString('assets/data/products.json');
      final data = await json.decode(response);
      
      _categories = ['All', ...List<String>.from(data['categories'] ?? [])];
      _allProducts = (data['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      
      _filterProducts();
    } catch (e) {
      debugPrint('Error loading products: $e');
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
