import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/splash_screen.dart';

// Global RouteObserver for route awareness (used in EarnRewardsScreen)
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Riverpod provider for authentication state
final authProvider = StateProvider<bool>((ref) {
  return false;
});

// Provider to load initial auth state asynchronously
final authStateProvider = FutureProvider<bool>((ref) async {
  await AppPreference().initialAppPreference();
  return AppPreference().getBool(PreferencesKey.isLoggedIn);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference().initialAppPreference();
  final loggedIn = AppPreference().getBool(PreferencesKey.isLoggedIn);
  runApp(ProviderScope(child: MyApp(initiallyLoggedIn: loggedIn)));
}

class MyApp extends ConsumerStatefulWidget {
  final bool initiallyLoggedIn;
  const MyApp({super.key, this.initiallyLoggedIn = false});

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
      // ✅ App hamesha SplashScreen se start hogi
      home: SplashScreen(isLoggedIn: _isLoggedIn),
    );
  }
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────
