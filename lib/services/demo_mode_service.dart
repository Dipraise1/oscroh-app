import 'dart:async';
import '../models/user_model.dart';

class DemoModeService {
  // Singleton pattern
  static final DemoModeService _instance = DemoModeService._internal();
  factory DemoModeService() => _instance;
  DemoModeService._internal();

  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Auth state stream controller
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();
  Stream<User?> get authStateChanges => _authStateController.stream;

  // Determine if we are in demo mode
  bool _isDemoMode = false;
  bool get isDemoMode => _isDemoMode;

  // Set demo mode - call this from splash screen when Firebase is not configured
  void setDemoMode(bool value) {
    _isDemoMode = value;
  }

  // Initialize the service
  Future<void> initialize() async {
    // No users logged in initially
    _currentUser = null;
    _authStateController.add(_currentUser);
  }

  // Demo login
  Future<User> demoLogin({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Create a demo user
    final user = User(
      id: 'demo-user-123',
      username: 'DemoUser',
      age: 28,
      gender: 'Male',
      city: 'Lagos',
      state: 'Lagos',
      bio: 'This is a demo account to explore the app features.',
      interests: ['Movies', 'Music', 'Travel', 'Food'],
      isVerified: true,
      lastActive: DateTime.now(),
    );

    // Update current user and notify listeners
    _currentUser = user;
    _authStateController.add(_currentUser);

    return user;
  }

  // Demo logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStateController.add(_currentUser);
  }

  // Dispose
  void dispose() {
    _authStateController.close();
  }
}
