import 'package:flutter/material.dart';

class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF2F4F7),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xFF667085),
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Past'),
            ],
          ),
          centerTitle: false,
          title: const Text('My consultations', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        ),
        body: const TabBarView(
          children: [
            _EmptyConsultationView(),
            _EmptyConsultationView(),
            _EmptyConsultationView(),
          ],
        ),
      ),
    );
  }
}

class _EmptyConsultationView extends StatelessWidget {
  const _EmptyConsultationView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          'https://media.istockphoto.com/id/1324835467/vector/bored-doctor-overloaded-with-paper-work-yawning.jpg?s=612x612&w=0&k=20&c=6R1NIn0Hl9GvI-3jW37iV3mO23XQ2W_sA_kP_5Dq7c=', 
          height: 220,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.event_busy, size: 120, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        const Text(
          'Sorry, no consultations found',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'You can start a new consultation with our\nqualified doctors!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF667085), fontSize: 15, height: 1.4),
          ),
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFE4E7EC)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 14),
          ),
          child: const Text('Consult now', style: TextStyle(color: Color(0xFFE05A47), fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 48), // Bottom offset
      ],
    );
  }
}
