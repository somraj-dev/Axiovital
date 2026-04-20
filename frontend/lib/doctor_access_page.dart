import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consent_provider.dart';

class DoctorAccessPage extends StatelessWidget {
  const DoctorAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('Doctor Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Color(0xFF101828),
            unselectedLabelColor: Color(0xFF667085),
            indicatorColor: Color(0xFF4A148C),
            tabs: [
              Tab(text: 'Pending Requests'),
              Tab(text: 'Active Permissions'),
            ],
          ),
        ),
        body: Consumer<ConsentProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _buildPendingTab(context, provider),
                _buildActiveTab(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPendingTab(BuildContext context, ConsentProvider provider) {
    if (provider.pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No pending requests', style: TextStyle(color: Color(0xFF667085), fontSize: 16)),
            const SizedBox(height: 8),
            const Text('New requests will appear here in real-time', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.pendingRequests.length,
      itemBuilder: (context, index) {
        final request = provider.pendingRequests[index];
        return _buildRequestCard(context, provider, request);
      },
    );
  }

  Widget _buildActiveTab(BuildContext context, ConsentProvider provider) {
    if (provider.activeConsents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No active permissions', style: TextStyle(color: Color(0xFF667085), fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.activeConsents.length,
      itemBuilder: (context, index) {
        final consent = provider.activeConsents[index];
        return _buildActiveCard(context, provider, consent);
      },
    );
  }

  Widget _buildRequestCard(BuildContext context, ConsentProvider provider, ConsentRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF3E5F5),
                child: Text(request.requesterName[0], style: const TextStyle(color: Color(0xFF7B1FA2), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(request.requesterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Color(0xFF4A148C), size: 16),
                      ],
                    ),
                    if (request.requesterSpecialty != null)
                      Text(request.requesterSpecialty!, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data scope badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: request.dataScope.map((scope) => _buildScopeBadge(scope)).toList(),
          ),
          const SizedBox(height: 12),

          // Purpose & Duration
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: Color(0xFF667085)),
                    const SizedBox(width: 8),
                    Text('Purpose: ${_formatPurpose(request.purpose)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF667085)),
                    const SizedBox(width: 8),
                    Text('Duration: ${request.durationDays} days', style: const TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF667085)),
                    const SizedBox(width: 8),
                    Text('Access: ${_formatAccessType(request.accessType)}', style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          if (request.message != null) ...[
            const SizedBox(height: 12),
            Text('"${request.message}"', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF667085))),
          ],

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => provider.denyRequest(request.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD92D20),
                    side: const BorderSide(color: Color(0xFFD92D20)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Deny'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showApprovalSheet(context, provider, request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A148C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCard(BuildContext context, ConsentProvider provider, Consent consent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE8F5E9),
                child: Text(consent.requesterName[0], style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(consent.requesterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    if (consent.requesterSpecialty != null)
                      Text(consent.requesterSpecialty!, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7FDF0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(consent.remainingLabel, style: const TextStyle(color: Color(0xFF039855), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: consent.dataScope.map((s) => _buildScopeBadge(s)).toList()),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _confirmRevoke(context, provider, consent),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEF3F2),
                foregroundColor: const Color(0xFFD92D20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Revoke Access'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScopeBadge(String scope) {
    final Map<String, Map<String, dynamic>> scopeStyles = {
      'lab_reports': {'label': 'Lab Reports', 'color': const Color(0xFF1565C0), 'bg': const Color(0xFFE3F2FD)},
      'prescriptions': {'label': 'Prescriptions', 'color': const Color(0xFF2E7D32), 'bg': const Color(0xFFE8F5E9)},
      'vitals': {'label': 'Vitals', 'color': const Color(0xFFEF6C00), 'bg': const Color(0xFFFFF3E0)},
      'radiology': {'label': 'Radiology', 'color': const Color(0xFF7B1FA2), 'bg': const Color(0xFFF3E5F5)},
    };
    final style = scopeStyles[scope] ?? {'label': scope, 'color': Colors.grey, 'bg': Colors.grey.shade100};

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: style['bg'] as Color, borderRadius: BorderRadius.circular(20)),
      child: Text(style['label'] as String, style: TextStyle(color: style['color'] as Color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  String _formatPurpose(String purpose) {
    switch (purpose) {
      case 'treatment': return 'Treatment';
      case 'insurance': return 'Insurance Claim';
      case 'second_opinion': return 'Second Opinion';
      case 'research': return 'Medical Research';
      default: return purpose;
    }
  }

  String _formatAccessType(String type) {
    switch (type) {
      case 'view_only': return 'View Only';
      case 'download': return 'Download';
      case 'continuous': return 'Continuous Access';
      default: return type;
    }
  }

  void _showApprovalSheet(BuildContext context, ConsentProvider provider, ConsentRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => _ApprovalSheet(provider: provider, request: request),
    );
  }

  void _confirmRevoke(BuildContext context, ConsentProvider provider, Consent consent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Access?'),
        content: Text('${consent.requesterName} will immediately lose access to your ${consent.dataScope.join(", ")} data.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.revokeConsent(consent.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD92D20)),
            child: const Text('Revoke', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Granular Approval Sheet ────────────────────────────

class _ApprovalSheet extends StatefulWidget {
  final ConsentProvider provider;
  final ConsentRequest request;
  const _ApprovalSheet({required this.provider, required this.request});

  @override
  State<_ApprovalSheet> createState() => _ApprovalSheetState();
}

class _ApprovalSheetState extends State<_ApprovalSheet> {
  late Map<String, bool> _scopeSelections;
  late int _selectedDuration;

  @override
  void initState() {
    super.initState();
    _scopeSelections = {for (var s in widget.request.dataScope) s: true};
    _selectedDuration = widget.request.durationDays;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 24),
          const Text('Customize Consent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Choose what ${widget.request.requesterName} can access:', style: const TextStyle(color: Color(0xFF667085))),
          const SizedBox(height: 24),

          // Scope toggles
          ...widget.request.dataScope.map((scope) => SwitchListTile(
            title: Text(_formatScope(scope), style: const TextStyle(fontWeight: FontWeight.w500)),
            value: _scopeSelections[scope]!,
            activeColor: const Color(0xFF4A148C),
            onChanged: (val) => setState(() => _scopeSelections[scope] = val),
          )),

          const SizedBox(height: 16),
          const Text('Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [1, 3, 7, 14, 30].map((d) => ChoiceChip(
              label: Text('$d days'),
              selected: _selectedDuration == d,
              selectedColor: const Color(0xFF4A148C),
              labelStyle: TextStyle(color: _selectedDuration == d ? Colors.white : Colors.black),
              onSelected: (_) => setState(() => _selectedDuration = d),
            )).toList(),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final selectedScopes = _scopeSelections.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();
                if (selectedScopes.isEmpty) return;
                widget.provider.approveRequest(
                  widget.request.id,
                  customScope: selectedScopes,
                  customDurationDays: _selectedDuration,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A148C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Approve Access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatScope(String scope) {
    switch (scope) {
      case 'lab_reports': return 'Lab Reports';
      case 'prescriptions': return 'Prescriptions';
      case 'vitals': return 'Vitals';
      case 'radiology': return 'Radiology Scans';
      default: return scope;
    }
  }
}
