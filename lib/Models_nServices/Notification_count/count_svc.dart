// lib/Models_nServices/notification/notification_svc.dart

import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/Notification_count/count_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';

class UnreadNotificationService {
  final Dio _dio;
  final AppPreference _prefs;

  UnreadNotificationService(this._dio, this._prefs);

  Future<NotificationUnreadCountResponse> fetchUnreadCount() async {
    try {
      final token = _prefs.getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(
        ApiEndpoints.notificationsUnreadCount,
      );

      if (response.statusCode == 200) {
        return NotificationUnreadCountResponse.fromJson(response.data);
      } else {
        throw DioError(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Server returned ${response.statusCode}',
        );
      }
    } on DioError catch (e) {
      throw Exception('Failed to fetch unread count: ${e.message}');
    }
  }
}