import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';
import '../services/firebase_checker.dart';
import '../services/auth_service.dart';
import '../services/demo_mode_service.dart';
import '../theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String _statusMessage = "Initializing...";
  bool _hasError = false;
  bool _showDemoOption = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for a minimum time to display splash screen
      await Future.delayed(const Duration(seconds: 2));

      // Check if already in demo mode
      if (DemoModeService().isDemoMode) {
        setState(() {
          _statusMessage = "Starting demo mode...";
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
        return;
      }

      setState(() {
        _statusMessage = "Checking Firebase configuration...";
      });

      // Check Firebase configuration
      final firebaseChecks = await FirebaseChecker.checkAll();

      if (!firebaseChecks['initialized']!) {
        setState(() {
          _statusMessage = firebaseChecks['errorMessage'] ??
              "Firebase is not initialized properly. Please check your configuration.";
          _hasError = true;
          _showDemoOption = true;
        });
        return;
      }

      if (!firebaseChecks['auth']!) {
        setState(() {
          _statusMessage = "Firebase Authentication is not set up correctly.";
          _hasError = true;
          _showDemoOption = true;
        });
        return;
      }

      if (!firebaseChecks['firestore']!) {
        setState(() {
          _statusMessage = "Firebase Firestore is not set up correctly.";
          _hasError = true;
          _showDemoOption = true;
        });
        return;
      }

      if (!firebaseChecks['storage']!) {
        setState(() {
          _statusMessage = "Firebase Storage is not set up correctly.";
          _hasError = true;
          _showDemoOption = true;
        });
        return;
      }

      setState(() {
        _statusMessage = "Initializing services...";
      });

      // Initialize auth service
      await AuthService().initialize();

      // Everything is set up, navigate to onboarding
      setState(() {
        _statusMessage = "Ready!";
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error: ${e.toString()}";
        _hasError = true;
        _showDemoOption = true;
      });
    }
  }

  void _continueToDemoMode() async {
    setState(() {
      _hasError = false;
      _showDemoOption = false;
      _statusMessage = "Starting demo mode...";
    });

    // Initialize demo mode
    DemoModeService().setDemoMode(true);
    await DemoModeService().initialize();

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.beetleBlack,
              AppTheme.beetleBlack.withOpacity(0.9),
              AppTheme.primaryPurple.withOpacity(0.4),
              AppTheme.beetleBlack,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo with pulsating effect
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: AppTheme.beetleBlack,
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/542ae11af98e0c99d5aeb4dc6a12f643.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // App Name
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppTheme.primaryPurple,
                    AppTheme.accentPurple,
                    Colors.white.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "OS APP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tagline
              Text(
                "Find your vibe, keep your privacy",
                style: TextStyle(
                  color: AppTheme.accentPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),
              // Status Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        _hasError ? Colors.red.shade300 : AppTheme.accentPurple,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Loading indicator or buttons
              if (!_hasError)
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppTheme.beetleBlack.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPurple.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                    strokeWidth: 3,
                  ),
                ),
              if (_hasError && _showDemoOption) ...[
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _continueToDemoMode,
                      child: const Text(
                        "Continue in Demo Mode",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            _hasError = false;
                            _showDemoOption = false;
                            _statusMessage = "Retrying...";
                          });
                          _initializeApp();
                        }
                      },
                      child: Text(
                        "Retry Connection",
                        style: TextStyle(
                          color: AppTheme.accentPurple,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
