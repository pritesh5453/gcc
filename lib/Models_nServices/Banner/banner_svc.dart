import 'package:dio/dio.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/Models_nServices/Banner/banner_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<List<BannerModel>> fetchBanners() async {
  try {
    // Get token with better null handling
    String token = AppPreference().getString(PreferencesKey.authToken);

    if (token.isEmpty) {
      token = AppPreference().getString('token') ?? '';
    }

    if (token.isEmpty) {
      print('No auth token found for banners');
      return []; // Return empty list instead of throwing exception
    }

    print('Fetching banners...');
    print(
      'Token: ${token.substring(0, token.length > 20 ? 20 : token.length)}...',
    );

    // Create a new Dio instance with proper headers
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          // Accept all status codes to handle them manually
          return status != null && status < 500;
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Important: Tell server we want JSON
        },
      ),
    );

    print('Banner API URL: ${ApiEndpoints.banners}');

    Response response = await dio.get(ApiEndpoints.banners);

    print('Banner API Status: ${response.statusCode}');
    print('Response Headers: ${response.headers}');

    // Check if response is HTML (authentication failed)
    if (response.data is String &&
        response.data.toString().contains('<!DOCTYPE html>')) {
      print('Authentication failed - received HTML login page');
      print('Token might be expired or invalid');
      return []; // Return empty list, UI will show fallback
    }

    // Check if response status is OK
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;

      // Handle different response structures
      List bannersList = [];

      if (responseData is List) {
        bannersList = responseData;
      } else if (responseData['data'] is List) {
        bannersList = responseData['data'];
      } else if (responseData['banners'] is List) {
        bannersList = responseData['banners'];
      } else if (responseData['result'] is List) {
        bannersList = responseData['result'];
      } else if (responseData['success'] == true &&
          responseData['data'] is List) {
        bannersList = responseData['data'];
      } else {
        print('Unexpected response structure: $responseData');
        return [];
      }

      print('Found ${bannersList.length} banners');

      return bannersList.map((item) {
        return BannerModel.fromJson(item as Map<String, dynamic>);
      }).toList();
    } else if (response.statusCode == 401) {
      print('Unauthorized - Token expired or invalid');
      // Optionally trigger logout here
      return [];
    } else {
      print('Failed to load banners: ${response.statusCode}');
      return [];
    }
  } on DioException catch (e) {
    print('DioException in fetchBanners: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');

    // Check if it's an authentication error
    if (e.response?.statusCode == 401) {
      print('Authentication failed - please login again');
      // You might want to navigate to login screen here
    }
    return [];
  } catch (e) {
    print('Unexpected error in fetchBanners: $e');
    return [];
  }
}
