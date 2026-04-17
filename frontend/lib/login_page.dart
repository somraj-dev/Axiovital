import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPhoneLogin = true; // Default to phone login as per latest screenshot
  String _selectedCountry = 'United States (+1)';

  final List<String> _countries = [
    'United States (+1)',
    'India (+91)',
    'United Kingdom (+44)',
    'Canada (+1)',
    'Australia (+61)',
    'Germany (+49)',
    'France (+33)',
    'Japan (+81)',
    'China (+86)',
    'Brazil (+55)',
  ];

  final List<Map<String, String>> _mockAccounts = [
    {
      'name': 'Somraj Lodhi',
      'email': 'somrahlodhi0999@gmail.com',
      'avatar': 'https://ui-avatars.com/api/?name=SL&background=random',
    },
    {
      'name': 'somraj lodhi',
      'email': 'iitainsomraj701@gmail.com',
      'avatar': 'https://ui-avatars.com/api/?name=sl&background=random',
    },
    {
      'name': 'BTAM2501080 SOMRAJ LODHI',
      'email': '25am10so80@mitsgwl.ac.in',
      'avatar': 'https://ui-avatars.com/api/?name=BS&background=random',
    },
    {
      'name': '3axe',
      'email': '3axecompany@gmail.com',
      'avatar': 'https://ui-avatars.com/api/?name=3a&background=random',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Title
                    const Center(
                      child: Text(
                        'Log in or sign up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Reliable Healthcare, Right at Your Fingertips. ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Email or Phone input
                    if (!_isPhoneLogin)
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white38),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        ),
                      )
                    else ...[
                      // Country/Region Selector
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCountry,
                            dropdownColor: const Color(0xFF1F2123),
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                            decoration: const InputDecoration(
                              labelText: 'Country/Region',
                              labelStyle: TextStyle(color: Colors.white38, fontSize: 13),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            items: _countries.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCountry = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Phone number input
                      TextField(
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white), // Bold border when active as in shot
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Continue button
                    ElevatedButton(
                      onPressed: () => _isPhoneLogin ? _handlePhoneSignIn() : _handleEmailSignUp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.05), // Darker gray as in shot
                        foregroundColor: Colors.white24,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Divider
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('OR', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Social buttons
                    _buildDarkAuthButton(
                      text: 'Continue with Google',
                      icon: _buildGoogleIcon(),
                      onPressed: () => _handleGoogleSignIn(),
                    ),
                    const SizedBox(height: 12),
                    if (_isPhoneLogin)
                      _buildDarkAuthButton(
                        text: 'Continue with email',
                        icon: const Icon(Icons.email_outlined, color: Colors.white, size: 20),
                        onPressed: () => setState(() => _isPhoneLogin = false),
                      )
                    else
                      _buildDarkAuthButton(
                        text: 'Continue with phone',
                        icon: const Icon(Icons.phone_outlined, color: Colors.white, size: 20),
                        onPressed: () => setState(() => _isPhoneLogin = true),
                      ),
                    const SizedBox(height: 48),
                    
                    // Footer links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Terms of Use', style: TextStyle(color: Colors.white38, fontSize: 13, decoration: TextDecoration.underline)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('·', style: TextStyle(color: Colors.white38)),
                        ),
                        Text('Privacy Policy', style: TextStyle(color: Colors.white38, fontSize: 13, decoration: TextDecoration.underline)),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkAuthButton({
    required String text,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Image.network(
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
      width: 18,
      height: 18,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24, color: Colors.white),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    _showAccountPickerSheet(context);
  }

  void _showAccountPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2123),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildGoogleIconLarge(),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose an account for\nAxiovital',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: _mockAccounts.map((account) {
                    final isFirst = _mockAccounts.indexOf(account) == 0;
                    final isLast = _mockAccounts.indexOf(account) == _mockAccounts.length - 1;
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            _showSigningInSheet(context, account);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(isFirst ? 24 : 0),
                              bottom: Radius.circular(isLast ? 24 : 0),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(account['avatar']!),
                          ),
                          title: Text(
                            account['email']!,
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            account['name']!,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                        if (!isLast)
                          Divider(color: Colors.white.withOpacity(0.1), height: 1, indent: 70),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Sign-in options',
                    style: TextStyle(color: Color(0xFF8AB4F8), fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showSigningInSheet(BuildContext context, Map<String, String> account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2123),
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Start sign-in process
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pop(context);
                _navigateToMain(context);
              }
            });

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGoogleIconLarge(),
                  const SizedBox(height: 48),
                  const Text(
                    'Signing you in',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8AB4F8)),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(account['avatar']!),
                    ),
                    title: Text(
                      account['name']!,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      account['email']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGoogleIconLarge() {
    return Image.network(
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
      width: 48,
      height: 48,
    );
  }

  Future<void> _handlePhoneSignIn() async {
    _navigateToMain(context);
  }

  Future<void> _handleEmailSignUp() async {
    _navigateToMain(context);
  }

  void _navigateToMain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
