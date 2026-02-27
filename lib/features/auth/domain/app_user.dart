class AppUser {
  AppUser({required this.uid, required this.email, required this.isGuest});

  final String uid;
  final String? email;
  final bool isGuest;
}
