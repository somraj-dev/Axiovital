import 'package:flutter/material.dart';
import 'models/medical_report.dart';

class ReportViewerPage extends StatefulWidget {
  final MedicalReport report;

  const ReportViewerPage({Key? key, required this.report}) : super(key: key);

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  bool isCritical = false;

  @override
  void initState() {
    super.initState();
    isCritical = widget.report.status == ReportStatus.critical;
  }

  void _showActionModal(String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text('This feature is coming soon in the next update.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.report.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'Today, Mar 15, 2026', // Mock date as requested
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _showActionModal('Download Report'),
          ),
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            onPressed: () => _showActionModal('Copy Link'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Action Toolbar
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share (secure link)',
                  onTap: () => _showActionModal('Share Report'),
                ),
                _buildActionButton(
                  icon: Icons.edit_note_outlined,
                  label: 'Add Notes',
                  onTap: () => _showActionModal('Add Notes'),
                ),
                _buildActionButton(
                  icon: isCritical ? Icons.report_problem : Icons.report_problem_outlined,
                  label: 'Mark as Critical',
                  color: isCritical ? Colors.red : null,
                  onTap: () {
                    setState(() {
                      isCritical = !isCritical;
                    });
                  },
                ),
                _buildActionButton(
                  icon: Icons.history_outlined,
                  label: 'View Audit Trail',
                  onTap: () => _showActionModal('Audit Trail'),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Main Content Area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Hero(
                  tag: 'report_img_${widget.report.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4,
                        child: Image.asset(
                          'assets/reports/report_preview.png', // Using the generated high-quality preview
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_not_supported_outlined, size: 64, color: colorScheme.error),
                                const SizedBox(height: 16),
                                const Text('Document snapshot not available'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color ?? colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: color ?? colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
