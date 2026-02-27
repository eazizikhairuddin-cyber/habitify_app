import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmInitializerProvider = FutureProvider<void>((_) async {
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getToken();
});
