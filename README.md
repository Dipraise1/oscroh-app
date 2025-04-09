# Os Motto Hook Up

A private Nigerian meet-up app built with Flutter. Find your vibe, keep your privacy.

## Description

Os Motto Hook Up is a dating/social app designed specifically for Nigerians with privacy as a core feature:

- **No public photos** – your image stays yours
- **Private DMs** for image sharing when you're comfortable
- **Match by City & State** – from Lagos to Kano, Jos to Port Harcourt
- **Full privacy control** – vibe first, reveal later

Whether you're seeking a serious relationship, casual friendship, or just someone to chat with, Os Motto Hook Up helps you find the right people near you without the pressure.

## Features

- User authentication (signup, login, password reset)
- Profile creation and editing
- Location-based matching
- Interest-based filtering
- Private messaging
- User privacy controls
- Match notifications

## Tech Stack

- **Frontend**: Flutter/Dart
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider
- **Other Libraries**: 
  - `geolocator` for location services
  - `image_picker` for profile images
  - `flutter_secure_storage` for secure data storage
  - `cached_network_image` for efficient image loading

## Firebase Setup

Before running the app, you need to set up Firebase:

1. Create a new Firebase project at https://console.firebase.google.com/
2. Add iOS and Android applications to your Firebase project:
   - Android package name: `com.osmotto.hookup`
   - iOS bundle ID: `com.osmotto.hookup`

3. Download the Firebase configuration files:
   - Download `google-services.json` and place it in the `android/app/` directory
   - Download `GoogleService-Info.plist` and place it in the `ios/Runner/` directory

4. Enable the following Firebase services:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage

5. Create the following Firestore security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /matches/{matchId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.user1Id || request.auth.uid == resource.data.user2Id);
    }
    match /messages/{messageId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.senderId || request.auth.uid == resource.data.recipientId);
    }
  }
}
```

6. Create the following Storage security rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profileImages/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /messageImages/{messageId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/os_motto_hookup.git
   cd os_motto_hookup
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
  ├── main.dart        # Entry point
  ├── models/          # Data models
  ├── screens/         # App screens  
  │    ├── auth/       # Authentication screens
  │    ├── tabs/       # Main tab screens
  ├── services/        # Backend services
  ├── widgets/         # Reusable UI components
```

## Color Scheme

- Primary: Purple (#8A56AC)
- Secondary: Light Purple (#B088CF)
- Background: White
- Text: Black/Gray

## Contributing

We welcome contributions to improve the app. Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Your Name - [@yourusername](https://twitter.com/yourusername) - email@example.com

Project Link: [https://github.com/yourusername/os_motto_hookup](https://github.com/yourusername/os_motto_hookup) # oscroh-app
