import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  final Function(PaymentSuccessResponse) onSuccess;
  final Function(PaymentFailureResponse) onError;
  final Function(ExternalWalletResponse) onExternalWallet;

  RazorpayService({
    required this.onSuccess,
    required this.onError,
    required this.onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      onSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      onError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      onExternalWallet,
    );
  }

  void openCheckout({
    required String key,
    required String orderId,
    required int amount,
    required String currency,
    required String name,
    required String email,
    required String contact,
  }) {
    var options = {
      "key": key,
      "order_id": orderId,
      "amount": amount,
      "currency": currency,
      "name": name,
      "description": "Buy GCC Units",
      "prefill": {
        "email": email,
        "contact": contact,
      }
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}