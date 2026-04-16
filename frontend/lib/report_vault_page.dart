import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'models/medical_report.dart';
import 'widgets/report_card.dart';
import 'widgets/floating_upload_button.dart';

class ReportVaultPage extends StatefulWidget {
  const ReportVaultPage({Key? key}) : super(key: key);

  @override
  State<ReportVaultPage> createState() => _ReportVaultPageState();
}

class _ReportVaultPageState extends State<ReportVaultPage> {
  final List<MedicalReport> reports = [
    MedicalReport(
      id: '1',
      title: 'Blood Test Results',
      type: 'Laboratory',
      imageUrl: 'assets/reports/blood_test.png',
      createdAt: DateTime.now(),
      timeLabel: '2 hrs ago',
      status: ReportStatus.verified,
    ),
    MedicalReport(
      id: '2',
      title: 'Spinal MRI Scan',
      type: 'MRI',
      imageUrl: 'assets/reports/mri_scan.png',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      timeLabel: 'Yesterday',
      status: ReportStatus.critical,
    ),
    MedicalReport(
      id: '3',
      title: 'Chest X-Ray',
      type: 'X-Ray',
      imageUrl: 'assets/reports/xray.png',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      timeLabel: '3 days ago',
      status: ReportStatus.verified,
    ),
    MedicalReport(
      id: '4',
      title: 'Annual Physical Prescription',
      type: 'Prescription',
      imageUrl: 'assets/reports/prescription.png',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      timeLabel: 'Last week',
      status: ReportStatus.verified,
    ),
    MedicalReport(
      id: '5',
      title: 'ECG Rhythm Analysis',
      type: 'Cardiology',
      imageUrl: 'assets/reports/ecg_report.png',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      timeLabel: '2 weeks ago',
      status: ReportStatus.verified,
      isLocked: true,
    ),
    MedicalReport(
      id: '6',
      title: 'Complete Blood Count',
      type: 'Laboratory',
      imageUrl: 'assets/reports/blood_test.png',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      timeLabel: '1 month ago',
      status: ReportStatus.verified,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'April 15, 2026',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onBackground.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: colorScheme.surfaceVariant,
                              child: Icon(Icons.person_outline, color: colorScheme.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Report Vault',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemBuilder: (context, index) {
                      return ReportCard(
                        report: reports[index],
                        onTap: () {
                          // TODO: Navigate to details
                        },
                      );
                    },
                    childCount: reports.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingUploadButton(
                  onPressed: () {
                    // TODO: Handle upload
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
