import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';
import '../services/firebase_checker.dart';
import '../services/auth_service.dart';
import '../services/demo_mode_service.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _statusMessage = "Initializing...";
  bool _hasError = false;
  bool _showDemoOption = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for a minimum time to display splash screen
      await Future.delayed(const Duration(seconds: 1));

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8A56AC), Color(0xFFB088CF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo (temporary placeholder)
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.favorite,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // App Name
            const Text(
              "OS MOTTO",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              "HOOK UP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 15),
            // Tagline
            const Text(
              "Find your vibe, keep your privacy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 30),
            // Status Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _hasError ? Colors.red.shade100 : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Loading indicator or buttons
            if (_hasError && _showDemoOption) ...[
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _continueToDemoMode,
                    child: const Text("Continue in Demo Mode"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _hasError = false;
                          _statusMessage = "Retrying...";
                        });
                        _initializeApp();
                      }
                    },
                    child: const Text("Retry"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text(
                      "Exit App",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ] else if (_hasError) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _hasError = false;
                      _statusMessage = "Retrying...";
                    });
                    _initializeApp();
                  }
                },
                child: const Text("Retry"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  "Exit App",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ] else ...[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
