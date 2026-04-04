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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  
                  // App Logo Placeholder (Axiovital Clinical)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                        child: const Center(
                        child: Icon(
                          Icons.shield_moon_rounded, // Premium medical/security shield
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  const Text(
                    'Axiovital helps you track, manage,\nand optimize your health journey.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Continue with Apple
                  _buildAuthButton(
                    context: context,
                    text: 'Continue with Apple',
                    icon: Icons.apple,
                    iconColor: Colors.white,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () => _handleAppleSignIn(),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Continue with Google
                  _buildAuthButton(
                    context: context,
                    text: 'Continue with Google',
                    customIcon: _buildGoogleIcon(),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: const Color(0xFFE5E5E5),
                    onPressed: () => _handleGoogleSignIn(),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Sign up with email
                  _buildAuthButton(
                    context: context,
                    text: 'Sign up with email',
                    icon: Icons.email_outlined,
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: const Color(0xFFE5E5E5),
                    onPressed: () => _handleEmailSignUp(),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);
    if (user != null) {
      _navigateToMain(context);
    }
  }

  Future<void> _handleAppleSignIn() async {
    // For now we just mock or navigate since Apple sign in requires extra setup
    _navigateToMain(context);
  }

  Future<void> _handleEmailSignUp() async {
    // For now just navigate as we'd need a form for real email/pass
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

  Widget _buildAuthButton({
    required BuildContext context,
    required String text,
    IconData? icon,
    Widget? customIcon,
    Color? iconColor,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
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
                if (icon != null) ...[
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 12),
                ] else if (customIcon != null) ...[
                  customIcon,
                  const SizedBox(width: 12),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
        width: 18,
        height: 18,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if network fails
          return const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue);
        },
      ),
    );
  }
}
