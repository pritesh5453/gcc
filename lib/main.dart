import 'package:flutter/material.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/Onboarding/onboarding.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference().initialAppPreference();
  final loggedIn = AppPreference().getBool(PreferencesKey.isLoggedIn);
  runApp(MyApp(initiallyLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool initiallyLoggedIn;
  const MyApp({super.key, this.initiallyLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: initiallyLoggedIn ? const MainScreen() : const WelcomeScreen(),
    );
  }
}
