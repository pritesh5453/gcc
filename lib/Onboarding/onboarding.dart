import 'package:flutter/material.dart';
import 'package:gcc/Auth/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive image size (max 40% of screen width or 30% of screen height)
    final imageSize = (screenWidth * 0.8).clamp(150.0, screenWidth * 0.9);
    // Responsive font sizes
    final headingFontSize = screenWidth * 0.08; // ~36 on 450 width
    final subtitleFontSize = screenWidth * 0.04; // ~16 on 400 width
    final buttonFontSize = screenWidth * 0.045;
    final spacing = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, // ~24 on 400 width
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom image with responsive size
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.03,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/tree.png',
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: spacing),

              // Main heading
              Text(
                'Grow a Greener\nTomorrow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B3B1F),
                  height: 1.2,
                ),
              ),
              SizedBox(height: spacing * 0.8),

              // Subtitle
              Text(
                'Buy GCC Units, create real environmental impact and earn exciting eco-rewards.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              SizedBox(height: spacing * 2),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileLoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
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
}
