import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../main.dart';

// =============================================================
// BACKGROUND NOTIFICATION HANDLER
// Harus berupa fungsi top-level (di luar class)
// =============================================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

// =============================================================
// NOTIFICATION SERVICE
// =============================================================
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool _isInitialized = false;

  // =============================================================
  // MEMINTA IZIN NOTIFIKASI
  // =============================================================
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: '
      '${settings.authorizationStatus.name}',
    );

    return settings.authorizationStatus;
  }

  // =============================================================
  // MENDAPATKAN FCM TOKEN
  // =============================================================
  Future<String?> getToken() async {
    try {
      debugPrint('Memulai mengambil FCM Token...');

      final token = await _messaging.getToken();

      if (token == null) {
        debugPrint('FCM Token belum tersedia.');
      } else {
        debugPrint('FCM Token berhasil diperoleh.');
        debugPrint('FCM TOKEN SEBENARNYA: $token');
      }

      return token;
    } catch (error, stackTrace) {
      debugPrint('Gagal mengambil FCM Token: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  // =============================================================
  // MENDENGARKAN PERUBAHAN FCM TOKEN
  // =============================================================
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui.');
      onRefresh(newToken);
    });
  }

  // =============================================================
  // INISIALISASI NOTIFIKASI
  // =============================================================
  Future<void> init() async {
    if (_isInitialized) {
      debugPrint('Notification Service sudah diinisialisasi.');
      return;
    }

    try {
      // Meminta izin notifikasi
      await requestPermission();

      // Mengambil FCM Token
      final token = await getToken();

      if (token != null) {
        debugPrint('FCM Token siap digunakan.');
      }

      // Mendengarkan perubahan token
      listenTokenRefresh((newToken) {
        debugPrint('FCM Token baru diterima.');
      });

      // Pengaturan notifikasi foreground
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // =========================================================
      // FOREGROUND MESSAGE LISTENER
      // =========================================================
      debugPrint('Listener onMessage berhasil didaftarkan.');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FOREGROUND] Notification received');
        debugPrint('title: ${message.notification?.title}');
        debugPrint('body : ${message.notification?.body}');
        debugPrint('data : ${message.data}');

        final title = message.notification?.title ?? 'Notifikasi';
        final body = message.notification?.body ?? '';

        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('$title\n$body'),
            duration: const Duration(seconds: 5),
          ),
        );
      });

      _isInitialized = true;

      debugPrint('Notification Service berhasil diinisialisasi.');
    } catch (error, stackTrace) {
      debugPrint('Notification initialization error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
