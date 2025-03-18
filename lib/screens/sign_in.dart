import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:get/get.dart';
import 'package:grocery/screens/sign_in_repo/sign_in_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/custom_textsyle.dart';
import '../../constants/const_colors.dart';
import '../../constants/global.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/logo_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Controllers for username and password
  final username = TextEditingController();
  final password = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Observables for UI states
  RxBool passwordVisibility = true.obs;
  RxBool isLoading = false.obs;

  /// Handle user login
  void handleLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Show loading indicator
      try {
        // Call the SignInRepo to perform the login
        SignInRepo signInRepo = SignInRepo();
        String result = await signInRepo.signInCall(
          username.text.trim(),
          password.text.trim(),
        );
        if (result == "true") {
          // Navigate to the home screen on successful login
          Get.offAllNamed('/navbar');
        } else {
          // Show an error message if login fails
          Get.snackbar(
            "Error",
            "Invalid username or password",
            backgroundColor: Color(0xFF136F39),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        log("Login Error: $e");
        Get.snackbar(
          "Error",
          "An unexpected error occurred. Please try again.",
          backgroundColor: Color(0xFF136F39),
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false; // Hide loading indicator
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive design
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Gradient
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                height: 0.5.sh, // Use screen height percentage
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF27A84A), Color(0xFF136F39)],
                  ),
                ),
              ),
            ),
            // Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 0.2.sh, // Use screen height percentage
                        bottom: 0.1.sh, // Use screen height percentage
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.08.sw, // Use screen width percentage
                      ),
                      width: 0.9.sw, // Use screen width percentage
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: ConstColors.shadowColor,
                            blurRadius: 4,
                            offset: Offset(1, 5),
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                          40.r,
                        ), // Use responsive radius
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo Widget
                            const LogoWidget(),
                            SizedBox(
                              height: 0.05.sh,
                            ), // Use screen height percentage
                            // Username Field
                            CustomTextFormField(
                              customText: "Username",
                              controller: username,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                if (value.length < 3) {
                                  return 'Username must be at least 3 characters long';
                                }
                                return null;
                              },
                              inputFormatters: [
                                // Allow only alphanumeric characters
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                ),
                              ],
                              onChanged: (String value) {
                                // Log or handle username changes
                                log("Username changed: $value");
                              },
                            ),
                            SizedBox(
                              height: 0.03.sh,
                            ), // Use screen height percentage
                            // Password Field
                            Obx(
                              () => CustomTextFormField(
                                obsercureText: passwordVisibility.value,
                                customText: "Password",
                                controller: password,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  // Allow all characters for password
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'.*'),
                                  ),
                                ],
                                onChanged: (String value) {
                                  // Log or handle password changes
                                  log("Password changed: $value");
                                },
                                iconss:
                                    passwordVisibility.value
                                        ? IconButton(
                                          onPressed: () {
                                            passwordVisibility.value = false;
                                          },
                                          icon: Icon(
                                            Icons.visibility_off,
                                            color: Color(0xFF136F39),
                                            size:
                                                24.sp, // Use responsive font size
                                          ),
                                        )
                                        : IconButton(
                                          onPressed: () {
                                            passwordVisibility.value = true;
                                          },
                                          icon: Icon(
                                            Icons.visibility,
                                            color: Color(0xFF136F39),
                                            size:
                                                24.sp, // Use responsive font size
                                          ),
                                        ),
                              ),
                            ),
                            SizedBox(
                              height: 0.02.sh,
                            ), // Use screen height percentage
                            // Forgot Password Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => urlLaunch(Global.forgotPassword),
                                  child: Text(
                                    'Forgot password?',
                                    style: getTextTheme().displaySmall
                                        ?.copyWith(
                                          fontSize:
                                              14.sp, // Use responsive font size
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.02.sh,
                            ), // Use screen height percentage
                            // Sign In Button
                            InkWell(
                              onTap: handleLogin,
                              child: Container(
                                height: 50.h, // Use responsive height
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10.r,
                                  ), // Use responsive radius
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF27A84A),
                                      Color(0xFF136F39),
                                    ],
                                  ),
                                ),
                                child: Obx(
                                  () => Center(
                                    child:
                                        isLoading.value
                                            ? const CircularProgressIndicator(
                                              color:
                                                  ConstColors.backgroundColor,
                                            )
                                            : Text(
                                              "Sign In",
                                              style: getTextTheme().titleMedium
                                                  ?.copyWith(
                                                    fontSize:
                                                        16.sp, // Use responsive font size
                                                  ),
                                            ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0.02.sh,
                            ), // Use screen height percentage
                            // Divider with text
                            // const Row(
                            //   children: [
                            //     Expanded(
                            //       child: Divider(
                            //         color: ConstColors.shadowColor,
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: EdgeInsets.all(8.0),
                            //       child: Text('or sign up with'),
                            //     ),
                            //     Expanded(
                            //       child: Divider(
                            //         color: ConstColors.shadowColor,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 0.02.sh), // Use screen height percentage
                            // Sign Up Button
                            // OutlinedButton(
                            //   onPressed: () {
                            //     Get.toNamed('/signup');
                            //   },
                            //   style: OutlinedButton.styleFrom(
                            //     side:
                            //         BorderSide(color: ConstColors.primaryColor),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.r), // Use responsive radius
                            //     ),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //           vertical: 10.0,
                            //           horizontal: 20,
                            //         ),
                            //         child: Image.asset(
                            //           'assets/google 1.png',
                            //           height: 35.h, // Use responsive height
                            //         ),
                            //       ),
                            //       Text(
                            //         'Sign Up',
                            //         style: getTextTheme()
                            //             .headlineMedium
                            //             ?.copyWith(
                            //               fontSize: 14.sp, // Use responsive font size
                            //             ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 0.05.sh,
                            ), // Use screen height percentage
                            // Don't have an account? Sign Up
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don’t have an account? ",
                                  style: getTextTheme().headlineSmall?.copyWith(
                                    fontSize: 14.sp, // Use responsive font size
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/signup');
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: getTextTheme().displaySmall
                                        ?.copyWith(
                                          fontSize:
                                              14.sp, // Use responsive font size
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.05.sh,
                            ), // Use screen height percentage
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Launch URL for Forgot Password
  static Future<void> urlLaunch(String urlunch) async {
    String url = urlunch;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch URL: $url');
    }
  }
}

/// Custom Clipper for Background Gradient
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);
    Path path =
        Path()
          ..lineTo(0, size.height - curveHeight)
          ..quadraticBezierTo(
            controlPoint.dx,
            controlPoint.dy,
            endPoint.dx,
            endPoint.dy,
          )
          ..lineTo(size.width, 0)
          ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
