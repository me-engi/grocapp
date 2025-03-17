import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/const_colors.dart';
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for persistent storage
  await GetStorage.init();

  // Lock the app orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size for mobile apps (iPhone 11 Pro)
      useInheritedMediaQuery: true, // Ensures proper keyboard behavior
      minTextAdapt: true, // Enables automatic text scaling
      splitScreenMode: true, // Handles split-screen scenarios on tablets
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: '/', // Initial route for the app
          title: 'Grocery App',
          defaultTransition: Transition.rightToLeft, // Smooth page transitions
          debugShowCheckedModeBanner: false,
          getPages: Routes.pages, // Define app routes
          theme: ThemeData(
            primaryColor: ConstColors.primaryColor,
            cardColor: ConstColors.backgroundColor,
            fontFamily: GoogleFonts.inter().fontFamily,
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ).apply(
              bodyColor: ConstColors.textColor, // Default text color
              displayColor: ConstColors.textColor, // Default display text color
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: ConstColors.primaryColor,
              brightness: Brightness.light, // Light theme
            ),
            useMaterial3: true, // Enable Material 3 design
            appBarTheme: AppBarTheme(
              color: ConstColors.backgroundColor,
              surfaceTintColor: ConstColors.backgroundColor,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: GoogleFonts.inter(
                fontSize: 20.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: ConstColors.primaryColor,
              ),
            ),
            scaffoldBackgroundColor: ConstColors.backgroundColor,
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(
                vertical: 14.h, // Responsive padding
                horizontal: 16.w, // Responsive padding
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Responsive radius
                borderSide: BorderSide(color: ConstColors.shadowColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Responsive radius
                borderSide: BorderSide(color: ConstColors.shadowColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Responsive radius
                borderSide: BorderSide(color: ConstColors.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Responsive radius
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Responsive radius
                borderSide: BorderSide(color: Colors.red),
              ),
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp, // Responsive font size
                color: ConstColors.textColor.withOpacity(0.6),
              ),
              labelStyle: GoogleFonts.inter(
                fontSize: 16.sp, // Responsive font size
                color: ConstColors.textColor,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r), // Responsive radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 14.h, // Responsive padding
                  horizontal: 20.w, // Responsive padding
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 16.sp, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: ConstColors.backgroundColor,
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r), // Responsive radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 14.h, // Responsive padding
                  horizontal: 20.w, // Responsive padding
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 16.sp, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: ConstColors.primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}