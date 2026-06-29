// // Add this method to your NotificationService class

// // ─── Get Unread Notification Count ───────────────────────────────────────
// import 'package:dio/dio.dart';
// import 'package:gcc/Models_nServices/unread_notification_count/unerad_count_model.dart';
// import 'package:gcc/api/api_endpoints.dart';
// import 'package:gcc/api/dio_client.dart';
// import 'package:gcc/prefs/PreferencesKey.dart';
// import 'package:gcc/prefs/app_preference.dart';

// Future<UnreadCountResponse> getUnreadCount() async {
//   final token = AppPreference().getString(PreferencesKey.authToken).trim();
//   if (token.isEmpty) {
//     throw Exception('Authentication token missing');
//   }

//   try {
//     final response = await DioClient.dio.get(
//       '${ApiEndpoints.notifications}/unread-count',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       ),
//     );

//     if (response.statusCode == 200) {
//       return UnreadCountResponse.fromJson(response.data);
//     } else {
//       throw DioException(
//         requestOptions: response.requestOptions,
//         response: response,
//         message: 'Failed to fetch unread count: ${response.statusCode}',
//       );
//     }
//   } on DioException catch (e) {
//     rethrow;
//   }
// }