import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gcc/Models_nServices/portfolio/portfolio_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class PortfolioService {
  Future<PortfolioResponse> fetchPortfolio(String bearerToken) async {
    try {
      print("=== Portfolio API Called ===");
      print("URL: ${ApiEndpoints.portfolio}");
      print("Token: $bearerToken");

      final response = await DioClient.dio.get(
        ApiEndpoints.portfolio,
        options: Options(headers: {'Authorization': 'Bearer $bearerToken'}),
      );

      print("=== Portfolio API Response ===");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return PortfolioResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load portfolio: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=== Dio Error ===");
      print("Message: ${e.message}");
      print("Type: ${e.type}");
      print("Status Code: ${e.response?.statusCode}");
      print("Response Data: ${e.response?.data}");
      print("Request URL: ${e.requestOptions.uri}");

      throw Exception('Network error: ${e.response?.data ?? e.message}');
    } catch (e, stackTrace) {
      print("=== Unexpected Error ===");
      print("Error: $e");
      print("StackTrace: $stackTrace");

      throw Exception('Unexpected error: $e');
    }
  }
}
