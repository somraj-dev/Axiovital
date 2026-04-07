import 'package:flutter/material.dart';
import 'file_uploader_page.dart';
import 'widgets/axio_card.dart';
import 'theme.dart';

class MedicalRecordsVaultPage extends StatelessWidget {
  const MedicalRecordsVaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Records Vault', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.onSurface)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              _buildFilterChip(context, 'All', true),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Reports', false),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Scans', false),
            ],
          ),
          const SizedBox(height: 20),
          _buildRecordCard(context, 'MRI Brain Scan', 'Scan', 'Oct 12, 2023', 'City Hospital', true),
          _buildRecordCard(context, 'Blood Test Complete', 'Report', 'Nov 02, 2023', 'LabCorp', true),
          _buildRecordCard(context, 'Amoxicillin 500mg', 'Prescription', 'Dec 15, 2023', 'Dr. Smith', false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const FileUploaderPage(type: 'report')));
        },
        backgroundColor: theme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, String title, String type, String date, String hospital, bool verified) {
    final theme = Theme.of(context);
    return AxioCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(type == 'Scan' ? Icons.image : Icons.description, color: theme.primaryColor.withOpacity(0.7)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface))),
                    if (verified) const Icon(Icons.verified, color: AppTheme.successColor, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$type • $hospital', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                const SizedBox(height: 8),
                Text(date, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
