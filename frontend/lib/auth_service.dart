import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final Map<String, dynamic> _mockUserData = {
    'uid': 'VS-99283',
    'name': 'Dr. Julian Vance',
    'email': 'julian.v@vitalsync.ai',
    'avatarUrl': 'https://ui-avatars.com/api/?name=Julian+Vance&background=random',
  };

  Map<String, dynamic>? get currentUser => _mockUserData;

  Future<bool> login(String email, String password) async {
    // Simulating login delay
    await Future.delayed(const Duration(seconds: 1));
    return email == 'julian.v@vitalsync.ai' && password == 'password';
  }

  Future<void> logout() async {
    // Logic for logging out
  }
}
