import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../app_keys.dart';
import '../firebase_options.dart';
import '../screens/kos_detail_page.dart';

// =============================================================
// BACKGROUND MESSAGE HANDLER
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
  bool _isInteractionSetup = false;

  // ===========================================================
  // REQUEST NOTIFICATION PERMISSION
  // ===========================================================
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

  // ===========================================================
  // GET FCM TOKEN
  // ===========================================================
  Future<String?> getToken() async {
    try {
      debugPrint('Memulai mengambil FCM Token...');

      final token = await _messaging.getToken();

      if (token == null) {
        debugPrint('FCM Token belum tersedia.');
      } else {
        debugPrint('FCM Token berhasil diperoleh.');
      }

      return token;
    } catch (error, stackTrace) {
      debugPrint('Gagal mengambil FCM Token: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  // ===========================================================
  // LISTEN TOKEN REFRESH
  // ===========================================================
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui.');
      onRefresh(newToken);
    });
  }

  // ===========================================================
  // INITIALIZE NOTIFICATION
  // ===========================================================
  Future<void> init() async {
    if (_isInitialized) {
      debugPrint('Notification Service sudah diinisialisasi.');
      return;
    }

    try {
      await requestPermission();

      final token = await getToken();

      if (token != null) {
        debugPrint('FCM Token siap digunakan.');
      }

      listenTokenRefresh((newToken) {
        debugPrint('FCM Token baru diterima.');
      });

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('Listener onMessage berhasil didaftarkan.');

      // Foreground notification listener
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

  // ===========================================================
  // NOTIFICATION INTERACTION
  // ===========================================================
  Future<void> setupInteractedMessage() async {
    if (_isInteractionSetup) {
      debugPrint('Notification interaction sudah diinisialisasi.');
      return;
    }

    try {
      // Ketika aplikasi dibuka melalui notifikasi
      // dari kondisi terminated
      final initialMessage = await _messaging.getInitialMessage();

      if (initialMessage != null) {
        _handleTap(initialMessage);
      }

      // Ketika notifikasi ditekan saat aplikasi background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

      _isInteractionSetup = true;

      debugPrint('Notification interaction berhasil diinisialisasi.');
    } catch (error, stackTrace) {
      debugPrint('Notification interaction error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  // ===========================================================
  // HANDLE NOTIFICATION TAP
  // ===========================================================
  void _handleTap(RemoteMessage message) {
    debugPrint('[NOTIFICATION TAP] Notifikasi ditekan.');

    debugPrint('Notification data: ${message.data}');

    final kosId = message.data['kos_id'];

    if (kosId == null || kosId.toString().isEmpty) {
      debugPrint('kos_id tidak ditemukan pada notification data.');
      return;
    }

    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => KosDetailPage(kosId: kosId.toString())),
    );
  }
}
