import 'package:flutter/foundation.dart';

class FirebaseChecker {
  // Run all Firebase checks
  static Future<Map<String, dynamic>> checkAll() async {
    // Always return demo mode
    return {
      'initialized': false,
      'auth': false,
      'firestore': false,
      'storage': false,
      'errorMessage': 'Running in demo mode for testing purposes.'
    };
  }
}
