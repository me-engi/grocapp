import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:grocery/constants/custom_textsyle.dart';
import '../../constants/const_colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ConstColors.textColor,
            size: 24.sp, // Responsive icon size
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "About Us",
          style: getTextTheme().headlineMedium?.copyWith(
            fontSize: 20.sp, // Responsive font size
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to GroceryMart',
                style: getTextTheme().headlineLarge?.copyWith(
                  fontSize: 24.sp, // Responsive font size
                ),
              ),
              Gap(10.h), // Responsive gap
              Text(
                'GroceryMart is your ultimate destination for fresh groceries delivered to your doorstep. We believe in providing high-quality, fresh produce and household essentials at your convenience.',
                style: getTextTheme().headlineSmall?.copyWith(
                  fontSize: 16.sp, // Responsive font size
                ),
              ),
              Gap(30.h), // Responsive gap
              Row(
                children: [
                  Text(
                    'Our Team',
                    style: getTextTheme().headlineMedium?.copyWith(
                      fontSize: 20.sp, // Responsive font size
                    ),
                  ),
                ],
              ),
              Gap(20.h), // Responsive gap
              Text(
                'GroceryMart is powered by a passionate team of professionals dedicated to delivering exceptional service. Our team works tirelessly to ensure you receive the freshest products and the best shopping experience.',
                style: getTextTheme().headlineSmall?.copyWith(
                  fontSize: 16.sp, // Responsive font size
                ),
              ),
              Gap(30.h), // Responsive gap
              Text(
                'Mission',
                style: getTextTheme().headlineMedium?.copyWith(
                  fontSize: 20.sp, // Responsive font size
                ),
              ),
              Gap(20.h), // Responsive gap
              Text(
                'Our mission is to provide convenient access to fresh groceries and household essentials, ensuring quality and reliability for every customer.',
                style: getTextTheme().headlineSmall?.copyWith(
                  fontSize: 16.sp, // Responsive font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}