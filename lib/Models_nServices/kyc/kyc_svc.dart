import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/kyc/kyc_model1.dart';
import 'package:gcc/Models_nServices/kyc/kyc_model2.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class KycService {
  Future<KycDetailsResponse> fetchKycDetails(String token) async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.kycDetails,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return KycDetailsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load KYC details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<KycSubmitResponse> submitFullKyc({
    required String token,
    required Map<String, String> fields,
    required Map<String, MultipartFile> files,
  }) async {
    try {
      final formData = FormData();
      fields.forEach((key, value) => formData.fields.add(MapEntry(key, value)));
      files.forEach((key, file) => formData.files.add(MapEntry(key, file)));

      final response = await DioClient.dio.post(
        ApiEndpoints.kycSubmit,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );
      return KycSubmitResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Submission failed: ${e.message}');
    }
  }

  Future<KycSubmitResponse> submitAadhaar({
    required String token,
    required String aadhaarNumber,
    required MultipartFile frontImage,
    required MultipartFile backImage,
  }) async {
    final formData = FormData.fromMap({
      'aadhaar_number': aadhaarNumber,
      'aadhaar_front_image': frontImage,
      'aadhaar_back_image': backImage,
    });
    final response = await DioClient.dio.post(
      ApiEndpoints.kycAadhaarSave,
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: 'multipart/form-data',
      ),
    );
    return KycSubmitResponse.fromJson(response.data);
  }

  Future<KycSubmitResponse> submitPan({
    required String token,
    required String panNumber,
    required MultipartFile panImage,
  }) async {
    final formData = FormData.fromMap({
      'pan_number': panNumber,
      'pan_card_image': panImage,
    });
    final response = await DioClient.dio.post(
      ApiEndpoints.kycPanSave,
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: 'multipart/form-data',
      ),
    );
    return KycSubmitResponse.fromJson(response.data);
  }

  Future<KycSubmitResponse> submitBank({
    required String token,
    required Map<String, String> bankData,
  }) async {
    final response = await DioClient.dio.post(
      ApiEndpoints.kycBankVerify,
      data: bankData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    return KycSubmitResponse.fromJson(response.data);
  }
}


// // services/kyc_service.dart

// import 'package:dio/dio.dart';
// import '../dio_client.dart'; // tera DioClient file path
// import '../models/profile_update_model.dart';

// class KycService {
//   static Future<ProfileUpdateResponse> updateProfile({
//     required String bearerToken,
//     required ProfileUpdateRequest request,
//   }) async {
//     try {
//       final response = await DioClient.dio.post(
//         'https://gccltd.in/api/kyc/update-profile',
//         data: request.toJson(),
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         return ProfileUpdateResponse.fromJson(response.data);
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//         );
//       }
//     } on DioException catch (e) {
//       String errorMsg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
//       throw Exception(errorMsg);
//     }
//   }
// }
