import 'package:dio/dio.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/Models_nServices/login/login_model.dart';
import 'package:gcc/api/dio_client.dart';

class AuthApiService {
  Future<LoginModel> login({
    required String phone,
  }) async {
    try {
      Response response = await DioClient.dio.post(
        ApiEndpoints.login,
        data: {
          "phone": phone,
        },
      );

      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Something went wrong",
      );
    }
  }
}