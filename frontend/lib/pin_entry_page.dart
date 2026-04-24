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

enum PinState { setup, confirm, verify }

class PinEntryPage extends StatefulWidget {
  final bool resetMode;
  const PinEntryPage({super.key, this.resetMode = false});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  String _inputPin = '';
  String _firstPin = ''; // Used for confirmation
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

  String get _promptText {
    switch (_state) {
      case PinState.setup:
        return 'Set your Axio PIN';
      case PinState.confirm:
        return 'Confirm your Axio PIN';
      case PinState.verify:
        return 'Enter your Axio PIN';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }

    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00D09C), Color(0xFF00A5E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.show_chart, color: Colors.white, size: 22),
                  ),
                  GestureDetector(
                    onTap: _showProfileOptions,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade900,
                        backgroundImage: NetworkImage(
                          userProvider.avatarUrl.contains('svg') 
                            ? userProvider.avatarUrl.replaceFirst('svg', 'png') 
                            : userProvider.avatarUrl
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Greeting & Prompt
            Text(
              'Hi, ${userProvider.name}',
              style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Text(
              _promptText,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w400),
            ),
            
            if (_errorMsg.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _errorMsg,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // PIN Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (index) {
                bool isFilled = index < _inputPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 58, height: 58,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isFilled ? Colors.white.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.15),
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
            
            const Spacer(flex: 1),
            
            // Biometric Option (Only in Verify mode)
            if (_state == PinState.verify)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Use fingerprint',
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF00D09C), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Keypad
            _buildKeypad(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3']),
        const SizedBox(height: 10),
        _buildKeypadRow(['4', '5', '6']),
        const SizedBox(height: 10),
        _buildKeypadRow(['7', '8', '9']),
        const SizedBox(height: 10),
        _buildKeypadRow(['.', '0', 'BACKSPACE']),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          if (key == 'BACKSPACE') {
            return _buildKeyButton(
              onPressed: _onBackspace,
              child: const Icon(Icons.backspace_outlined, color: Colors.white, size: 28),
            );
          } else if (key == '.') {
            return _buildKeyButton(
              onPressed: () {},
              child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            );
          } else {
            return _buildKeyButton(
              onPressed: () => _onKeyPress(key),
              child: Text(key, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
            );
          }
        }).toList(),
      ),
    );
  }

  Widget _buildKeyButton({required VoidCallback onPressed, required Widget child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40),
        child: Container(width: 80, height: 80, alignment: Alignment.center, child: child),
      ),
    );
  }
}
