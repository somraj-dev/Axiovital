import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consent_provider.dart';
import 'package:intl/intl.dart';

class AccessHistoryPage extends StatelessWidget {
  const AccessHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Audit History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<ConsentProvider>(context, listen: false).fetchAccessLogs(),
          ),
        ],
      ),
      body: Consumer<ConsentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.accessLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No activity yet', style: TextStyle(color: Color(0xFF667085), fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('All data access events will be logged here', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.accessLogs.length,
            itemBuilder: (context, index) {
              final log = provider.accessLogs[index];
              return _buildAuditCard(log);
            },
          );
        },
      ),
    );
  }

  Widget _buildAuditCard(AccessLog log) {
    final actionConfig = _getActionConfig(log.action);

    String formattedTime;
    try {
      formattedTime = DateFormat('MMM dd, hh:mm a').format(log.createdAt.toLocal());
    } catch (_) {
      formattedTime = log.createdAt.toString();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: actionConfig['bg'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(actionConfig['icon'] as IconData, size: 12, color: actionConfig['color'] as Color),
                    const SizedBox(width: 4),
                    Text(log.action, style: TextStyle(color: actionConfig['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (log.blockchainHash != null)
                Row(
                  children: [
                    const Icon(Icons.link, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(log.blockchainHash!, style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            log.details ?? '${log.actorName} performed ${log.action}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(formattedTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (log.recordType != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.description_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(log.recordType!.replaceAll('_', ' '), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getActionConfig(String action) {
    switch (action) {
      case 'VIEW':
        return {'color': const Color(0xFF1565C0), 'bg': const Color(0xFFE3F2FD), 'icon': Icons.visibility};
      case 'GRANT':
        return {'color': const Color(0xFF7B1FA2), 'bg': const Color(0xFFF3E5F5), 'icon': Icons.check_circle};
      case 'DENY':
        return {'color': const Color(0xFFD92D20), 'bg': const Color(0xFFFEF3F2), 'icon': Icons.cancel};
      case 'REVOKE':
        return {'color': const Color(0xFFD92D20), 'bg': const Color(0xFFFEF3F2), 'icon': Icons.block};
      case 'UPLOAD':
        return {'color': const Color(0xFF2E7D32), 'bg': const Color(0xFFE8F5E9), 'icon': Icons.cloud_upload};
      case 'DOWNLOAD':
        return {'color': const Color(0xFFEF6C00), 'bg': const Color(0xFFFFF3E0), 'icon': Icons.cloud_download};
      default:
        return {'color': Colors.grey, 'bg': Colors.grey.shade100, 'icon': Icons.info};
    }
  }
}
