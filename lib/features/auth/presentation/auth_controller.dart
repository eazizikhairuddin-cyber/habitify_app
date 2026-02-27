import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, AppUser?>(AuthController.new);

class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email, isGuest: user.isAnonymous);
  }

  Future<void> signInEmail(String email, String password) async {
    state = const AsyncLoading();
    final creds = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    state = AsyncData(AppUser(uid: creds.user!.uid, email: creds.user?.email, isGuest: false));
  }

  Future<void> signUpEmail(String email, String password) async {
    state = const AsyncLoading();
    final creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    state = AsyncData(AppUser(uid: creds.user!.uid, email: creds.user?.email, isGuest: false));
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final account = await GoogleSignIn().signIn();
    final auth = await account?.authentication;
    if (auth == null) {
      state = const AsyncData(null);
      return;
    }
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final creds = await FirebaseAuth.instance.signInWithCredential(credential);
    state = AsyncData(AppUser(uid: creds.user!.uid, email: creds.user?.email, isGuest: false));
  }

  Future<void> signInGuest() async {
    state = const AsyncLoading();
    final creds = await FirebaseAuth.instance.signInAnonymously();
    state = AsyncData(AppUser(uid: creds.user!.uid, email: null, isGuest: true));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    state = const AsyncData(null);
  }
}
