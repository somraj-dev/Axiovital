import 'dart:math';
import 'package:flutter/material.dart';

// ─── Enums ─────────────────────────────────────────────────────
enum SunState { dead, verySad, sad, neutral, happy, bright, silver }
enum ActivityLabel { sedentary, lightlyActive, moderate, active, highlyActive, perfect }

// ─── Models ────────────────────────────────────────────────────
class DailyHealthScore {
  final DateTime date;
  final int dailyScore; // 0-100
  final SunState sunState;
  final ActivityLabel activityLabel;
  final int steps;
  final int stepGoal;
  final double sleepHours;
  final double sleepGoal;
  final int heartRateAvg;
  final int bpSystolic;
  final int bpDiastolic;
  final int respiratoryRate;
  final int oxygenLevel;
  final int caloriesBurned;
  final int calorieGoal;
  final bool isPerfectDay;

  DailyHealthScore({
    required this.date,
    required this.dailyScore,
    required this.sunState,
    required this.activityLabel,
    this.steps = 0,
    this.stepGoal = 8000,
    this.sleepHours = 0,
    this.sleepGoal = 7.0,
    this.heartRateAvg = 72,
    this.bpSystolic = 120,
    this.bpDiastolic = 80,
    this.respiratoryRate = 16,
    this.oxygenLevel = 98,
    this.caloriesBurned = 0,
    this.calorieGoal = 2200,
    this.isPerfectDay = false,
  });
}

// ─── Provider ──────────────────────────────────────────────────
class HabitTrackerProvider extends ChangeNotifier {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDay = DateTime.now();
  final Map<String, DailyHealthScore> _scores = {};

  DateTime get selectedMonth => _selectedMonth;
  DateTime get selectedDay => _selectedDay;
  
  HabitTrackerProvider() {
    _generateMockData();
  }

  void setMonth(DateTime m) {
    _selectedMonth = DateTime(m.year, m.month);
    notifyListeners();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  void selectDay(DateTime d) {
    _selectedDay = d;
    notifyListeners();
  }

  DailyHealthScore? getScore(DateTime d) {
    final key = '${d.year}-${d.month}-${d.day}';
    return _scores[key];
  }

  DailyHealthScore get selectedDayScore {
    return getScore(_selectedDay) ?? _emptyScore(_selectedDay);
  }

  List<DailyHealthScore> getWeekAround(DateTime d) {
    return List.generate(7, (i) {
      final day = d.subtract(Duration(days: 3 - i));
      return getScore(day) ?? _emptyScore(day);
    });
  }

  // Monthly stats
  int get perfectDaysCount => _monthScores.where((s) => s.isPerfectDay).length;
  int get activeDaysCount => _monthScores.where((s) => s.dailyScore >= 51).length;
  double get avgMonthlyScore {
    if (_monthScores.isEmpty) return 0;
    return _monthScores.map((s) => s.dailyScore).reduce((a, b) => a + b) / _monthScores.length;
  }
  int get activeStreak {
    int streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < 60; i++) {
      final d = today.subtract(Duration(days: i));
      final s = getScore(d);
      if (s != null && s.dailyScore >= 51) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
  double get avgSleep {
    if (_monthScores.isEmpty) return 0;
    return _monthScores.map((s) => s.sleepHours).reduce((a, b) => a + b) / _monthScores.length;
  }
  int get avgHeartRate {
    if (_monthScores.isEmpty) return 0;
    return (_monthScores.map((s) => s.heartRateAvg).reduce((a, b) => a + b) / _monthScores.length).round();
  }

  List<DailyHealthScore> get _monthScores {
    final List<DailyHealthScore> result = [];
    final daysInMonth = DateUtils.getDaysInMonth(_selectedMonth.year, _selectedMonth.month);
    for (int d = 1; d <= daysInMonth; d++) {
      final day = DateTime(_selectedMonth.year, _selectedMonth.month, d);
      final s = getScore(day);
      if (s != null) result.add(s);
    }
    return result;
  }

  // Sun state helpers
  static SunState scoreToSunState(int score) {
    if (score == 0) return SunState.dead;
    if (score <= 30) return SunState.verySad;
    if (score <= 50) return SunState.sad;
    if (score <= 70) return SunState.neutral;
    if (score <= 89) return SunState.happy;
    return SunState.silver;
  }

  static ActivityLabel scoreToLabel(int score) {
    if (score <= 15) return ActivityLabel.sedentary;
    if (score <= 35) return ActivityLabel.lightlyActive;
    if (score <= 55) return ActivityLabel.moderate;
    if (score <= 75) return ActivityLabel.active;
    if (score <= 89) return ActivityLabel.highlyActive;
    return ActivityLabel.perfect;
  }

  static String activityLabelText(ActivityLabel label) {
    switch (label) {
      case ActivityLabel.sedentary: return 'Sedentary';
      case ActivityLabel.lightlyActive: return 'Lightly Active';
      case ActivityLabel.moderate: return 'Moderate';
      case ActivityLabel.active: return 'Active';
      case ActivityLabel.highlyActive: return 'Highly Active';
      case ActivityLabel.perfect: return 'Perfect Day';
    }
  }

  static String motivationText(int score) {
    if (score <= 10) return 'Time to move! Your body needs some activity today.';
    if (score <= 30) return 'Cheer up. Your lifestyle was sedentary today.';
    if (score <= 50) return 'You were lightly active today. Let\'s improve tomorrow!';
    if (score <= 70) return 'Good progress today. Keep going! 💪';
    if (score <= 89) return 'You had a strong active day. Well done!';
    return 'Perfect day! Your routine was excellent! 🌟';
  }

  // Sun emoji for calendar
  static String sunEmoji(SunState state) {
    switch (state) {
      case SunState.dead: return '😶';
      case SunState.verySad: return '😢';
      case SunState.sad: return '😕';
      case SunState.neutral: return '🙂';
      case SunState.happy: return '😊';
      case SunState.bright: return '😄';
      case SunState.silver: return '🌟';
    }
  }

  static Color sunColor(SunState state) {
    switch (state) {
      case SunState.dead: return const Color(0xFFD1D5DB);
      case SunState.verySad: return const Color(0xFFFCA5A5);
      case SunState.sad: return const Color(0xFFFCD34D);
      case SunState.neutral: return const Color(0xFFFDE68A);
      case SunState.happy: return const Color(0xFFFBBF24);
      case SunState.bright: return const Color(0xFFF59E0B);
      case SunState.silver: return const Color(0xFFC0C0C0);
    }
  }

  static Color sunGlowColor(SunState state) {
    switch (state) {
      case SunState.dead: return const Color(0x11000000);
      case SunState.verySad: return const Color(0x22EF4444);
      case SunState.sad: return const Color(0x22F59E0B);
      case SunState.neutral: return const Color(0x33FDE68A);
      case SunState.happy: return const Color(0x44FBBF24);
      case SunState.bright: return const Color(0x55F59E0B);
      case SunState.silver: return const Color(0x44E5E7EB);
    }
  }

  static Color gaugeColor(int score) {
    if (score <= 20) return const Color(0xFFEF4444);
    if (score <= 40) return const Color(0xFFF97316);
    if (score <= 60) return const Color(0xFFEAB308);
    if (score <= 80) return const Color(0xFF22C55E);
    return const Color(0xFF10B981);
  }

  DailyHealthScore _emptyScore(DateTime date) {
    return DailyHealthScore(
      date: date,
      dailyScore: 0,
      sunState: SunState.dead,
      activityLabel: ActivityLabel.sedentary,
    );
  }

  void _generateMockData() {
    final rng = Random(42);
    final today = DateTime.now();
    // Generate 90 days of data
    for (int i = 0; i < 90; i++) {
      final date = today.subtract(Duration(days: i));
      // Future days get no data
      if (date.isAfter(today)) continue;

      int score;
      if (i == 0) {
        score = 87; // today
      } else if (i == 1) {
        score = 64;
      } else if (i == 2) {
        score = 92;
      } else {
        // Random but weighted towards moderate-to-good
        score = (rng.nextDouble() * 100).round();
        // Make some days explicitly low
        if (rng.nextDouble() < 0.15) score = (rng.nextDouble() * 25).round();
        // Make some days perfect
        if (rng.nextDouble() < 0.1) score = 90 + (rng.nextDouble() * 10).round();
        score = score.clamp(0, 100);
      }

      final sunState = scoreToSunState(score);
      final label = scoreToLabel(score);
      final steps = (score / 100 * 12000 + rng.nextInt(2000)).round();
      final sleep = 3.0 + (score / 100 * 5) + rng.nextDouble() * 1.5;
      final hr = (60 + rng.nextInt(25));
      final bpS = 110 + rng.nextInt(30);
      final bpD = 70 + rng.nextInt(20);
      final rr = 14 + rng.nextInt(6);
      final o2 = 95 + rng.nextInt(5);
      final cal = (score / 100 * 2500 + rng.nextInt(500)).round();

      final key = '${date.year}-${date.month}-${date.day}';
      _scores[key] = DailyHealthScore(
        date: date,
        dailyScore: score,
        sunState: sunState,
        activityLabel: label,
        steps: steps,
        stepGoal: 8000,
        sleepHours: double.parse(sleep.toStringAsFixed(1)),
        sleepGoal: 7.0,
        heartRateAvg: hr,
        bpSystolic: bpS,
        bpDiastolic: bpD,
        respiratoryRate: rr,
        oxygenLevel: o2,
        caloriesBurned: cal,
        calorieGoal: 2200,
        isPerfectDay: score >= 90,
      );
    }
  }
}
