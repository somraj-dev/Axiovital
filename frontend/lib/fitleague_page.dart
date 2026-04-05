import 'package:flutter/material.dart';

class FitLeaguePage extends StatelessWidget {
  const FitLeaguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitLeague'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_events_outlined, size: 48, color: Colors.orangeAccent),
            SizedBox(height: 16),
            Text('FitLeague is coming soon!', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
