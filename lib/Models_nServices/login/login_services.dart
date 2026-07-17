import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/login/login_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class AuthApiService {
  Future<LoginModel> login({
    required String phone,
    required String firebaseToken,
  }) async {
    Response response = await DioClient.dio.post(
      ApiEndpoints.login,
      data: {
        "phone": phone,
        "firebase_token": firebaseToken,
      },
    );
    return LoginModel.fromJson(response.data);
  }

  Future<LoginModel> register({
    required String name,
    required String email,
    required String phone,
     String? referralCode,
  }) async {
    try {
      Response response = await DioClient.dio.post(
        ApiEndpoints.register,
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "referral_code": referralCode,
        },
      );
      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      // Keep this for register (if needed)
      throw Exception(
        e.response?.data["message"] ?? "Something went wrong",
      );
    }
  }
}