import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showHelp;
  final bool showBackButton;
  final VoidCallback? onHelpTap;

  const CommonAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showHelp = true,
    this.showBackButton = true,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back Button (same as before)
            showBackButton
                ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.black87,
                      size: 22,
                    ),
                  ),
                )
                : const SizedBox(width: 38),

            const SizedBox(width: 12),

            // Title + Subtitle
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Help Button
            showHelp
                ? GestureDetector(
                  onTap: onHelpTap,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                )
                : const SizedBox(width: 38),
          ],
        ),
      ),
    );
  }
}
