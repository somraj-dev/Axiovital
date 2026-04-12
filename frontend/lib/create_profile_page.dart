import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart'; // Added
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'permissions_page.dart'; // Added

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isAgreed = false;
  bool _isNameValid = false;

  void _openPermissions() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PermissionsPage()),
    );
    
    if (result == true) {
      setState(() {
        _isAgreed = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _aadhaarController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF005A70), // Deep Teal
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _handleContinue() async {
    if (_formKey.currentState!.validate() && _isAgreed) {
      // 1. Update UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateProfile(
        name: _nameController.text,
        dob: _dobController.text,
        email: _emailController.text,
      );

      // 2. Mark as onboarded
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_onboarded', true);

      // 3. Navigate to Login/Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms and Privacy Policy')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandTeal = Color(0xFF0D5E73);
    const Color labelGrey = Color(0xFF475467);
    const Color inputBg = Color(0xFFE5EDEF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Create Your Health\nProfile',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D2939),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We use end-to-end encryption to ensure your medical records remain private and secure.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF667085),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Full Name
                _buildLabel('Full Name'),
                TextFormField(
                  controller: _nameController,
                  onChanged: (val) => setState(() => _isNameValid = val.length > 3),
                  decoration: _buildInputDecoration(
                    'Enter your full legal name',
                    suffixIcon: _isNameValid 
                        ? const Icon(Icons.check_circle, color: Color(0xFF039855), size: 20) 
                        : null,
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                // DOB
                _buildLabel('Date of Birth'),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: _buildInputDecoration(
                    'mm/dd/yyyy',
                    suffixIcon: const Icon(Icons.calendar_today_outlined, color: brandTeal, size: 20),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Date of Birth is required' : null,
                ),
                const SizedBox(height: 20),

                // Aadhaar
                _buildLabel('Aadhaar Card Number'),
                TextFormField(
                  controller: _aadhaarController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                    _AadhaarFormatter(),
                  ],
                  decoration: _buildInputDecoration('XXXX XXXX 1234'),
                  validator: (val) => val != null && val.replaceAll(' ', '').length != 12 
                      ? 'Enter a valid 12-digit Aadhaar' 
                      : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: Color(0xFF667085)),
                    const SizedBox(width: 4),
                    Text(
                      'Your Aadhaar is used only for identity verification',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF667085)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email
                _buildLabel('Email Address'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('Enter your email address'),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Encryption Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.lock_outline, color: brandTeal, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Your data is encrypted and secure',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF344054),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (_) => _openPermissions(), // Forces reading flow
                      activeColor: brandTeal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to ',
                          style: GoogleFonts.inter(fontSize: 14, color: labelGrey),
                          children: [
                            TextSpan(
                              text: 'Terms',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                decoration: TextDecoration.underline,
                                color: Color(0xFF1D2939),
                              ),
                              recognizer: TapGestureRecognizer()..onTap = _openPermissions,
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                decoration: TextDecoration.underline,
                                color: Color(0xFF1D2939),
                              ),
                              recognizer: TapGestureRecognizer()..onTap = _openPermissions,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Continue Button
                ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandTeal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Verify & Continue',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF344054),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: const Color(0xFF667085), fontSize: 16),
      filled: true,
      fillColor: const Color(0xFFF2F4F7), // Light grey fill like image
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D5E73), width: 1),
      ),
      suffixIcon: suffixIcon != null ? Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: suffixIcon,
      ) : null,
    );
  }
}

class _AadhaarFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 12) text = text.substring(0, 12);
    
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
