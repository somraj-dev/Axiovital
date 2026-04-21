import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';

class SearchResult {
  final String id;
  final String type;
  final String name;
  final String subtitle;
  final double rating;
  final double score;
  final double? price;

  SearchResult({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.score,
    this.price,
  });

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['entity_id'] ?? map['id'].toString(),
      type: map['type'],
      name: map['name'],
      subtitle: map['subtitle'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      price: map['price'] != null ? (map['price'] as num).toDouble() : null,
    );
  }
}

class SearchProvider with ChangeNotifier {
  List<SearchResult> _results = [];
  bool _isLoading = false;
  String? _intent;
  Timer? _debounce;

  List<SearchResult> get results => _results;
  bool get isLoading => _isLoading;
  String? get intent => _intent;

  // Grouped results
  List<SearchResult> get topResults => _results.take(3).toList();
  List<SearchResult> get doctors => _results.where((r) => r.type == 'doctor').toList();
  List<SearchResult> get medicines => _results.where((r) => r.type == 'medicine').toList();
  List<SearchResult> get labs => _results.where((r) => r.type == 'lab').toList();
  List<SearchResult> get users => _results.where((r) => r.type == 'user').toList();

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.length < 2) {
      _results = [];
      _intent = null;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      performSearch(query);
    });
  }

  Future<void> performSearch(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Invoke the Supabase Edge Function "hyper-function"
      final response = await SupabaseService.client.functions.invoke(
        'hyper-function',
        body: {'query': query, 'location': 'bhopal'},
      );

      if (response.status == 200) {
        final List<dynamic> jsonResults = response.data['results'] ?? [];
        _results = jsonResults.map((item) => SearchResult.fromMap(item)).toList();
        _intent = response.data['intent'];
      } else {
        debugPrint('Cloud Search failed: ${response.status}');
      }

      // Add mock user for verification (always add for testing)
      _results.add(SearchResult(
        id: 'mock-user-1',
        type: 'user',
        name: 'Ilya Miskov',
        subtitle: 'Human interface designer at Clubs',
        rating: 4.9,
        score: 1.0,
      ));
    } catch (e) {
      debugPrint('Error during Cloud Search: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _results = [];
    _intent = null;
    notifyListeners();
  }
}
