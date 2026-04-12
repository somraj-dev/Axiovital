import 'package:flutter/material.dart';

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
  final IconData icon;
  final Color color;

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
    required this.icon,
    required this.color,
  });
}

class TrackcoinOffer {
  final String id;
  final String title;
  final String description;
  final int coinsReward;
  final int coinsRequired;
  final String offerType; // earn, redeem, bonus
  final String? validity;
  final String iconType;
  final bool isClaimed;

  TrackcoinOffer({
    required this.id,
    required this.title,
    required this.description,
    this.coinsReward = 0,
    this.coinsRequired = 0,
    this.offerType = 'earn',
    this.validity,
    this.iconType = 'star',
    this.isClaimed = false,
  });
}

class TrackcoinsProvider extends ChangeNotifier {
  int _availableBalance = 1250;
  int _earnedTotal = 2480;
  int _spentTotal = 1230;
  int _lockedBalance = 150;
  int _expiringBalance = 75;
  String _expiringDate = '25 Apr 2026';
  int _appliedCoins = 0;

  // Getters
  int get availableBalance => _availableBalance;
  int get earnedTotal => _earnedTotal;
  int get spentTotal => _spentTotal;
  int get lockedBalance => _lockedBalance;
  int get expiringBalance => _expiringBalance;
  String get expiringDate => _expiringDate;
  int get appliedCoins => _appliedCoins;
  double get coinValue => _availableBalance * 0.5; // 1 coin = ₹0.50

  // Earning rules
  List<Map<String, dynamic>> get earningRules => [
    {'activity': 'Daily Health Streak', 'coins': 10, 'icon': Icons.local_fire_department_rounded, 'color': const Color(0xFFFF6B35), 'status': 'available', 'progress': 0.7},
    {'activity': 'Doctor Booking', 'coins': 50, 'icon': Icons.medical_services_rounded, 'color': const Color(0xFF2E90FA), 'status': 'available', 'progress': 1.0},
    {'activity': 'Medicine Purchase', 'coins': 25, 'icon': Icons.medication_rounded, 'color': const Color(0xFF12B76A), 'status': 'available', 'progress': 1.0},
    {'activity': 'Referral Reward', 'coins': 100, 'icon': Icons.group_add_rounded, 'color': const Color(0xFF7C3AED), 'status': 'available', 'progress': 1.0},
    {'activity': 'Habit Tracker Completion', 'coins': 15, 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981), 'status': 'in_progress', 'progress': 0.4},
    {'activity': 'Community Participation', 'coins': 20, 'icon': Icons.people_rounded, 'color': const Color(0xFFF59E0B), 'status': 'available', 'progress': 1.0},
    {'activity': 'Wearable Sync Consistency', 'coins': 30, 'icon': Icons.watch_rounded, 'color': const Color(0xFF06B6D4), 'status': 'in_progress', 'progress': 0.6},
    {'activity': 'Health Goal Completion', 'coins': 75, 'icon': Icons.flag_rounded, 'color': const Color(0xFFE11D48), 'status': 'locked', 'progress': 0.0},
  ];

  // Redemption options
  List<Map<String, dynamic>> get redemptionOptions => [
    {'title': 'Doctor Appointment Discount', 'coins': 200, 'description': 'Flat ₹100 off on next appointment', 'icon': Icons.medical_services_outlined, 'color': const Color(0xFF2E90FA)},
    {'title': 'Medicine Order Discount', 'coins': 150, 'description': '15% off on medicine orders above ₹500', 'icon': Icons.medication_outlined, 'color': const Color(0xFF12B76A)},
    {'title': 'Premium Consultation Unlock', 'coins': 500, 'description': '1 free premium video consultation', 'icon': Icons.videocam_outlined, 'color': const Color(0xFF7C3AED)},
    {'title': 'Health Checkup Cashback', 'coins': 300, 'description': 'Get ₹150 cashback on health checkups', 'icon': Icons.science_outlined, 'color': const Color(0xFFF59E0B)},
    {'title': 'Subscription Discount', 'coins': 400, 'description': '20% off on Premium Care Plan', 'icon': Icons.stars_rounded, 'color': const Color(0xFFE11D48)},
    {'title': 'Community Program Pass', 'coins': 100, 'description': 'Access any paid community program', 'icon': Icons.groups_outlined, 'color': const Color(0xFF06B6D4)},
  ];

  // Transactions
  List<TrackcoinTransaction> get transactions => [
    TrackcoinTransaction(id: 'T001', type: 'earned', amount: 50, title: 'Daily health streak completed', source: 'streak', status: 'completed', createdAt: DateTime.now().subtract(const Duration(hours: 2)), icon: Icons.local_fire_department_rounded, color: const Color(0xFF12B76A)),
    TrackcoinTransaction(id: 'T002', type: 'spent', amount: 200, title: 'Doctor appointment booked', source: 'booking', status: 'completed', referenceId: 'APT-2847', createdAt: DateTime.now().subtract(const Duration(hours: 8)), icon: Icons.medical_services_rounded, color: const Color(0xFFE11D48)),
    TrackcoinTransaction(id: 'T003', type: 'earned', amount: 100, title: 'Referral reward credited', source: 'referral', status: 'completed', createdAt: DateTime.now().subtract(const Duration(days: 1)), icon: Icons.group_add_rounded, color: const Color(0xFF12B76A)),
    TrackcoinTransaction(id: 'T004', type: 'spent', amount: 150, title: 'Medicine order discount', source: 'purchase', status: 'completed', referenceId: 'ORD-9382', createdAt: DateTime.now().subtract(const Duration(days: 2)), icon: Icons.medication_rounded, color: const Color(0xFFE11D48)),
    TrackcoinTransaction(id: 'T005', type: 'bonus', amount: 250, title: 'Welcome bonus credited', source: 'admin', status: 'completed', createdAt: DateTime.now().subtract(const Duration(days: 3)), icon: Icons.card_giftcard_rounded, color: const Color(0xFF7C3AED)),
    TrackcoinTransaction(id: 'T006', type: 'earned', amount: 25, title: 'Medicine purchased — cashback', source: 'purchase', status: 'completed', referenceId: 'ORD-8821', createdAt: DateTime.now().subtract(const Duration(days: 4)), icon: Icons.medication_rounded, color: const Color(0xFF12B76A)),
    TrackcoinTransaction(id: 'T007', type: 'spent', amount: 500, title: 'Premium plan redeemed', source: 'subscription', status: 'completed', referenceId: 'SUB-1192', createdAt: DateTime.now().subtract(const Duration(days: 5)), icon: Icons.stars_rounded, color: const Color(0xFFE11D48)),
    TrackcoinTransaction(id: 'T008', type: 'refund', amount: 200, title: 'Cancelled appointment refund', source: 'booking', status: 'completed', referenceId: 'APT-2201', createdAt: DateTime.now().subtract(const Duration(days: 6)), icon: Icons.replay_rounded, color: const Color(0xFF2E90FA)),
    TrackcoinTransaction(id: 'T009', type: 'expired', amount: 30, title: 'Unused coins expired', source: 'system', status: 'completed', createdAt: DateTime.now().subtract(const Duration(days: 8)), icon: Icons.timer_off_rounded, color: const Color(0xFF98A2B3)),
    TrackcoinTransaction(id: 'T010', type: 'earned', amount: 75, title: 'Health goal completed', source: 'goal', status: 'completed', createdAt: DateTime.now().subtract(const Duration(days: 10)), icon: Icons.flag_rounded, color: const Color(0xFF12B76A)),
  ];

  // Offers
  List<TrackcoinOffer> get offers => [
    TrackcoinOffer(id: 'O1', title: '2x Coins on First Booking', description: 'Earn double Trackcoins on your first doctor booking', coinsReward: 100, offerType: 'earn', validity: 'Ends 30 Apr'),
    TrackcoinOffer(id: 'O2', title: 'Bonus on Wearable Connect', description: 'Link your smartwatch and earn 200 bonus coins', coinsReward: 200, offerType: 'bonus', validity: 'Limited time'),
    TrackcoinOffer(id: 'O3', title: 'Medicine Week Special', description: 'Get 50 extra coins on every medicine purchase this week', coinsReward: 50, offerType: 'earn', validity: 'Ends 20 Apr'),
    TrackcoinOffer(id: 'O4', title: 'Wellness Season Rewards', description: 'Complete 7-day streak and earn 150 bonus coins', coinsReward: 150, offerType: 'bonus', validity: 'Seasonal'),
  ];

  // Filter transactions
  List<TrackcoinTransaction> getFilteredTransactions(String filter) {
    if (filter == 'All') return transactions;
    return transactions.where((t) => t.type == filter.toLowerCase()).toList();
  }

  // Apply coins at checkout
  void applyCoins(int amount) {
    if (amount <= _availableBalance) {
      _appliedCoins = amount;
      notifyListeners();
    }
  }

  void clearAppliedCoins() {
    _appliedCoins = 0;
    notifyListeners();
  }

  // Spend coins
  void spendCoins(int amount) {
    if (amount <= _availableBalance) {
      _availableBalance -= amount;
      _spentTotal += amount;
      notifyListeners();
    }
  }

  // Earn coins
  void earnCoins(int amount) {
    _availableBalance += amount;
    _earnedTotal += amount;
    notifyListeners();
  }
}
