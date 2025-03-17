import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/custom_textsyle.dart';
import '../../constants/const_colors.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
          "Contact Us",
          style: getTextTheme().headlineMedium?.copyWith(
            fontSize: 20.sp, // Responsive font size
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For inquiries, feedback, or support, feel free to reach out to us at:',
                style: getTextTheme().headlineMedium?.copyWith(
                  fontSize: 18.sp, // Responsive font size
                ),
              ),
              Gap(10.h), // Responsive gap
              Row(
                children: [
                  Text(
                    'Email -',
                    style: getTextTheme().headlineMedium?.copyWith(
                      fontSize: 16.sp, // Responsive font size
                    ),
                  ),
                  Gap(10.w), // Responsive gap
                  InkWell(
                    onTap: () {
                      openMail('support@grocerymart.com');
                    },
                    child: Text(
                      'support@grocerymart.com',
                      style: getTextTheme().displaySmall?.copyWith(
                        fontSize: 16.sp, // Responsive font size
                      ),
                    ),
                  ),
                ],
              ),
              Gap(10.h), // Responsive gap
              Row(
                children: [
                  Text(
                    'Phone No. -',
                    style: getTextTheme().headlineMedium?.copyWith(
                      fontSize: 16.sp, // Responsive font size
                    ),
                  ),
                  Gap(10.w), // Responsive gap
                  InkWell(
                    onTap: () {
                      openDialPad('+91-1234567890');
                    },
                    child: Text(
                      '+91-1234567890',
                      style: getTextTheme().displaySmall?.copyWith(
                        fontSize: 16.sp, // Responsive font size
                      ),
                    ),
                  ),
                ],
              ),
              Gap(30.h), // Responsive gap
              Text(
                'Address - 123, Grocery Lane, New Delhi, India.\n\nStay connected with us on social media for the latest updates and promotions:',
                style: getTextTheme().headlineSmall?.copyWith(
                  fontSize: 14.sp, // Responsive font size
                ),
              ),
              Gap(20.h), // Responsive gap
              Text(
                'GroceryMart is powered by a passionate team of professionals dedicated to bringing you the freshest groceries and household essentials. Our team works tirelessly to ensure you receive the best shopping experience.',
                style: getTextTheme().headlineSmall?.copyWith(
                  fontSize: 14.sp, // Responsive font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Open Dial Pad for Phone Number
  void openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      log("Can't open dial pad.");
    }
  }

  /// Open Mail App for Email
  void openMail(String mail) async {
    Uri url = Uri(scheme: "mailto", path: mail);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      log("Can't open mail app.");
    }
  }
}