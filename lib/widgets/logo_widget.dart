import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:grocery/constants/custom_textsyle.dart';
import 'package:grocery/constants/const_colors.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Grocery App Logo
            Image.asset(
              'assets/logo.png', // Replace with your grocery app logo
              width: 0.2.sw, // Responsive width (20% of screen width)
              height: 0.2.sw, // Responsive height (same as width for square aspect ratio)
              fit: BoxFit.fitWidth,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Name
                Text(
                  "GroceryMart",
                  style: getTextTheme().headlineLarge?.copyWith(
                    fontSize: 24.sp, // Responsive font size
                  ),
                ),
                // Tagline
                Text(
                  "Fresh Groceries",
                  style: getTextTheme().headlineSmall?.copyWith(
                    fontSize: 16.sp, // Responsive font size
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 0.6.sw, // Responsive width (60% of screen width)
          child: Divider(
            color: ConstColors.shadowColor,
            height: 1.h, // Responsive height
          ),
        ),
      ],
    );
  }
}