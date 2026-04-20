import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consent_provider.dart';

class ConsentManagerPage extends StatelessWidget {
  const ConsentManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Consent Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<ConsentProvider>(context, listen: false).refreshAll(),
          ),
        ],
      ),
      body: Consumer<ConsentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final consents = provider.activeConsents;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Manage who can view your sensitive health data. Revoke access anytime.',
                style: TextStyle(color: Color(0xFF667085), height: 1.4),
              ),
              const SizedBox(height: 8),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF7B3C8C), Color(0xFF4A148C)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('${provider.activeShareCount}', 'Active'),
                    Container(width: 1, height: 36, color: Colors.white24),
                    _buildStatItem('${provider.pendingRequests.length}', 'Pending'),
                    Container(width: 1, height: 36, color: Colors.white24),
                    _buildStatItem('${provider.accessLogs.length}', 'Logs'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (consents.isEmpty) ...[
                const SizedBox(height: 48),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.shield_outlined, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text('No active data sharing', style: TextStyle(color: Color(0xFF667085), fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('Your data is fully private', style: TextStyle(color: Color(0xFF039855), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ] else ...[
                Text('Active Consents (${consents.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ...consents.map((consent) => _buildConsentCard(context, provider, consent)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildConsentCard(BuildContext context, ConsentProvider provider, Consent consent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.security, color: Color(0xFF4A148C)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(consent.requesterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(consent.remainingLabel, style: const TextStyle(color: Color(0xFF039855), fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _formatAccessType(consent.accessType),
                    style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: consent.dataScope.map((s) => Chip(
                label: Text(s.replaceAll('_', ' '), style: const TextStyle(fontSize: 12)),
                backgroundColor: const Color(0xFFF9FAFB),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  provider.revokeConsent(consent.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Revoked access for ${consent.requesterName}'), backgroundColor: Colors.red),
                  );
                },
                icon: const Icon(Icons.block, size: 16),
                label: const Text('Revoke Access'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD92D20),
                  side: const BorderSide(color: Color(0xFFD92D20)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAccessType(String type) {
    switch (type) {
      case 'view_only': return 'VIEW ONLY';
      case 'download': return 'DOWNLOAD';
      case 'continuous': return 'CONTINUOUS';
      default: return type.toUpperCase();
    }
  }
}
