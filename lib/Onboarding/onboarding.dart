import 'package:flutter/material.dart';
import 'package:gcc/Auth/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive image container size
    final imageContainerSize = (screenWidth * 0.45).clamp(140.0, 220.0);
    // Responsive font sizes
    final headingFontSize = screenWidth * 0.08;
    final subtitleFontSize = screenWidth * 0.04;
    final buttonFontSize = screenWidth * 0.045;
    final spacing = screenHeight * 0.025;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: screenHeight * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rounded container with image fill
              Container(
                width: imageContainerSize,
                height: imageContainerSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/Images/tree.png',
                    width: imageContainerSize,
                    height: imageContainerSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: spacing * 1.5),

              // Main heading with better styling
              Text(
                'Grow a Greener\nTomorrow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B3B1F),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: spacing * 0.8),

              // Subtitle with better spacing
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: Text(
                  'Buy GCC Units, create real environmental impact and earn exciting eco-rewards.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey.shade600,
                    height: 1.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              SizedBox(height: spacing * 2.5),

              // Get Started Button with gradient effect
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
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
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: spacing),

              // Optional: Small hint text
              Text(
                'Join the green revolution today',
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
