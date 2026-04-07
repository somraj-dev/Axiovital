import 'package:flutter/material.dart';
import 'widgets/axio_button.dart';

class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            labelColor: theme.primaryColor,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
            indicatorColor: theme.primaryColor,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Past'),
            ],
          ),
          title: Text(
            'My consultations', 
            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18)
          ),
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
    final theme = Theme.of(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.event_busy, size: 80, color: theme.primaryColor.withOpacity(0.5)),
        ),
        const SizedBox(height: 32),
        Text(
          'No consultations found',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'You can start a new consultation with our\nqualified doctors!',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14, height: 1.4),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56.0),
          child: AxioButton(
            text: 'Consult now',
            isSecondary: true,
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
