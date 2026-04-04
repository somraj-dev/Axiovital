// Mock Authentication Service
// Previously using firebase_auth and google_sign_in

class AuthService {
  // Mock current user info
  Map<String, dynamic>? _mockUser;

  AuthService() {
    // Optional: Seed mock user
    // _mockUser = {'uid': 'VS-99283', 'email': 'julian.v@vitalsync.ai'};
  }

  // Get current user (mock)
  dynamic get currentUser => _mockUser;

  // Auth state changes stream (mock)
  Stream<dynamic> get authStateChanges => Stream.value(_mockUser);

  // Sign in with Google (mock)
  Future<dynamic> signInWithGoogle() async {
    print('Mock: Signing in with Google...');
    await Future.delayed(const Duration(seconds: 1));
    _mockUser = {
      'uid': 'VS-99283',
      'email': 'julian.v@vitalsync.ai',
      'displayName': 'Dr. Julian Vance'
    };
    return _mockUser;
  }

  // Sign in with Email and Password (mock)
  Future<dynamic> signInWithEmail(String email, String password) async {
    print('Mock: Signing in with $email...');
    await Future.delayed(const Duration(seconds: 1));
    _mockUser = {
      'uid': 'VS-99283',
      'email': email,
      'displayName': 'Axiovital User'
    };
    return _mockUser;
  }

  // Sign up with Email and Password (mock)
  Future<dynamic> signUpWithEmail(String email, String password) async {
    print('Mock: Signing up with $email...');
    await Future.delayed(const Duration(seconds: 1));
    _mockUser = {
      'uid': 'VS-99283',
      'email': email,
      'displayName': 'New Axiovital User'
    };
    return _mockUser;
  }

  // Sign out (mock)
  Future<void> signOut() async {
    print('Mock: Signing out...');
    _mockUser = null;
  }

  // Get ID Token (mock)
  Future<String?> getIdToken() async {
    // Return a dummy static token that the backend can ignore or accept
    return "MOCK_TOKEN_VS-99283";
  }
}
