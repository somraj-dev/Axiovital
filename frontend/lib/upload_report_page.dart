import 'package:flutter/material.dart';
import 'file_uploader_page.dart';

class UploadReportPage extends StatelessWidget {
  const UploadReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === BACK BUTTON (simple arrow, top-left) ===
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 16),

              // === TITLE with horizontal line extending right ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    const Text(
                      'What do you want to upload?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // === CHOICE CARDS ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildChoiceCard(
                      context,
                      'Upload lab report',
                      'Know what your lab results really mean',
                      'https://cdn3d.iconscout.com/3d/premium/thumb/medical-report-6334547-5226154.png?f=webp',
                      'report',
                    ),
                    const SizedBox(height: 14),
                    _buildChoiceCard(
                      context,
                      'Upload prescription',
                      'Understand diagnosis, medicines, dosage and how to take them',
                      'https://cdn3d.iconscout.com/3d/premium/thumb/rx-prescription-5366710-4492476.png?f=webp',
                      'prescription',
                    ),
                    const SizedBox(height: 14),
                    _buildChoiceCard(
                      context,
                      'Upload radiology scan',
                      'Get simplified analysis of your scans',
                      'https://cdn3d.iconscout.com/3d/premium/thumb/x-ray-report-5366723-4492489.png?f=webp',
                      'scan',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // === "Here's how it helps you" with horizontal line ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    const Text(
                      "Here\u2019s how it helps you",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // === BENEFIT ITEMS ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildBenefitItem(
                      Icons.favorite,
                      'Unified Health Tracking',
                      'Track all your health data in one place',
                      const Color(0xFFFCE7F6), // light pink bg
                      const Color(0xFFE56B93), // pink icon
                    ),
                    const SizedBox(height: 24),
                    _buildBenefitItem(
                      Icons.bar_chart_rounded,
                      'AI Powered Insights',
                      'Easy to understand explanation of document',
                      const Color(0xFFF0EFFF), // light purple bg
                      const Color(0xFF7B5CAB), // purple icon
                    ),
                    const SizedBox(height: 24),
                    _buildBenefitItem(
                      Icons.assignment_rounded,
                      'Actionable next steps',
                      'Learn what you can do next - lifestyle changes, follow-ups, or questions to ask your doctor.',
                      const Color(0xFFFFF1EB), // light orange bg
                      const Color(0xFFE58D61), // orange icon
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // === BOTTOM 3D CHARACTER ILLUSTRATION ===
              SizedBox(
                width: double.infinity,
                child: Image.network(
                  'https://cdni.iconscout.com/illustration/premium/thumb/woman-checking-medical-report-illustration-download-in-svg-png-gif-file-formats--health-checkup-doctor-healthcare-pack-people-illustrations-6020872.png',
                  height: 320,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://img.freepik.com/free-photo/3d-rendering-cartoon-like-woman-working_23-2151337851.jpg',
                      height: 320,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard(BuildContext context, String title, String subtitle, String imgUrl, String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FileUploaderPage(type: type)),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 14, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF2F4F7), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xFF101828),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '>',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                height: 64,
                width: 64,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
