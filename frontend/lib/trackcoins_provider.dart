import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrackcoinTransaction {
  final String id;
  final String type; // earned, spent, refund, bonus, expired
  final int amount;
  final String title;
  final String? description;
  final String? source;
  final String status;
  final String? referenceId;
  final DateTime createdAt;
  final Color color;
  final IconData icon;

  TrackcoinTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    this.description,
    this.source,
    this.status = 'completed',
    this.referenceId,
    required this.createdAt,
    this.color = Colors.blue,
    this.icon = Icons.toll_rounded,
  });
}

class TrackcoinOffer {
  final String title;
  final String description;
  final int coinsReward;
  final String? validity;

  TrackcoinOffer({required this.title, required this.description, required this.coinsReward, this.validity});
}

class TrackcoinsProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  int _availableBalance = 0;
  int _earnedTotal = 0;
  int _spentTotal = 0;
  List<TrackcoinTransaction> _transactions = [];
  bool _isLoading = false;

  int get availableBalance => _availableBalance;
  int get earnedTotal => _earnedTotal;
  int get spentTotal => _spentTotal;
  int get lockedBalance => 0; // Mocked
  int get expiringBalance => 0; // Mocked
  String get expiringDate => '30 Jun 2026';
  double get coinValue => _availableBalance * 0.5;
  List<TrackcoinTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  List<TrackcoinOffer> get offers => [
    TrackcoinOffer(title: 'Complete Health Profile', description: 'Fill all details to earn bonus coins', coinsReward: 50, validity: 'Expires in 2 days'),
    TrackcoinOffer(title: 'Sync Wearable', description: 'Connect your watch for daily rewards', coinsReward: 100),
  ];

  List<Map<String, dynamic>> get earningRules => [
    {'activity': 'Daily Steps (10k)', 'coins': 10, 'icon': Icons.directions_walk, 'color': Colors.green, 'status': 'available'},
    {'activity': 'Upload Lab Report', 'coins': 20, 'icon': Icons.upload_file, 'color': Colors.blue, 'status': 'available'},
  ];

  List<Map<String, dynamic>> get redemptionOptions => [
    {'title': 'Consultation Discount', 'description': 'Get ₹200 off on next visit', 'coins': 400, 'icon': Icons.local_hospital, 'color': Colors.red},
    {'title': 'Amazon Gift Card', 'description': '₹100 Amazon Voucher', 'coins': 200, 'icon': Icons.shopping_bag, 'color': Colors.orange},
  ];

  TrackcoinsProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase
          .from('trackcoin_transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _transactions = data.map((json) {
        final type = json['type'] ?? 'earned';
        Color color = Colors.blue;
        IconData icon = Icons.toll_rounded;
        
        if (type == 'earned') { color = Colors.green; icon = Icons.add_circle_outline; }
        else if (type == 'spent') { color = Colors.red; icon = Icons.remove_circle_outline; }
        else if (type == 'refund') { color = Colors.orange; icon = Icons.replay; }

        return TrackcoinTransaction(
          id: json['id'],
          type: type,
          amount: json['amount'],
          title: json['title'] ?? 'Transaction',
          source: json['source'],
          status: json['status'] ?? 'completed',
          referenceId: json['reference_id'],
          createdAt: DateTime.parse(json['created_at']),
          color: color,
          icon: icon,
        );
      }).toList();

      // Calculate aggregates
      _earnedTotal = _transactions
          .where((t) => t.type == 'earned' || t.type == 'bonus')
          .fold(0, (sum, item) => sum + item.amount);
      
      _spentTotal = _transactions
          .where((t) => t.type == 'spent')
          .fold(0, (sum, item) => sum + item.amount);

      _availableBalance = _earnedTotal - _spentTotal;

    } catch (e) {
      debugPrint('Error fetching Trackcoins: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> earnCoins(int amount, String title, String source) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('trackcoin_transactions').insert({
        'user_id': user.id,
        'type': 'earned',
        'amount': amount,
        'title': title,
        'source': source,
      });
      await fetchData();
    } catch (e) {
      debugPrint('Error earning coins: $e');
    }
  }

  Future<void> spendCoins(int amount, String title, String source, [String? refId]) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('trackcoin_transactions').insert({
        'user_id': user.id,
        'type': 'spent',
        'amount': amount,
        'title': title,
        'source': source,
        'reference_id': refId,
      });
      await fetchData();
    } catch (e) {
      debugPrint('Error spending coins: $e');
    }
  }
  List<TrackcoinTransaction> getFilteredTransactions(String filter) {
    if (filter == 'All') return _transactions;
    return _transactions.where((t) => t.type.toLowerCase() == filter.toLowerCase()).toList();
  }
}
