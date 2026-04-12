import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'login_page.dart';
import 'create_profile_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isOnboarded = prefs.getBool('is_onboarded') ?? false;

    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isOnboarded ? const LoginPage() : const CreateProfilePage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF42403F); // Precise TATA 1mg charcoal
    const Color bgColor = Color(0xFFFFF6ED);   // Precise warm cream/beige

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            
            // Re-imagined Logo: AXIO Vital
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // AXIO (The "TATA" part)
                    Text(
                      'AXIO',
                      style: GoogleFonts.inter(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: brandColor,
                        letterSpacing: -2.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Vital (The "1mg" part)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'V',
                              style: GoogleFonts.inter(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: brandColor,
                                letterSpacing: -1.0,
                              ),
                            ),
                            Text(
                              'ital',
                              style: GoogleFonts.inter(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: brandColor,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                        // Thick solid bar matching exactly under "Vital"
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          height: 7,
                          width: 84, // Approximate width for "Vital"
                          color: brandColor,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Tagline: BE In The Ecosystem
                Text(
                  'BE In The Ecosystem',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: brandColor.withOpacity(0.85),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const Spacer(flex: 4),

            // Footer Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Certification 1
                      _buildSeal(
                        color: const Color(0xFF4CAF50), // LegitScript Green
                        label: 'LEGITSCRIPT',
                        subLabel: 'CERTIFIED',
                        isSeal: true,
                      ),
                      const SizedBox(width: 48),
                      // Certification 2
                      _buildSeal(
                        color: const Color(0xFF1B4F72), // ISO Blue
                        label: 'ISO/IEC 27001',
                        subLabel: 'CERTIFIED',
                        isSeal: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "India's only ISO/IEC 27001 and LegitScript certified\nonline healthcare platform",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: brandColor.withOpacity(0.6),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeal({required Color color, required String label, required String subLabel, required bool isSeal}) {
    return Column(
      children: [
        Container(
          width: 54, height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: isSeal ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isSeal ? null : BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))
            ],
          ),
          child: Center(
            child: Icon(
              isSeal ? Icons.verified_rounded : Icons.security_rounded,
              color: color,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 7,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          subLabel,
          style: GoogleFonts.inter(
            fontSize: 7,
            fontWeight: FontWeight.w400,
            color: color.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}


