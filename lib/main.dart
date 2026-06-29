import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gcc/firebase_options.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/splash_screen.dart';
import 'package:gcc/local_notification_service.dart';

// Global RouteObserver
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Authentication Provider
final authProvider = StateProvider<bool>((ref) => false);

// Initial Auth State Provider
final authStateProvider = FutureProvider<bool>((ref) async {
  await AppPreference().initialAppPreference();
  return AppPreference().getBool(PreferencesKey.isLoggedIn);
});

/// Background Notification Handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

  debugPrint("========== Background Notification ==========");
  debugPrint("Title : ${message.notification?.title}");
  debugPrint("Body  : ${message.notification?.body}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
 if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
await LocalNotificationService.initialize();

FirebaseMessaging.onBackgroundMessage(
  _firebaseMessagingBackgroundHandler,
);



  await AppPreference().initialAppPreference();

  final loggedIn =
      AppPreference().getBool(PreferencesKey.isLoggedIn);

  runApp(
    ProviderScope(
      child: MyApp(
        initiallyLoggedIn: loggedIn,
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool initiallyLoggedIn;

  const MyApp({
    super.key,
    this.initiallyLoggedIn = false,
  });

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = widget.initiallyLoggedIn;

    Future.microtask(() {
      ref.read(authProvider.notifier).state = _isLoggedIn;
    });

    _setupFirebase();
  }

  Future<void> _setupFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Ask Permission
    NotificationSettings settings =
        await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
        "Notification Permission : ${settings.authorizationStatus}");

    // Get Device Token
    String? token = await FirebaseMessaging.instance.getToken();

debugPrint("==========================================");
debugPrint("FCM TOKEN => $token");
debugPrint("==========================================");

    /// TODO:
    /// Send this token to your backend API
    ///
    /// Example
    /// await ApiService.saveFcmToken(token);

    // Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  debugPrint("========== Foreground ==========");
  debugPrint("Title : ${message.notification?.title}");
  debugPrint("Body  : ${message.notification?.body}");

  if (message.notification != null) {
    await LocalNotificationService.showNotification(
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
    );
  }
});

    // Notification Click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification Clicked");

      // Navigate if required
      // Navigator.push(...)
    });

    // App opened from terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint("Opened from terminated state");
    }

    // Token Refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint("New FCM Token : $newToken");

      /// Update Backend
      /// ApiService.saveFcmToken(newToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(authProvider, (previous, next) {
      if (previous != next) {
        setState(() {
          _isLoggedIn = next;
        });
      }
    });

    return MaterialApp(
      title: 'GreenChain',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: SplashScreen(
        isLoggedIn: _isLoggedIn,
      ),
    );
  }
}