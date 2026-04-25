import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'services/supabase_service.dart';

class SearchResult {
  final String id;
  final String type;
  final String name;
  final String subtitle;
  final double rating;
  final double score;
  final String? avatarUrl;
  final double? price;

  SearchResult({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.score,
    this.avatarUrl,
    this.price,
  });

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['entity_id'] ?? map['id'].toString(),
      type: map['type'] ?? 'unknown',
      name: map['name'] ?? 'Unknown',
      subtitle: map['subtitle'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: map['avatar_url'],
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
      // 🚀 SUPABASE EDGE FUNCTIONS (Cloud-Native Vector Search)
      final supabase = Supabase.instance.client;
      final response = await supabase.functions.invoke(
        'semantic-search',
        body: {'query': query},
      );

      if (response.status == 200) {
        final data = response.data;
        final List<dynamic> jsonResults = data['results'] ?? [];
        
        // Convert Supabase results (doctor objects) into SearchResult objects
        _results = jsonResults.map((item) => SearchResult(
          id: item['id'].toString(),
          type: 'doctor', 
          name: item['name'] ?? 'Unknown Doctor',
          subtitle: item['specialty'] ?? 'Specialist',
          rating: 4.5, // Standard rating display
          score: (item['similarity'] as num? ?? 0.0).toDouble(),
          avatarUrl: item['image_url'],
        )).toList();
        
        _intent = data['intent'];
      } else {
        debugPrint('Supabase Edge Search failed: ${response.status}');
        _results = [];
      }
    } catch (e) {
      debugPrint('Error during Supabase Edge Search: $e');
      _results = []; 
    } finally {
      // Add mock users for community search verification
      final allMocks = [
        SearchResult(
          id: 'mock-user-1',
          type: 'user',
          name: 'ilya.miskov',
          subtitle: 'Ilya Miskov • Followed by alex_dev + 12 more',
          avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000&auto=format&fit=crop',
          rating: 4.9,
          score: 1.0,
        ),
        SearchResult(
          id: 'mock-user-2',
          type: 'user',
          name: 'sarah_drasner',
          subtitle: 'Sarah Drasner • Followed by netlify_team + 5 more',
          avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop',
          rating: 4.8,
          score: 0.95,
        ),
      ];

      final filteredMocks = allMocks.where((m) => 
        m.name.toLowerCase().contains(query.toLowerCase()) || 
        m.subtitle.toLowerCase().contains(query.toLowerCase())
      ).toList();

      _results.addAll(filteredMocks);

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
