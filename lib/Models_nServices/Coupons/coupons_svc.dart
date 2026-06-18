import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/Coupons/coupons_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class CouponService {
  // ---------- Fetch all coupons ----------
  Future<CouponsResponse?> getCoupons({required String token}) async {
    try {
      print('🔍 Fetching coupons with token: $token');
      final response = await DioClient.dio.get(
        ApiEndpoints.coupons,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      
      print('✅ Coupons API status code: ${response.statusCode}');
      print('📦 Raw response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final parsed = CouponsResponse.fromJson(response.data);
        print('✅ Parsed successfully. Reward points: ${parsed.rewardPoints}, coupons count: ${parsed.data.length}');
        for (var c in parsed.data) {
          print('   Coupon: id=${c.id}, name=${c.couponName}, isScratch=${c.isScratch}, isEligible=${c.isEligible}');
        }
        return parsed;
      }
      print('❌ Non-200 status: ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      return null;
    } catch (e) {
      print('❌ Unexpected Error: $e');
      return null;
    }
  }

  // ---------- Scratch a coupon ----------
  Future<ScratchCouponResponse?> scratchCoupon({
    required String token,
    required int couponId,
  }) async {
    try {
      print('🔍 Scratching coupon ID: $couponId');
      final response = await DioClient.dio.post(
        ApiEndpoints.scratchCoupon,
        data: {"coupon_id": couponId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      
      print('✅ Scratch API status code: ${response.statusCode}');
      print('📦 Scratch response: ${response.data}');
      
      if (response.statusCode == 200) {
        return ScratchCouponResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('❌ Scratch DioException: ${e.response?.data}');
      return null;
    } catch (e) {
      print('❌ Scratch Unexpected Error: $e');
      return null;
    }
  }
}