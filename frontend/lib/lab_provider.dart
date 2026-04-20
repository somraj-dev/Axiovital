import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LabPackage {
  final String id;
  final String name;
  final String discountTag;
  final String imageUrl;
  final int testCount;
  final double currentPrice;
  final double originalPrice;
  final bool isMostBooked;
  final String category;

  LabPackage({
    required this.id,
    required this.name,
    required this.discountTag,
    required this.imageUrl,
    required this.testCount,
    required this.currentPrice,
    required this.originalPrice,
    this.isMostBooked = false,
    this.category = 'General',
  });
}

class LabProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<LabPackage> _packages = [];
  bool _isLoading = false;

  List<LabPackage> get packages => _packages;
  bool get isLoading => _isLoading;

  Future<void> fetchPackages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase.from('lab_packages').select();

      _packages = data.map((json) => LabPackage(
        id: json['id'],
        name: json['name'],
        discountTag: json['discount_tag'] ?? '',
        imageUrl: json['image_url'] ?? '',
        testCount: json['test_count'] ?? 0,
        currentPrice: (json['current_price'] as num).toDouble(),
        originalPrice: (json['original_price'] as num).toDouble(),
        isMostBooked: json['is_most_booked'] ?? false,
        category: json['category'] ?? 'General',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching lab packages: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
