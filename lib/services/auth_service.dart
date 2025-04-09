import 'dart:async';
import '../models/user_model.dart';
import 'demo_mode_service.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Auth state stream controller
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();
  Stream<User?> get authStateChanges => _authStateController.stream;

  // Initialize the service
  Future<void> initialize() async {
    // Just delegate to demo mode service
    return DemoModeService().initialize();
  }

  // Sign up
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
    required int age,
    required String gender,
    required String city,
    required String state,
    required String bio,
    required List<String> interests,
  }) async {
    // Use demo service login
    return DemoModeService().demoLogin(email: email, password: password);
  }

  // Login
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Use demo service login
    return DemoModeService().demoLogin(email: email, password: password);
  }

  // Logout
  Future<void> logout() async {
    return DemoModeService().logout();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  // Update user profile
  Future<User> updateProfile({
    required String username,
    required int age,
    required String gender,
    required String city,
    required String state,
    required String bio,
    required List<String> interests,
    String? profileImage,
  }) async {
    final demoService = DemoModeService();
    if (demoService.currentUser == null) {
      throw Exception('No user logged in');
    }

    // Create updated user
    final updatedUser = demoService.currentUser!.copyWith(
      username: username,
      age: age,
      gender: gender,
      city: city,
      state: state,
      bio: bio,
      interests: interests,
      profileImage: profileImage ?? demoService.currentUser!.profileImage,
    );

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Update current user and notify listeners
    _currentUser = updatedUser;
    _authStateController.add(_currentUser);

    return updatedUser;
  }

  // Dispose
  void dispose() {
    _authStateController.close();
  }
}
