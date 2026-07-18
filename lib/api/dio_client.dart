import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/main.dart'; // navigatorKey
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AppPreference().getString(PreferencesKey.authToken);
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          // ─── Only handle 401 ──────────────────────────────
          if (error.response?.statusCode == 401) {
            print('🔥 401 intercepted!'); // debug log

            // Clear session
            final prefs = AppPreference();
            await prefs.clearSharedPreferences();
            await prefs.setBool(PreferencesKey.isLoggedIn, false);

            // ─── Robust navigation ──────────────────────────
            // Use addPostFrameCallback to ensure the widget tree is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _performLogoutNavigation();
            });

            // Fallback: if the callback never runs (rare), try after a delay
            Future.delayed(const Duration(milliseconds: 500), () {
              _performLogoutNavigation();
            });
          }
          // Always pass the error forward
          handler.next(error);
        },
      ),
    );

  // Helper method to perform logout navigation
  static void _performLogoutNavigation() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Already on login screen? Avoid looping.
    final currentRoute = ModalRoute.of(context);
    if (currentRoute?.settings.name == '/login') return;

    // Navigate to login and clear stack
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );

    // Show snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Session expired. You have been logged out from another device.',
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}