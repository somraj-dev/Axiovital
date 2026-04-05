import 'package:flutter/material.dart';

class VitalSyncDashboard extends StatelessWidget {
  const VitalSyncDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VitalSync Dashboard'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.dashboard_customize_outlined, size: 48, color: Colors.blueAccent),
            SizedBox(height: 16),
            Text('VitalSync Dashboard is coming soon!', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
