import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/screens/about_us.dart';
import 'package:grocery/screens/contactus.dart';
import 'package:grocery/widgets/logo_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart'; // Import the logger package

// Initialize a logger instance
final logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Number of method calls to show (set to 0 for cleaner output)
    errorMethodCount: 5, // Number of method calls to show for errors
    lineLength: 50, // Line length for logs
    colors: true, // Enable colored logs
    printEmojis: true, // Enable emojis for log levels
    printTime: false, // Show timestamp in logs
  ),
);

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.8.sw, // Responsive width (80% of screen width)
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Widget
              const LogoWidget(),
              SizedBox(height: 20.h), // Responsive spacing
              // Divider Line
              Container(
                width: double.infinity,
                height: 1.h,
                color: ConstColors.shadowColor,
                margin: EdgeInsets.symmetric(vertical: 15.h),
              ),

              // Main Menu Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Home Option
                      menuOption("Home", Icons.home, () {
                        Navigator.of(context).pop();
                      }),

                      // Become a Travel Guide
                      menuOption(
                        "Delivery",
                        Icons.hiking_rounded,
                        () => showInfo(
                          context,
                          "Become a Delivery Boy",
                          "Do you love being on the move and have a passion for quick and efficient deliveries? Become a Grocery Delivery Partner! Join our team to help customers receive fresh groceries right at their doorstep.\n\nInstructions:\nTo apply, please send your resume to",
                          "grocery@growapp.com",
                        ),
                      ),

                      // Become an Affiliate Partner
                      menuOption(
                        "Become a Vendor",
                        Icons.handshake,
                        () => showInfo(
                          context,
                          "Become a Vendor",
                          "Partner with us and sell your grocery products on our platform. Reach thousands of customers daily!",
                          "vendors@groceryapp.com",
                        ),
                      ),

                      // About Us
                      menuOption("About Us", Icons.info, () {
                        Get.to(() => const AboutUs());
                      }),

                      // Contact Us
                      menuOption("Contact Us", Icons.phone_in_talk, () {
                        Get.to(() => const ContactUs());
                      }),

                      // Join Us
                      menuOption(
                        "Join Us",
                        Icons.group_rounded,
                        () => showInfo(
                          context,
                          "Join Us",
                          "Embark on an unforgettable adventure with Ghumneyho. Whether you're a seasoned trekker or a first-time explorer, we have something for everyone. Browse our tours, book your next adventure, and discover the magic of the Himalayas with us.",
                          "grocery@growapp.com",
                        ),
                      ),

                      // Social Media Links
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialMediaIcon(
                              'assets/Facebook.png',
                              'https://www.facebook.com/profile.php?id=61554850642634',
                            ),
                            SizedBox(width: 20.w),
                            socialMediaIcon(
                              'assets/Instagram.png',
                              'https://www.instagram.com/g_humnaho/',
                            ),
                            SizedBox(width: 20.w),
                            socialMediaIcon(
                              'assets/Twitter.png',
                              'twitter.com/ghumneyho',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: ConstColors.shadowColor,
                      blurRadius: 6.r,
                      offset: Offset(1.w, 6.h),
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(color: Colors.black.withOpacity(.2)),
                ),
                child: Column(
                  children: [
                    footerItem(
                      "assets/IndianFlag.png",
                      "Country/Region",
                      "India",
                    ),
                    SizedBox(height: 10.h),
                    footerItem(
                      "assets/blankrectangle.png",
                      "App Version",
                      "1.0.0",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menu Option Widget
  Widget menuOption(String title, IconData icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Row(
          children: [
            Icon(icon, color: ConstColors.primaryColor, size: 24.sp),
            SizedBox(width: 15.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: ConstColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Social Media Icon Widget
  Widget socialMediaIcon(String assetPath, String url) {
    return InkWell(
      onTap: () => urlLaunch(url),
      child: Image.asset(
        assetPath,
        height: 40.h,
        width: 40.w,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Footer Item Widget
  Widget footerItem(String image, String title, String subtitle) {
    return Row(
      children: [
        Image.asset(image, height: 30.h, width: 30.w, fit: BoxFit.contain),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ConstColors.textColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: ConstColors.textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Show Information Dialog
  Future<void> showInfo(
    BuildContext context,
    String title,
    String content,
    String email,
  ) {
    return showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: ConstColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ConstColors.textColor,
                  ),
                ),
                SizedBox(height: 10.h),
                TextButton(
                  onPressed: () => openMail(email),
                  child: Text(
                    email,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// Launch URL
  static Future<void> urlLaunch(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        logger.e('Could not launch URL: $url'); // Use logger for error logging
      }
    } catch (e) {
      logger.e('Error while launching URL: $url, Exception: $e');
    }
  }

  /// Open Mail App
  void openMail(String mail) async {
    final Uri emailUri = Uri(scheme: "mailto", path: mail);
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        logger.e("Can't open mail app."); // Use logger for error logging
      }
    } catch (e) {
      logger.e('Error while opening mail app: $mail, Exception: $e');
    }
  }
}
