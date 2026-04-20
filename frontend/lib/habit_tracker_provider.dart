import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserHabit {
  final String id;
  final String activity;
  final double targetValue;
  final double currentValue;
  final int streak;
  final String status;
  final Color color;
  final IconData icon;

  UserHabit({
    required this.id,
    required this.activity,
    required this.targetValue,
    required this.currentValue,
    required this.streak,
    required this.status,
    required this.color,
    required this.icon,
  });
}

enum SunState { bright, happy, neutral, sad, verySad, silver, dead }
enum LifestyleActivity { active, moderate, sedentary }

class DailyHealthScore {
  final DateTime date;
  final int dailyScore;
  final SunState sunState;
  final int steps;
  final int stepGoal;
  final int sleepHours;
  final int heartRateAvg;
  final LifestyleActivity activityLabel;

  DailyHealthScore({
    required this.date,
    required this.dailyScore,
    required this.sunState,
    required this.steps,
    required this.stepGoal,
    required this.sleepHours,
    required this.heartRateAvg,
    required this.activityLabel,
  });
}

class HabitTrackerProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<UserHabit> _habits = [];
  bool _isLoading = false;

  List<UserHabit> get habits => _habits;
  bool get isLoading => _isLoading;

  DateTime _selectedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get selectedMonth => _selectedMonth;
  DateTime get selectedDay => _selectedDay;

  int get activeDaysCount => 24;
  int get perfectDaysCount => 12;
  double get avgMonthlyScore => 85.0;
  double get avgSleep => 7.2;

  void selectDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  DailyHealthScore get selectedDayScore => getScore(_selectedDay) ?? _generateMockScore(_selectedDay);

  DailyHealthScore? getScore(DateTime date) {
    if (date.isAfter(DateTime.now())) return null;
    return _generateMockScore(date);
  }

  List<DailyHealthScore> getWeekAround(DateTime date) {
    return List.generate(7, (i) {
      final d = date.subtract(Duration(days: 3 - i));
      return _generateMockScore(d);
    });
  }

  static String activityLabelText(LifestyleActivity label) {
    switch (label) {
      case LifestyleActivity.active: return 'Very Active';
      case LifestyleActivity.moderate: return 'Moderate';
      case LifestyleActivity.sedentary: return 'Sedentary';
    }
  }

  DailyHealthScore _generateMockScore(DateTime date) {
    final seed = date.day + date.month;
    return DailyHealthScore(
      date: date,
      dailyScore: 60 + (seed % 40),
      sunState: SunState.values[seed % SunState.values.length],
      steps: 2000 + (seed * 100) % 8000,
      stepGoal: 10000,
      sleepHours: 5 + (seed % 4),
      heartRateAvg: 70 + (seed % 15),
      activityLabel: LifestyleActivity.values[seed % LifestyleActivity.values.length],
    );
  }

  HabitTrackerProvider() {
    fetchHabits();
    _setupRealtime();
  }

  void _setupRealtime() {
    _supabase
        .channel('public:user_habits')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'user_habits',
          callback: (payload) => fetchHabits(),
        )
        .subscribe();
  }

  Future<void> fetchHabits() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final List<dynamic> data = await _supabase
          .from('user_habits')
          .select()
          .eq('user_id', user.id);

      _habits = data.map((json) => UserHabit(
        id: json['id'],
        activity: json['activity'],
        targetValue: (json['target_value'] as num).toDouble(),
        currentValue: (json['current_value'] as num).toDouble(),
        streak: json['streak'] ?? 0,
        status: json['status'] ?? 'available',
        color: _parseColor(json['color_hex']),
        icon: _parseIcon(json['icon_name']),
      )).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching habits: $e');
    }
  }

  Future<void> updateHabitValue(String habitId, double newValue) async {
    try {
      await _supabase
          .from('user_habits')
          .update({'current_value': newValue})
          .eq('id', habitId);
      // UI updates via Realtime
    } catch (e) {
      debugPrint('Error updating habit: $e');
    }
  }

  Color _parseColor(String? hex) {
    if (hex == null) return Colors.blue;
    return Color(int.parse(hex.replaceFirst('#', 'ff'), radix: 16));
  }

  IconData _parseIcon(String? name) {
    switch (name) {
      case 'fire': return Icons.local_fire_department_rounded;
      case 'water': return Icons.water_drop_rounded;
      case 'walk': return Icons.directions_walk_rounded;
      case 'sleep': return Icons.bedtime_rounded;
      default: return Icons.check_circle_rounded;
    }
  }
}
