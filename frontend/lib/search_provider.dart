import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
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
      type: map['type'],
      name: map['name'],
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
      // POINTING TO LOCAL FASTAPI BACKEND (The Real Vector Search Implementation)
      // Using 10.0.2.2 for Android Emulator, localhost for iOS/Web
      final baseUrl = 'http://localhost:8000'; 
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/semantic-search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query, 'location': 'bhopal'}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> jsonResults = data['results'] ?? [];
        _results = jsonResults.map((item) => SearchResult.fromMap(item)).toList();
        _intent = data['intent'];
      } else {
        debugPrint('FastAPI Search failed: ${response.statusCode}');
        _results = [];
      }
    } catch (e) {
      debugPrint('Error during FastAPI Search: $e');
      _results = []; 
    } finally {
      // Add mock users for verification (always add for testing, filtered by query)
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
        SearchResult(
          id: 'mock-user-3',
          type: 'user',
          name: 'guillermo.rauch',
          subtitle: 'Guillermo Rauch • Followed by vercel_fans + 8 more',
          avatarUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=1000&auto=format&fit=crop',
          rating: 5.0,
          score: 0.9,
        ),
        SearchResult(
          id: 'mock-user-4',
          type: 'user',
          name: 'naval',
          subtitle: 'Naval Ravikant • Followed by airbnb_ceo + 20 more',
          avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=1000&auto=format&fit=crop',
          rating: 4.7,
          score: 0.85,
        ),
        SearchResult(
          id: 'mock-user-5',
          type: 'user',
          name: 'lexfridman',
          subtitle: 'Lex Fridman • Followed by joe_rogan + 15 more',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1000&auto=format&fit=crop',
          rating: 4.9,
          score: 0.8,
        ),
      ];

      // Filter mocks based on query
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
