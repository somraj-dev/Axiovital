import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'widgets/axio_verified_badge.dart';

class AppointmentSlipDetail extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentSlipDetail({super.key, required this.appointmentData});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final items = appointmentData['items'] is List ? appointmentData['items'] as List : [];
    final firstItem = items.isNotEmpty ? items[0] : {};

    // Dynamic Data
    final String clinicName = appointmentData['clinicName'] ?? 'PRACTICE/PROVIDER NAME';
    final String clinicAddress = appointmentData['clinicAddress'] ?? '123 SOME STREET, SOME CITY, ST 12345';
    final String clinicPhone = appointmentData['clinicPhone'] ?? 'PH: 555-555-5555';
    final String clinicWebsite = appointmentData['clinicWebsite'] ?? 'WWW.YOURWEBSITE.COM';
    
    final String doctorName = firstItem['doctorName'] ?? 'James Smith, MD';
    final String doctorLicense = firstItem['licenseNumber'] ?? '123456789';
    final String signatureUrl = firstItem['signatureUrl'] ?? '';
    final bool isVerified = firstItem['isVerified'] ?? true;

    final String dateOfIssue = DateTime.now().toString().split(' ').first; // YYYY-MM-DD
    final String appointmentDate = appointmentData['date'] ?? 'Tomorrow, 10:30 AM';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background to contrast with white paper
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          child: AspectRatio(
            aspectRatio: 1 / 1.414, // A4 page proportion
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 800,
                  height: 1131, // 800 * 1.414
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Medical Logo
                            Image.network(
                              'https://cdn-icons-png.flaticon.com/512/2862/2862899.png', // Similar Caduceus Outline PNG
                              width: 120,
                              height: 120,
                              color: Colors.black87,
                            ),
                            // Practice Name & Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        clinicName.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      if (isVerified) ...[
                                        const SizedBox(width: 8),
                                        const AxioVerifiedBadge(size: 20),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(clinicAddress, style: _docStyle(16), textAlign: TextAlign.right),
                                  Text(clinicPhone, style: _docStyle(16), textAlign: TextAlign.right),
                                  Text(clinicWebsite, style: _docStyle(16), textAlign: TextAlign.right),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black, thickness: 4),
                        const SizedBox(height: 60),

                        // Date & Patient Info
                        _buildInfoLine('Date of Issue: ', dateOfIssue),
                        const SizedBox(height: 16),
                        _buildInfoLine('Patient Name: ', userProvider.name),
                        const SizedBox(height: 16),
                        _buildInfoLine('Date of Birth: ', userProvider.dob),
                        
                        const SizedBox(height: 100),

                        // Watermark (Faded Caduceus)
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.05,
                                child: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2862/2862899.png',
                                  width: 450,
                                  height: 450,
                                  color: Colors.black,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: _docStyle(20, color: Colors.black),
                                      children: [
                                        const TextSpan(text: 'I certify that '),
                                        WidgetSpan(
                                          child: Container(
                                            padding: const EdgeInsets.only(bottom: 2),
                                            decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.black)),
                                            ),
                                            child: Text(userProvider.name, style: const TextStyle(color: Colors.black, fontSize: 20)),
                                          ),
                                        ),
                                        const TextSpan(text: ' was evaluated/treated\nin our office on '),
                                        WidgetSpan(
                                          child: Container(
                                            padding: const EdgeInsets.only(bottom: 2),
                                            decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.black)),
                                            ),
                                            child: Text(appointmentDate, style: const TextStyle(color: Colors.black, fontSize: 20)),
                                          ),
                                        ),
                                        const TextSpan(text: ' for a medical condition.'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 140),
                                  RichText(
                                    text: TextSpan(
                                      style: _docStyle(20, color: Colors.black),
                                      children: [
                                        const TextSpan(text: 'Next appointment scheduled for '),
                                        WidgetSpan(
                                          child: Container(
                                            width: 250,
                                            decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'The Provider has advised the patient to seek immediate care if symptoms\nworsen.',
                                    style: _docStyle(20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Spacer(), // Push signature and footer to bottom

                        // Signature Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Digital Signature Image or Fallback Font
                            if (signatureUrl.isNotEmpty)
                              Image.network(
                                signatureUrl,
                                height: 120,
                                width: 300,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => _buildFallbackSignature(doctorName),
                              )
                            else
                              _buildFallbackSignature(doctorName),
                            
                            const SizedBox(height: 6),
                            Text(doctorName, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('State License # $doctorLicense', style: _docStyle(18)),
                            Text(clinicAddress, style: _docStyle(18)),
                          ],
                        ),

                        const SizedBox(height: 80),
                        
                        // Footer Section
                        Text(
                          'Employers/Schools may verify this note by contacting our office at the number above.\n'
                          'This document contains confidential medical information intended solely for the addressee and should not be shared further without the patient\'s written consent (HIPAA 45 CFR §164.508).',
                          style: _docStyle(14, color: Colors.grey.shade600),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLine(String label, String value) {
    return Row(
      children: [
        Text(label, style: _docStyle(18)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const Divider(color: Colors.black, thickness: 1.5, height: 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackSignature(String name) {
    return Text(
      name.split(',').first,
      style: GoogleFonts.dancingScript(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1D1D1D),
      ),
    );
  }

  TextStyle _docStyle(double size, {Color color = Colors.black}) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Serif', // Use a formal font if possible
      height: 1.4,
    );
  }
}
