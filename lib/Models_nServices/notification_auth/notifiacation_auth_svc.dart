// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:gcc/api/api_endpoints.dart';
// import 'package:gcc/api/dio_client.dart';
// import 'package:gcc/prefs/app_preference.dart';
// import 'package:gcc/prefs/PreferencesKey.dart';

// class FcmService {
//   Future<void> saveFcmToken() async {
//     try {
//       final token = await FirebaseMessaging.instance.getToken();

//       if (token == null) return;

//       final bearerToken =
//           AppPreference().getString(PreferencesKey.authToken);

//       if (bearerToken.isEmpty) {
//         debugPrint("Bearer token not found");
//         return;
//       }

//       debugPrint("FCM TOKEN => $token");

//       final response = await DioClient.dio.post(
//         ApiEndpoints.saveFcmToken,
//         data: {
//           "fcm_token": token,
//         },
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $bearerToken",
//           },
//         ),
//       );

//       debugPrint("Status Code => ${response.statusCode}");
//       debugPrint("Response => ${response.data}");
//     } catch (e) {
//       debugPrint("FCM Save Error => $e");
//     }
//   }
// }