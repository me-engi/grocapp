import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:get/get.dart';
import 'package:grocery/constants/custom_textsyle.dart';
import 'package:grocery/screens/signUp_repo/signuprepo.dart';
import '../../constants/const_colors.dart';
import '../../widgets/custom_textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers for form fields
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Observables for UI states
  RxBool passwordVisibility = true.obs;
  RxBool isLoading = false.obs;

  /// Handle user registration
  void handleSignUp() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Show loading indicator
      try {
        // Call the SignUpRepo to perform the registration
        SignUpRepo signUpRepo = SignUpRepo();
        String result = await signUpRepo.signUpCall(
          username: username.text.trim(),
          email: email.text.trim(),
          password: password.text.trim(),
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          isShopOwner: false,
          isCustomer: true,
        );
        if (result == "true") {
          // Navigate to the home screen on successful registration
          Get.offAllNamed('/signin');
        } else {
          // Show an error message if registration fails
          Get.snackbar(
            "Error",
            "Registration failed. Please try again.",
            backgroundColor: Color(0xFF136F39),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        log("Registration Error: $e");
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
    return Scaffold(
      body: Stack(
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
                      top: 0.1.sh, // Use screen height percentage
                      bottom: 0.05.sh, // Use screen height percentage
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
                          // Logo and App Name
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Grocery App Logo
                                  Image.asset(
                                    'assets/logo.png', // Replace with your grocery app logo
                                    width:
                                        0.6.sw, // Responsive width (20% of screen width)
                                    height:
                                        0.3.sw, // Responsive height (same as width for square aspect ratio)
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 0.6.sw, // Use screen width percentage
                                child: Divider(
                                  color: Color(0xFF136F39),
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
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
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                            ],
                            onChanged: (String value) {
                              log("Username changed: $value");
                            },
                          ),
                          SizedBox(
                            height: 0.03.sh,
                          ), // Use screen height percentage
                          // Email Field
                          CustomTextFormField(
                            customText: "Email",
                            controller: email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            onChanged: (String value) {
                              log("Email changed: $value");
                            },
                          ),
                          SizedBox(
                            height: 0.03.sh,
                          ), // Use screen height percentage
                          // First Name Field
                          CustomTextFormField(
                            customText: "First Name",
                            controller: firstName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]'),
                              ),
                            ],
                            onChanged: (String value) {
                              log("First Name changed: $value");
                            },
                          ),
                          SizedBox(
                            height: 0.03.sh,
                          ), // Use screen height percentage
                          // Last Name Field
                          CustomTextFormField(
                            customText: "Last Name",
                            controller: lastName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]'),
                              ),
                            ],
                            onChanged: (String value) {
                              log("Last Name changed: $value");
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
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'.*'),
                                ),
                              ],
                              onChanged: (String value) {
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
                          // Sign Up Button
                          InkWell(
                            onTap: handleSignUp,
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
                                            color: ConstColors.backgroundColor,
                                          )
                                          : Text(
                                            "Sign Up",
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
                          // Already Have an Account? Sign In
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: getTextTheme().headlineSmall?.copyWith(
                                  fontSize: 14.sp, // Use responsive font size
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Sign In",
                                  style: getTextTheme().displaySmall?.copyWith(
                                    fontSize: 14.sp, // Use responsive font size
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
    );
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
