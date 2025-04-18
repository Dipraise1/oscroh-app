import 'dart:async';
import 'dart:math';
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
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.10)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.10, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0),
      ),
    );

    _animationController.repeat();

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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              // App Logo with enhanced visual effects
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      height: screenSize.width * 0.4,
                      width: screenSize.width * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.5),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: const Offset(0, -5),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.beetleBlack,
                            AppTheme.beetleBlack.withOpacity(0.8),
                          ],
                        ),
                        border: Border.all(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryPurple.withOpacity(0.15),
                              AppTheme.beetleBlack.withOpacity(0.9),
                            ],
                            radius: 0.8,
                          ),
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: Image.asset(
                              'assets/images/542ae11af98e0c99d5aeb4dc6a12f643.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),

              // App Name with enhanced visual effects
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppTheme.primaryPurple,
                    AppTheme.accentPurple,
                    Colors.white.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "OS APP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tagline with animated opacity
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final opacity =
                      sin(_animationController.value * 3.14) * 0.2 + 0.8;
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      "Find your vibe, keep your privacy",
                      style: TextStyle(
                        color: AppTheme.accentPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
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
