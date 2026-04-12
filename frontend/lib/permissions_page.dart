import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color coralRed = Color(0xFFFF5252); // As seen in image
    const Color bannerGreen = Color(0xFFE8F5E9); // Soft green for banner
    const Color bannerTextGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'App permissions',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bannerGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of service and privacy',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: bannerTextGreen,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We understand the nature and sensitivity of this topic and have taken strong measures to ensure that your data is not compromised.',
                          style: GoogleFonts.inter(
                            color: bannerTextGreen,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Permissions List
                  _buildPermissionItem(
                    'Location',
                    "It is recommended that you set your location sharing 'Always' as it helps us to show you location specific data like availability of products. You can change this anytime later.",
                  ),
                  _buildPermissionItem(
                    'Camera',
                    "To allow you to take a photo of prescriptions & directly upload it to the app.",
                  ),
                  _buildPermissionItem(
                    'Photos/Media/Files',
                    "Media access permission is needed to store and retrieve your uploads such as prescription uploads on your device.",
                  ),
                  _buildPermissionItem(
                    'SMS',
                    "To support automatic OTP confirmation, so that you don't have to enter the authentication code manually.",
                  ),
                  _buildPermissionItem(
                    'Receive SMS',
                    "This helps us to send you payment related SMS by our payment partner JusPay.",
                  ),
                  _buildPermissionItem(
                    'Access Wifi State',
                    "This helps us to optimize your experience based on the Wifi's strength and signals, especially for optimizing video consultations.",
                  ),
                  _buildPermissionItem(
                    'Record Audio',
                    "To enable video consultations with doctors",
                  ),
                  _buildPermissionItem(
                    'Bluetooth',
                    "Bluetooth is used to redirect to bluetooth headset during video consultations.",
                  ),
                  _buildPermissionItem(
                    'Read Phone State',
                    "This helps us to put ongoing in-app call on hold when another incoming call comes in.",
                  ),

                  const SizedBox(height: 24),
                  
                  Text(
                    'You can change any of the above permissions anytime later.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please provide your acceptance to Terms & conditions and Privacy Policy by clicking on ‘I agree’.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: coralRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'I agree',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
