import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/notification/notification_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

class NotificationService {
  // ─── Get Notifications ──────────────────────────────────────────────────
  Future<NotificationsResponse> getNotifications({
    int page = 1,
    int perPage = 20,
    String? type, // 👈 NEW: 'unread' or 'all'
  }) async {
    final token = AppPreference().getString(PreferencesKey.authToken).trim();
    if (token.isEmpty) {
      throw Exception('Authentication token missing');
    }

    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'per_page': perPage,
      };
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await DioClient.dio.get(
        ApiEndpoints.notifications,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return NotificationsResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch notifications: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // ─── Mark as Read ──────────────────────────────────────────────────────
  Future<bool> markAsRead(String notificationId) async {
    final token = AppPreference().getString(PreferencesKey.authToken).trim();
    if (token.isEmpty) return false;

    try {
      final response = await DioClient.dio.post(
        '${ApiEndpoints.notifications}/$notificationId/read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ─── Mark All as Read ──────────────────────────────────────────────────
  Future<bool> markAllAsRead() async {
    final token = AppPreference().getString(PreferencesKey.authToken).trim();
    if (token.isEmpty) return false;

    try {
      final response = await DioClient.dio.post(
        '${ApiEndpoints.notifications}/mark-all-read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}