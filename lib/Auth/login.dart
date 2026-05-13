import 'package:flutter/material.dart';
import 'package:gcc/Auth/OTP_screen.dart';
import 'package:gcc/Auth/signup.dart';
import 'package:gcc/Navbar/navbar.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 1),
            // Welcome heading
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1B3B1F),
                    ),
                  ),
                  const Text(
                    'GCC',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 👇 Image add here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/tree.png',
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 100),
                      Text(
                        'Your contribution ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  Center(
                    child: Text(
                      'creates a better planet.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            // Mobile number input with country code
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    '+91',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Continue with OTP button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtpScreen(mobileNumber: ''),
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
                child: const Text(
                  'Continue with OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Continue with OTP button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 49, 4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // OR divider
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.grey.shade300, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or continue with',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.grey.shade300, thickness: 1),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Google & Apple buttons
            Row(
              children: [
                // Expanded(
                //   child: OutlinedButton.icon(
                //     onPressed: () {},
                //     icon: Image.asset(
                //       'assets/google_logo.png', // Replace with your asset or use Icon
                //       height: 20,
                //       width: 20,
                //     ),
                //     label: const Text('Google'),
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: const Color(0xFF1B3B1F),
                //       side: BorderSide(color: Colors.grey.shade300),
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(40),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.apple, size: 20),
                    label: const Text('Apple'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1B3B1F),
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
            // Footer text
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
    );
  }
}
