import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'main_screen.dart';
import 'login_page.dart';
import 'create_profile_page.dart';
import 'main.dart';
import 'profile_options_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

enum PinState { setup, confirm, verify }

class PinEntryPage extends StatefulWidget {
  final bool resetMode;
  const PinEntryPage({super.key, this.resetMode = false});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  final LocalAuthentication auth = LocalAuthentication();
  String _inputPin = '';
  String _firstPin = ''; 
  final int _pinLength = 4;
  PinState _state = PinState.verify;
  String? _storedPinHash;
  bool _isLoading = true;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _checkStoredPin();
  }

  Future<void> _checkStoredPin() async {
    final prefs = await SharedPreferences.getInstance();
    _storedPinHash = prefs.getString('user_pin_hash');
    
    setState(() {
      if (widget.resetMode || _storedPinHash == null) {
        _state = PinState.setup;
      } else {
        _state = PinState.verify;
      }
      _isLoading = false;
    });

    // Auto-trigger biometric on entry if in verify mode
    if (_state == PinState.verify) {
      _authenticateBiometric();
    }
  }

  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _onKeyPress(String value) {
    if (_inputPin.length < _pinLength) {
      setState(() {
        _errorMsg = '';
        _inputPin += value;
      });
      
      if (_inputPin.length == _pinLength) {
        _processPin();
      }
    }
  }

  void _onBackspace() {
    if (_inputPin.isNotEmpty) {
      setState(() {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
      });
    }
  }

  Future<void> _processPin() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_state == PinState.setup) {
      setState(() {
        _firstPin = _inputPin;
        _inputPin = '';
        _state = PinState.confirm;
      });
    } else if (_state == PinState.confirm) {
      if (_inputPin == _firstPin) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_pin_hash', _hashPin(_inputPin));
        _navigateToNext();
      } else {
        setState(() {
          _errorMsg = "PINs don't match. Try again.";
          _inputPin = '';
          _state = PinState.setup;
        });
      }
    } else if (_state == PinState.verify) {
      if (_hashPin(_inputPin) == _storedPinHash) {
        _navigateToNext();
      } else {
        setState(() {
          _errorMsg = "Incorrect PIN";
          _inputPin = '';
        });
      }
    }
  }

  void _navigateToNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isOnboarded = prefs.getBool('is_onboarded') ?? false;

    if (!mounted) return;

    if (kIsAuthBypass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isOnboarded ? const LoginPage() : const CreateProfilePage(),
        ),
      );
    }
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileOptionsSheet(),
    );
  }

  Future<void> _authenticateBiometric() async {
    try {
      if (kIsWeb) {
        // Mock for Web since real biometric sensors aren't always exposed to browsers
        _showMockBiometricDialog();
        return;
      }

      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to access AxioVital',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (didAuthenticate) {
          _navigateToNext();
        }
      } else {
        _showMockBiometricDialog();
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
      _showMockBiometricDialog();
    }
  }

  void _showMockBiometricDialog() {
    // Show a high-fidelity mock dialog that looks like a system scan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.fingerprint, color: Color(0xFF00D09C), size: 64),
              const SizedBox(height: 20),
              Text(
                'Biometric Authentication',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                'Touch the fingerprint sensor',
                style: GoogleFonts.inter(color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToNext(); // Simulate success on tap
                },
                child: Text('Simulate Success', style: GoogleFonts.inter(color: const Color(0xFF00D09C))),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.4))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }

    final userProvider = Provider.of<UserProvider>(context);

    return PopScope(
      canPop: false, 
      onPopInvoked: (didPop) {
        if (didPop) return;
        _errorMsg = 'PIN entry is mandatory to access AxioVital';
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.show_chart, color: Colors.white, size: 24),
                    ),
                    GestureDetector(
                      onTap: _showProfileOptions,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade900,
                          backgroundImage: const NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Somraj&backgroundColor=000000'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Hi, ${userProvider.name}',
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: -0.5),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your Axio PIN',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400),
              ),
              
              const SizedBox(height: 48),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (index) {
                  bool isFilled = index < _inputPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 62, height: 62,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isFilled ? Colors.white : Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isFilled
                          ? Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                          : null,
                    ),
                  );
                }),
              ),
              
              if (_errorMsg.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  _errorMsg,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
                ),
              ],
              
              const Spacer(),
              
              if (_state == PinState.verify)
                GestureDetector(
                  onTap: _authenticateBiometric,
                  child: Text(
                    'Use fingerprint',
                    style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF00D09C), fontWeight: FontWeight.w600),
                  ),
                ),
              
              const SizedBox(height: 40),
              
              _buildKeypad(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildKeypadRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildKeypadRow(['7', '8', '9']),
          const SizedBox(height: 20),
          _buildKeypadRow(['.', '0', 'BACKSPACE']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys.map((key) {
        if (key == 'BACKSPACE') {
          return _buildKeyButton(
            onPressed: _onBackspace,
            child: const Icon(Icons.backspace_outlined, color: Colors.white, size: 24),
          );
        } else if (key == '.') {
          return _buildKeyButton(
            onPressed: () {},
            child: Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          );
        } else {
          return _buildKeyButton(
            onPressed: () => _onKeyPress(key),
            child: Text(key, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
          );
        }
      }).toList(),
    );
  }

  Widget _buildKeyButton({required VoidCallback onPressed, required Widget child}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(width: 70, height: 70, alignment: Alignment.center, child: child),
    );
  }
}
