# Habitify App (Flutter Mobile Only)

## Firebase setup
1. Create Firebase project.
2. Add Android app (`android/app/google-services.json`).
3. Add iOS app (`ios/Runner/GoogleService-Info.plist`).
4. Enable Authentication providers: Email/Password, Google, Anonymous.
5. Enable Cloud Firestore.
6. Enable Cloud Messaging.
7. Replace placeholders in `lib/core/services/firebase_options.dart`.
8. Android: ensure `minSdkVersion 23+`, apply Google services plugin.
9. iOS: run `pod install`, enable Push Notifications + Background Modes.

## Run on real Android device
```bash
flutter pub get
flutter run -d <device_id>
```
