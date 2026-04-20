import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'auth_service.dart';
import 'main_screen.dart';

enum VerificationType { phone, email }

class VerificationPage extends StatefulWidget {
  final VerificationType type;
  final String targetValue;

  const VerificationPage({
    super.key,
    required this.type,
    required this.targetValue,
  });

  // Colors as static constants so they work in const contexts
  static const Color _brandColor = Color(0xFFE11D48);
  static const Color _surfaceColor = Color(0xFFF2F4F7);
  static const Color _textPrimary = Color(0xFF101828);
  static const Color _textSecondary = Color(0xFF475467);
  static const Color _iconBg = Color(0xFFE0F2F1);
  static const Color _iconColor = Color(0xFF00695C);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());
  final AuthService _authService = AuthService();

  int _timerSeconds = 45;
  Timer? _timer;
  bool _isLoading = false;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(_updateCompletionStatus);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timerSeconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _updateCompletionStatus() {
    final complete = _controllers.every((c) => c.text.isNotEmpty);
    if (complete != _isComplete) {
      setState(() => _isComplete = complete);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String _getMaskedValue() {
    if (widget.type == VerificationType.phone) {
      final lastFour = widget.targetValue.length >= 4
          ? widget.targetValue.substring(widget.targetValue.length - 4)
          : '8901';
      return '\u2022\u2022\u2022\u2022 $lastFour';
    } else {
      if (widget.targetValue.contains('@')) {
        final parts = widget.targetValue.split('@');
        return '${parts[0][0]}\u2022\u2022\u2022\u2022@${parts[1]}';
      }
      return '\u2022\u2022\u2022\u2022@example.com';
    }
  }

  Future<void> _handleVerify() async {
    if (!_isComplete || _isLoading) return;
    final otp = _controllers.map((c) => c.text).join();
    setState(() => _isLoading = true);

    final response = await _authService.verifyOtp(widget.targetValue, otp);

    if (mounted) {
      setState(() => _isLoading = false);
      if (response.session != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = widget.type == VerificationType.phone;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VerificationPage._textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Top Icon
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: VerificationPage._iconBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isPhone ? Icons.smartphone_rounded : Icons.email_rounded,
                    color: VerificationPage._iconColor,
                    size: 36,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Verify Your ${isPhone ? 'Phone' : 'Email'}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: VerificationPage._textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                "We've sent a 6-digit code to your registered "
                "${isPhone ? 'mobile number' : 'email address'} ending in "
                "${_getMaskedValue()}.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: VerificationPage._textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 50,
                    height: 64,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: VerificationPage._textPrimary,
                      ),
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: VerificationPage._surfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          _focusNodes[i + 1].requestFocus();
                        } else if (v.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Timer / Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 18,
                      color: VerificationPage._textSecondary.withOpacity(0.6)),
                  const SizedBox(width: 8),
                  Text(
                    _timerSeconds > 0
                        ? 'Resend code in 00:${_timerSeconds.toString().padLeft(2, '0')}'
                        : 'Did not receive code?',
                    style: const TextStyle(
                      color: VerificationPage._textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  if (_timerSeconds == 0)
                    TextButton(
                      onPressed: _startTimer,
                      child: const Text('Resend',
                          style: TextStyle(
                              color: VerificationPage._brandColor,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),

              const Spacer(),

              // Verify button
              ElevatedButton(
                onPressed: _isComplete && !_isLoading ? _handleVerify : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isComplete
                      ? VerificationPage._brandColor
                      : VerificationPage._surfaceColor,
                  foregroundColor: _isComplete
                      ? Colors.white
                      : VerificationPage._textSecondary.withOpacity(0.5),
                  disabledBackgroundColor: VerificationPage._surfaceColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Verify & Finish',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
              ),

              const SizedBox(height: 24),

              // Secure footer
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: VerificationPage._surfaceColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 14,
                        color: VerificationPage._textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'SECURE VERIFICATION PROCESS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: VerificationPage._textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
