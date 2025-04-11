#!/bin/bash

echo "===========================================" 
echo "Firebase Setup Instructions for 'OS App'" 
echo "===========================================" 
echo

echo "STEP 1: Create a Firebase project"
echo "1. Go to https://console.firebase.google.com/"
echo "2. Click 'Add project' and name it 'OS App'"
echo "3. Follow the setup wizard (disable Google Analytics if not needed)"
echo

echo "STEP 2: Register your iOS app"
echo "1. In Firebase console, click 'iOS' icon to add an iOS app"
echo "2. Enter Bundle ID: com.osapp.app (or your custom bundle ID from Info.plist)"
echo "3. Download the GoogleService-Info.plist file"
echo "4. Place it in the ios/Runner directory of your Flutter project"
echo

echo "STEP 3: Register your Android app"
echo "1. In Firebase console, click 'Android' icon to add an Android app"
echo "2. Enter package name: com.osapp.app (or check your AndroidManifest.xml file)"
echo "3. Download the google-services.json file"
echo "4. Place it in the android/app directory of your Flutter project"
echo

echo "STEP 4: Update your Android build configuration"
echo "1. Ensure your android/build.gradle file has classpath 'com.google.gms:google-services:4.3.15'"
echo "2. Ensure your android/app/build.gradle file applies the google-services plugin"
echo

echo "STEP 5: Enable Authentication in Firebase"
echo "1. In Firebase console, go to 'Authentication' section"
echo "2. Click 'Get started' and enable Email/Password authentication"
echo

echo "STEP 6: Set up Firestore Database"
echo "1. In Firebase console, go to 'Firestore Database' section"
echo "2. Click 'Create database'"
echo "3. Start in production mode"
echo "4. Choose a location close to your users (e.g., europe-west for European users)"
echo

echo "STEP 7: Set up Storage"
echo "1. In Firebase console, go to 'Storage' section"
echo "2. Click 'Get started'"
echo "3. Start in production mode"
echo "4. Choose the same location as your Firestore Database"
echo

echo "After completing these steps, run: flutter pub get"
echo "Then build and run your app: flutter run"
echo
echo "For more detailed instructions, visit: https://firebase.google.com/docs/flutter/setup" 