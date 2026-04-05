import 'package:flutter/material.dart';

class EssentialsPage extends StatelessWidget {
  const EssentialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Essentials'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.greenAccent),
            SizedBox(height: 16),
            Text('Essentials Store is coming soon!', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
