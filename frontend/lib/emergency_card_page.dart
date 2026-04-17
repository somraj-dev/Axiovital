import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class EmergencyCardPage extends StatelessWidget {
  const EmergencyCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      appBar: AppBar(
        title: const Text('Emergency Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download ID',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHorizontalHealthCard(userProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalHealthCard(UserProvider userProvider) {
    // Generate PHR from email, e.g. "alex.j@vitalsync.ai" -> "alex.j@axio"
    final phrAddress = userProvider.email.contains('@') 
        ? '${userProvider.email.split('@')[0]}@axio' 
        : 'user@axio';

    return AspectRatio(
      aspectRatio: 1.586, // Standard credit card/ID ratio
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: Column(
          children: [
            // Head Banner Section
            Container(
              height: 54, // Proportional header height
              decoration: const BoxDecoration(
                color: Color(0xFF263368), // ABHA Blue
              ),
              child: Row(
                children: [
                  // Left Emblem Group
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance, color: Colors.white, size: 30),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'National Health Authority',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.2),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Ministry of Health\nand Family Welfare',
                              style: TextStyle(color: Colors.white70, fontSize: 7, height: 1.1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Right ID Logo
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.badge, color: Color(0xFFD32F2F), size: 16),
                          Text('Health ID', style: TextStyle(color: Color(0xFF263368), fontSize: 5, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Middle Body Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Left
                    Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade300),
                        image: DecorationImage(
                          image: NetworkImage(userProvider.avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // User Detail Center
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userProvider.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 6),
                          Text('Axio ID : ${userProvider.axioId}', style: const TextStyle(color: Colors.black87, fontSize: 11)),
                          const SizedBox(height: 6),
                          Text('PHR Address: $phrAddress', style: const TextStyle(color: Colors.black87, fontSize: 11)),
                          const SizedBox(height: 6),
                          Text('Date of Birth: ${userProvider.dob}', style: const TextStyle(color: Colors.black87, fontSize: 11)),
                          const SizedBox(height: 6),
                          Text('Gender: ${userProvider.gender.toLowerCase()}', style: const TextStyle(color: Colors.black87, fontSize: 11)),
                          const SizedBox(height: 6),
                          Text('Mobile: ${userProvider.phone}', style: const TextStyle(color: Colors.black87, fontSize: 11)),
                        ],
                      ),
                    ),
                    
                    // QR Code Right
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Axio-ID:${userProvider.axioId}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer Warning
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'For representation purpose only',
                style: TextStyle(color: Colors.black45, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

