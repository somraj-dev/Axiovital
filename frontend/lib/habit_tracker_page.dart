import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'habit_tracker_provider.dart';

class HabitTrackerPage extends StatelessWidget {
  const HabitTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitTrackerProvider(),
      child: const _HabitTrackerShell(),
    );
  }
}

// ─── MAIN SHELL (Monthly Calendar) ─────────────────────────────
class _HabitTrackerShell extends StatelessWidget {
  const _HabitTrackerShell();

  static const _months = ['January','February','March','April','May','June','July','August','September','October','November','December'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Exact background gradient from reference
    final bgGradient = isDark 
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1113), Color(0xFF1A1C1E)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8EAF6), Color(0xFFFDF2F8)],
        );

    final fg = isDark ? Colors.white : const Color(0xFF1D2939);

    return Consumer<HabitTrackerProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: bgGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context, prov, isDark, fg),
                    const SizedBox(height: 8),
                    _calendarCard(context, prov, isDark, fg),
                    const SizedBox(height: 24),
                    _monthlyStatsSection(prov, isDark, fg),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topBar(BuildContext ctx, HabitTrackerProvider prov, bool isDark, Color fg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: fg),
          ),
          const SizedBox(width: 16),
          Text('Calendar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
          const Spacer(),
          // Share
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.ios_share, size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 4),
                const Text('Share', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF3B82F6))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Month Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2E30) : const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  _months[prov.selectedMonth.month - 1],
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white70 : const Color(0xFF6366F1)),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: isDark ? Colors.white70 : const Color(0xFF6366F1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarCard(BuildContext ctx, HabitTrackerProvider prov, bool isDark, Color fg) {
    final m = prov.selectedMonth;
    final daysInMonth = DateUtils.getDaysInMonth(m.year, m.month);
    final firstWeekday = DateTime(m.year, m.month, 1).weekday; 
    final offset = firstWeekday % 7; 
    final today = DateTime.now();
    final cardBg = isDark ? const Color(0xFF1A1C1E) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d) =>
              Text(d, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg.withOpacity(0.35)))
            ).toList(),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
            ),
            itemCount: offset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < offset) return const SizedBox();
              final day = index - offset + 1;
              final date = DateTime(m.year, m.month, day);
              final isFuture = date.isAfter(today);
              final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
              final score = prov.getScore(date);

              return GestureDetector(
                onTap: () {
                  if (!isFuture) {
                    prov.selectDay(date);
                    Navigator.push(ctx, MaterialPageRoute(builder: (_) =>
                      ChangeNotifierProvider.value(value: prov, child: const _DailyDetailScreen()),
                    ));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg.withOpacity(isFuture ? 0.2 : 0.6))),
                    const SizedBox(height: 4),
                    Container(
                      width: 38, height: 38,
                      decoration: isToday ? BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(12),
                      ) : null,
                      child: Center(
                        child: CustomPaint(
                          size: const Size(34, 34),
                          painter: _SunFacePainter(
                            state: (score != null && !isFuture) ? score.sunState : SunState.dead,
                            isFuture: isFuture,
                            isDark: isDark,
                            invertFace: isToday,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _monthlyStatsSection(HabitTrackerProvider prov, bool isDark, Color fg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Stats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: fg)),
          const SizedBox(height: 16),
          _statCard('Walk', 'Goal: 3,000 steps', prov.activeDaysCount, prov.avgMonthlyScore / 100, const Color(0xFF10B981), isDark, fg),
          const SizedBox(height: 12),
          _statCard('Sleep', 'Goal: 7h quality sleep', prov.perfectDaysCount, prov.avgSleep / 8.0, const Color(0xFF6366F1), isDark, fg),
        ],
      ),
    );
  }

  Widget _statCard(String title, String goal, int count, double progress, Color themeColor, bool isDark, Color fg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                child: Icon(title == 'Walk' ? Icons.directions_walk : Icons.bedtime, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: fg)),
                    Text(goal, style: TextStyle(fontSize: 12, color: fg.withOpacity(0.4))),
                  ],
                ),
              ),
              Text('×$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg.withOpacity(0.6))),
            ],
          ),
          const SizedBox(height: 16),
          _segmentedProgressBar(progress, themeColor, isDark),
        ],
      ),
    );
  }

  Widget _segmentedProgressBar(double progress, Color color, bool isDark) {
    const segments = 20;
    final activeSegments = (progress * segments).round();
    return Row(
      children: List.generate(segments, (i) {
        final isActive = i < activeSegments;
        return Expanded(
          child: Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: isActive ? color : (isDark ? const Color(0xFF2C2E30) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ─── DAILY DETAIL SCREEN ───────────────────────────────────────
class _DailyDetailScreen extends StatelessWidget {
  const _DailyDetailScreen();

  @override
  Widget build(BuildContext ctx) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : const Color(0xFF1D2939);
    final cardBg = isDark ? const Color(0xFF1A1C1E) : Colors.white;

    final bgGradient = isDark 
      ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F1113), Color(0xFF1A1C1E)])
      : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFE8EAF6), Color(0xFFFDF2F8)]);

    return Consumer<HabitTrackerProvider>(
      builder: (context, prov, _) {
        final score = prov.selectedDayScore;
        final week = prov.getWeekAround(prov.selectedDay);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: bgGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _detailHeader(ctx, prov, isDark, fg),
                    const SizedBox(height: 12),
                    _weekStrip(prov, week, isDark, fg),
                    const SizedBox(height: 24),
                    _mainGaugeCard(score, isDark, fg, cardBg),
                    const SizedBox(height: 16),
                    _statusSummaryCard(score, isDark, fg),
                    const SizedBox(height: 16),
                    _metricGrid(score, isDark, fg, cardBg),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailHeader(BuildContext ctx, HabitTrackerProvider prov, bool isDark, Color fg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(ctx), child: Icon(Icons.arrow_back_ios_new, size: 20, color: fg)),
          const SizedBox(width: 14),
          Text('Today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: isDark ? const Color(0xFF2C2E30) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                _toggleItem('Day', true, isDark, fg),
                _toggleItem('Week', false, isDark, fg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool active, bool isDark, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: active ? (isDark ? const Color(0xFF3B82F6) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: active && !isDark ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: active ? (isDark ? Colors.white : fg) : fg.withOpacity(0.4))),
    );
  }

  Widget _weekStrip(HabitTrackerProvider prov, List<DailyHealthScore> week, bool isDark, Color fg) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: week.length,
        itemBuilder: (_, i) {
          final w = week[i];
          final isSelected = w.date.day == prov.selectedDay.day && w.date.month == prov.selectedDay.month;
          return GestureDetector(
            onTap: () => prov.selectDay(w.date),
            child: Container(
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? Border.all(color: const Color(0xFF3B82F6), width: 2) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${w.date.day}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg.withOpacity(isSelected ? 1.0 : 0.4))),
                  const SizedBox(height: 6),
                  CustomPaint(
                    size: const Size(28, 28),
                    painter: _SunFacePainter(state: w.dailyScore > 0 ? w.sunState : SunState.dead, isFuture: false, isDark: isDark),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainGaugeCard(DailyHealthScore score, bool isDark, Color fg, Color cardBg) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Smiley Emoji Backdrop
              Opacity(
                opacity: 0.15,
                child: Container(
                  width: 140, height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [Color(0xFFF97316), Color(0xFFFB923C), Colors.transparent]),
                  ),
                ),
              ),
              // Gauge
              SizedBox(
                width: 220, height: 220,
                child: CustomPaint(
                  painter: _RainbowTickGaugePainter(score: score.dailyScore, isDark: isDark),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${score.dailyScore}%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: fg, letterSpacing: -1.5)),
                        Text('Perfect Day', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6))),
                        const SizedBox(height: 4),
                        // Soft face
                        const Icon(Icons.sentiment_very_satisfied, size: 40, color: Color(0xFFFBBF24)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Cheer up! Your lifestyle is ${HabitTrackerProvider.activityLabelText(score.activityLabel).toUpperCase()}.\nKeep moving, we\'ve got your back.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: fg.withOpacity(0.5), fontWeight: FontWeight.w600, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _statusSummaryCard(DailyHealthScore score, bool isDark, Color fg) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.flash_on, color: Color(0xFF3B82F6), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(HabitTrackerProvider.activityLabelText(score.activityLabel).toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF3B82F6))),
                const SizedBox(height: 4),
                Text('${score.steps} steps  •  Next 7,000 steps', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg.withOpacity(0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricGrid(DailyHealthScore score, bool isDark, Color fg, Color cardBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _miniMetricCard('🏃', 'Steps', '${score.steps}', 'of ${score.stepGoal}', score.steps / score.stepGoal, cardBg, fg),
          _miniMetricCard('💤', 'Sleep', '${score.sleepHours}h', '90% of goal', score.sleepHours / 8, cardBg, fg),
          _miniMetricCard('❤️', 'Heart', '${score.heartRateAvg}', 'BPM avg', score.heartRateAvg / 100, cardBg, fg),
          _miniMetricCard('🩺', 'BP', '120/80', 'mmHg', 0.8, cardBg, fg),
        ],
      ),
    );
  }

  Widget _miniMetricCard(String icon, String label, String val, String sub, double p, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const Spacer(),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg.withOpacity(0.3))),
            ],
          ),
          const Spacer(),
          Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
          Text(sub, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg.withOpacity(0.4))),
          const SizedBox(height: 8),
          _miniSegmentedBar(p, const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _miniSegmentedBar(double p, Color c) {
    return Row(
      children: List.generate(10, (i) => Expanded(
        child: Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(color: (i < p * 10) ? c : Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(2)),
        ),
      )),
    );
  }
}

// ─── CUSTOM SUN FACE PAINTER (12-RAY WAVY) ─────────────────────
class _SunFacePainter extends CustomPainter {
  final SunState state;
  final bool isFuture;
  final bool isDark;
  final bool invertFace;

  _SunFacePainter({required this.state, required this.isFuture, required this.isDark, this.invertFace = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.32;
    
    Color color;
    switch (state) {
      case SunState.bright: color = const Color(0xFFFFBE0B); break;
      case SunState.happy: color = const Color(0xFFFBBF24); break;
      case SunState.neutral: color = const Color(0xFFFDE68A); break;
      case SunState.sad: color = const Color(0xFFFCD34D); break;
      case SunState.verySad: color = const Color(0xFFFCA5A5); break;
      case SunState.silver: color = const Color(0xFFC0C0C0); break;
      case SunState.dead: color = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0); break;
    }
    if (isFuture) color = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    if (invertFace) color = Colors.white;

    // Draw wavy circle (12 rays)
    final path = Path();
    const rays = 12;
    for (int i = 0; i < rays * 2; i++) {
       final r = (i % 2 == 0) ? radius * 1.3 : radius;
       final angle = (i * math.pi * 2) / (rays * 2);
       if (i == 0) path.moveTo(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
       else path.lineTo(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);

    // Face
    if (!isFuture) {
      final faceColor = invertFace ? const Color(0xFF3B82F6) : (isDark ? Colors.white70 : const Color(0xFF4B3800));
      final p = Paint()..color = faceColor..strokeWidth = 1.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;

      // Eyes
      canvas.drawCircle(Offset(center.dx - radius*0.35, center.dy - radius*0.1), 1.5, Paint()..color = faceColor);
      canvas.drawCircle(Offset(center.dx + radius*0.35, center.dy - radius*0.1), 1.5, Paint()..color = faceColor);

      // Mouth
      final pathM = Path()
        ..moveTo(center.dx - radius*0.35, center.dy + radius*0.15);
      if (state == SunState.happy || state == SunState.bright || state == SunState.silver) {
         pathM.quadraticBezierTo(center.dx, center.dy + radius*0.45, center.dx + radius*0.35, center.dy + radius*0.15);
      } else if (state == SunState.neutral) {
         pathM.lineTo(center.dx + radius*0.35, center.dy + radius*0.15);
      } else {
         pathM.quadraticBezierTo(center.dx, center.dy + radius*0.05, center.dx + radius*0.35, center.dy + radius*0.15);
      }
      canvas.drawPath(pathM, p);
    }
  }

  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

// ─── RAINBOW TICK GAUGE PAINTER ───────────────────────────────
class _RainbowTickGaugePainter extends CustomPainter {
  final int score;
  final bool isDark;

  _RainbowTickGaugePainter({required this.score, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = 150 * math.pi / 180;
    const sweepLimit = 240 * math.pi / 180;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Inner Ticks
    final tickPaint = Paint()..color = isDark ? Colors.white10 : Colors.black.withOpacity(0.05)..strokeWidth = 2;
    for (int i = 0; i <= 60; i++) {
       final angle = startAngle + (i / 60) * sweepLimit;
       canvas.drawLine(
         Offset(center.dx + (radius - 12) * math.cos(angle), center.dy + (radius - 12) * math.sin(angle)),
         Offset(center.dx + (radius - 4) * math.cos(angle), center.dy + (radius - 4) * math.sin(angle)),
         tickPaint
       );
    }

    // Gradient Arc
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [const Color(0xFFEF4444), const Color(0xFFFBBF24), const Color(0xFF10B981), const Color(0xFF3B82F6), const Color(0xFF8B5CF6)],
        startAngle: startAngle,
        endAngle: startAngle + sweepLimit,
      ).createShader(rect);

    canvas.drawArc(rect, startAngle, (score / 100) * sweepLimit, false, p);

    // Cursor (Indicator Sun)
    final cursorAngle = startAngle + (score / 100) * sweepLimit;
    final cursorOffset = Offset(center.dx + radius * math.cos(cursorAngle), center.dy + radius * math.sin(cursorAngle));
    canvas.drawCircle(cursorOffset, 12, Paint()..color = Colors.white..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    
    // Draw tiny dummy sun face on cursor
    final tinySun = Paint()..color = const Color(0xFFFBBF24)..style = PaintingStyle.fill;
    canvas.drawCircle(cursorOffset, 8, tinySun);
  }

  @override bool shouldRepaint(covariant CustomPainter old) => true;
}
