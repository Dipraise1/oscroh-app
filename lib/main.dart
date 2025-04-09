import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/demo_mode_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set app to demo mode by default for testing
  DemoModeService().setDemoMode(true);
  await DemoModeService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Os Motto Hook Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8A56AC), // Primary Purple
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A56AC),
          primary: const Color(0xFF8A56AC),
          secondary: const Color(0xFFB088CF), // Lighter Purple
          background: Colors.white,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8A56AC),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8A56AC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFF8A56AC),
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF8A56AC),
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF333333)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8A56AC), width: 2),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
