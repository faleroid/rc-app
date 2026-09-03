import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../repositories/device_token_repository.dart';
import '../router/app_router.dart';
import 'token_service.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print("FCM Background Message: ${message.messageId} - ${message.data}");
  }
}

class PushNotificationService {
  PushNotificationService._internal();
  static final PushNotificationService instance =
      PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final DeviceTokenRepository _tokenRepo = DeviceTokenRepository();

  static const String vipTopic = 'vip_members';
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ricocapital_vip_channel',
    'RicoCapital VIP Notifications',
    description: 'Notifikasi real-time sinyal trading dan pengumuman VIP',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  bool _isInitialized = false;

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Request user permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      print('FCM Authorization status: ${settings.authorizationStatus}');
    }

    // 2. Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. Configure local notifications for foreground display
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            handleNotificationNavigation(data);
          } catch (e) {
            if (kDebugMode) print("Error parsing notification payload: $e");
          }
        }
      },
    );

    // 4. Create Android high priority notification channel
    final androidNotifications = _localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidNotifications?.createNotificationChannel(_channel);
    await androidNotifications?.requestNotificationsPermission();

    // 5. Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("FCM Foreground Message: ${message.notification?.title}");
      }
      _showLocalNotification(message);
    });

    // 6. Handle notification click when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("FCM onMessageOpenedApp: ${message.data}");
      }
      handleNotificationNavigation(message.data);
    });

    _fcm.onTokenRefresh.listen((token) {
      _registerRefreshedToken(token);
    });

    // 7. Check if app was opened from terminated state via notification
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print("FCM getInitialMessage: ${initialMessage.data}");
      }
      Future.delayed(const Duration(milliseconds: 1000), () {
        handleNotificationNavigation(initialMessage.data);
      });
    }

    _isInitialized = true;
  }

  /// Show heads-up notification in foreground
  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      message.hashCode,
      notification.title ?? 'RicoCapital VIP',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@mipmap/launcher_icon',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Subscribe to VIP notifications & register token on backend
  Future<void> subscribeVipTopic() async {
    try {
      await _fcm.subscribeToTopic(vipTopic);
      final token = await _fcm.getToken();
      if (token != null && token.isNotEmpty) {
        await _tokenRepo.registerToken(token, platform: _platformName);
        if (kDebugMode) {
          print("Subscribed to '$vipTopic' topic with token: $token");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error subscribing to VIP topic: $e");
      }
    }
  }

  String get _platformName {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return 'ios';
      default:
        return 'android';
    }
  }

  Future<void> _registerRefreshedToken(String token) async {
    final authToken = await TokenService().getToken();
    if (authToken == null || authToken.isEmpty) return;

    await _tokenRepo.registerToken(token, platform: _platformName);
  }

  /// Unsubscribe from VIP notifications & remove token from backend
  Future<void> unsubscribeVipTopic() async {
    try {
      await _fcm.unsubscribeFromTopic(vipTopic);
      final token = await _fcm.getToken();
      if (token != null && token.isNotEmpty) {
        await _tokenRepo.removeToken(token);
        if (kDebugMode) {
          print("Unsubscribed from '$vipTopic' topic");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error unsubscribing from VIP topic: $e");
      }
    }
  }

  /// Route user based on notification payload data
  void handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type']?.toString().toLowerCase();

    if (type == 'signal') {
      // Navigate to main screen at Signals tab (index 1)
      appRouter.go('/main', extra: {
        'isLoggedIn': true,
        'index': 1,
      });
    } else if (type == 'announcement') {
      // Navigate to announcements screen
      appRouter.push('/announcements');
    }
  }
}
