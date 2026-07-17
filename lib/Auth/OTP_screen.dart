import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcc/Auth/login.dart';
import 'package:gcc/Auth/signup.dart';
import 'package:gcc/Models_nServices/resend_otp_login/resend_otp_svc.dart'; // new
import 'package:gcc/Models_nServices/signup_resend_otp/signup_resend_otp_svc.dart';
import 'package:gcc/Models_nServices/verify_otp/verify_services.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String sessionId;
  final bool isLoginFlow;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.sessionId,
    this.isLoginFlow = true,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String _sessionId;

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isVerifying = false;
  int _resendTimerSeconds = 30;
  bool _canResend = false;
  String? _errorMessage;

  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId;
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // ─── VERIFY OTP ──────────────────────────────────────────────────────────
  Future<void> _handleVerifyOtp() async {
    String otp = _otpControllers.map((e) => e.text).join();

    setState(() {
      _errorMessage = null;
    });

    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit OTP';
      });
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      setState(() {
        _errorMessage = 'OTP should contain only numbers';
      });
      return;
    }

    try {
      setState(() {
        _isVerifying = true;
      });

      final response =
          widget.isLoginFlow
              ? await verifyLoginOtp(sessionId: _sessionId, otp: otp)
              : await verifyOtp(sessionId: _sessionId, otp: otp);

      setState(() {
        _isVerifying = false;
      });

      if (response.status == true) {
        // Save user data
        if (response.token != null && response.token!.isNotEmpty) {
          await AppPreference().setString(
            PreferencesKey.authToken,
            response.token!,
          );
        }
        if (response.user?.name != null && response.user!.name!.isNotEmpty) {
          await AppPreference().setString(
            PreferencesKey.userName,
            response.user!.name!,
          );
        }
        if (response.user?.phone != null && response.user!.phone!.isNotEmpty) {
          await AppPreference().setString(
            PreferencesKey.userMobile,
            response.user!.phone!,
          );
        }
        if (response.user?.id != null && response.user!.id != 0) {
          await AppPreference().setInt(
            PreferencesKey.userId,
            response.user!.id!,
          );
        }
        await AppPreference().setBool(PreferencesKey.isLoggedIn, true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP Verified Successfully!'),
              backgroundColor: Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false,
          );
        }
      } else {
        setState(() {
          _errorMessage = response.message ?? "Invalid OTP. Please try again.";
        });
        _clearOtpFields();
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage =
            'Network error. Please check your connection and try again.';
      });
      debugPrint('OTP Verification Error: $e');
      _clearOtpFields();
    }
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  // ─── RESEND OTP ──────────────────────────────────────────────────────────
  Future<void> _handleResendOtp() async {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      // Choose the correct resend service based on flow
      final response =
          widget.isLoginFlow
              ? await ResendOtpService().resendOtp(_sessionId)
              : await ResendOtpSignupService().resendOtpSignup(_sessionId);

      setState(() {
        _isVerifying = false;
      });

      if (response.status == true) {
        // Update session ID
        setState(() {
          _sessionId = response.sessionId;
        });

        // Reset the timer
        _startResendTimer();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP resent successfully!'),
              backgroundColor: Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }

        _clearOtpFields();
      } else {
        setState(() {
          _canResend = true;
          _errorMessage =
              response.message.isNotEmpty
                  ? response.message
                  : 'Failed to resend OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _canResend = true;
        _errorMessage = 'Network error. Please check your connection.';
      });
      debugPrint('Resend OTP Error: $e');
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _canResend = false;
    _resendTimerSeconds = 30;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendTimerSeconds > 0) {
          _resendTimerSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // ─── BUILD ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Images/tree.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.eco,
                              size: 24,
                              color: Color(0xFF2E7D32),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'GCC',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verify Your Number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B3B1F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter the 6-digit code sent to\n${_formatMobileNumber(widget.mobileNumber)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _buildOtpTextField(index, screenWidth);
                }),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child:
                      _isVerifying
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Verify & Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: _handleResendOtp,
                    child: Text(
                      _canResend
                          ? 'Resend'
                          : 'Resend in ${_resendTimerSeconds}s',
                      style: TextStyle(
                        color:
                            _canResend
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  if (widget.isLoginFlow) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MobileLoginScreen(),
                      ),
                    );
                  } else {
                    print("Edit clicked");
                    print("Can Pop: ${Navigator.canPop(context)}");

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Edit Mobile Number',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        'Secure · Transparent · Trusted',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OTP valid for 5 minutes',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────
  Widget _buildOtpTextField(int index, double screenWidth) {
    double boxSize = (screenWidth - 48 - 40) / 6;
    if (boxSize > 56) boxSize = 56;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _errorMessage != null ? Colors.red : Colors.green.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.green.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade400),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        onChanged: (value) {
          if (_errorMessage != null) {
            setState(() {
              _errorMessage = null;
            });
          }

          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (index == 5 && _otpControllers.every((c) => c.text.isNotEmpty)) {
            _handleVerifyOtp();
          }
        },
      ),
    );
  }

  String _formatMobileNumber(String mobile) {
    if (mobile.length == 10) {
      return '+91 ${mobile.substring(0, 5)} ${mobile.substring(5)}';
    }
    return mobile;
  }
}
