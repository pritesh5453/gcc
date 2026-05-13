import 'package:flutter/material.dart';
import 'package:gcc/Navbar/navbar.dart'; // Adjust path as needed

class OtpScreen extends StatefulWidget {
  final String mobileNumber; // Pass the mobile number from login screen

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isVerifying = false;
  int _resendTimerSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimerSeconds = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendTimerSeconds > 0) {
          _resendTimerSeconds--;
        } else {
          _canResend = true;
        }
      });
      return _resendTimerSeconds > 0;
    });
  }

  void _handleVerifyOtp() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit OTP'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVerifying = false;
      });
      // For demo, accept any 6-digit OTP (e.g., 123456)
      if (otp == '123456') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verified! Redirecting...'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Navigate to main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Clear OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _handleResendOtp() {
    if (!_canResend) return;

    setState(() {
      _startResendTimer();
    });

    // Simulate resend API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully!'),
        backgroundColor: Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              // Header with tree icon (matching login/signup)
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/tree.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
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
                      'Enter the 6-digit code sent to\n${widget.mobileNumber}',
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
              // OTP Input Fields (6 boxes)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _buildOtpTextField(index, screenWidth);
                }),
              ),
              const SizedBox(height: 32),
              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
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
              // Resend row
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
              // Edit number link
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to login screen
                },
                child: Text(
                  'Edit Mobile Number',
                  style: TextStyle(
                    color: const Color(0xFF2E7D32),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              // Footer (same as other screens)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Secure · Transparent · Trusted',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(int index, double screenWidth) {
    // Responsive box size
    double boxSize =
        (screenWidth - 48 - 40) / 6; // 48 = horizontal padding, 40 = spacing
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
            borderSide: BorderSide(color: Colors.green),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          // Auto-submit when all 6 digits are filled
          if (index == 5 && _otpControllers.every((c) => c.text.isNotEmpty)) {
            _handleVerifyOtp();
          }
        },
      ),
    );
  }
}
