import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class VitalSyncDashboard extends StatelessWidget {
  const VitalSyncDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB), // Very light cool grey/white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'VitalSync Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Daily Progress',
                    '80%',
                    '+5%',
                    Icons.circle_outlined,
                    const Color(0xFFE0F7F7),
                    const Color(0xFF00BFA5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Current Streak',
                    '12',
                    'Days',
                    Icons.local_fire_department,
                    const Color(0xFFE0F7F7),
                    const Color(0xFF00BFA5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Adherence Trends Card
            _buildTrendsCard(),
            const SizedBox(height: 32),

            // Today's Schedule Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All', style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Active Medication Card (Atorvastatin)
            _buildMedicationCard(
              'UPCOMING • 8:00 PM',
              'Atorvastatin - 10mg',
              'After Dinner',
              Icons.medication,
              true,
            ),
            const SizedBox(height: 16),

            // Logged Medication Card (Lisinopril)
            _buildMedicationCard(
              'LOGGED • 8:15 AM',
              'Lisinopril - 20mg',
              'With Breakfast',
              Icons.medical_services_outlined,
              false,
            ),
            const SizedBox(height: 24),

            // Smart Reminders Toggle
            _buildReminderToggle(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subValue, IconData icon, Color bgColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 13)),
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black87),
              ),
              const SizedBox(width: 4),
              Text(
                subValue,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_graph, color: Color(0xFF00BFA5), size: 18),
              SizedBox(width: 8),
              Text(
                'Adherence Trends (Weekly)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('M', 0.4),
              _buildBar('T', 0.6),
              _buildBar('W', 0.5),
              _buildBar('T', 0.8),
              _buildBar('F', 0.7),
              _buildBar('S', 1.0, isHighlighted: true),
              _buildBar('S', 0.3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightFactor, {bool isHighlighted = false}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 100 * heightFactor,
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFF00BFA5) : const Color(0xFFE0F7F7),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMedicationCard(String status, String title, String instructions, IconData icon, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isCurrent ? const Color(0xFF00BFA5) : Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: TextStyle(
                      color: isCurrent ? const Color(0xFF00BFA5) : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF00BFA5), size: 24),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            instructions,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          if (isCurrent) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, color: Colors.black),
                label: const Text(
                  'Log as Taken',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F5D4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBFA),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE0F2F1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Color(0xFF00BFA5), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'AI SIDE-EFFECT MONITOR',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Feeling any new muscle pain or weakness after yesterday\'s dose?',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF00BFA5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'START AI CHECK-IN',
                      style: TextStyle(color: Color(0xFF00BFA5), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sensors, color: Color(0xFF00BFA5), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Smart Reminders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Location alerts & family nudges', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          CupertinoSwitch(
            value: true,
            onChanged: (v) {},
            activeColor: const Color(0xFF00F5D4),
          ),
        ],
      ),
    );
  }
}
