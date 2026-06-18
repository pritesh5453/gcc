import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/Models_nServices/home_screen/home_screen_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<HomeScreenResponse> fetchHomeScreen() async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found. Please login again.');
  }

  try {
    Response response = await DioClient.dio.get(
      ApiEndpoints.homeScreen,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    log('Home screen API response: ${response.data}');
    return HomeScreenResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'Failed to load home screen data',
    );
  }
}
