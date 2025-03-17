import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'const_colors.dart';

TextTheme getTextTheme() {
  return TextTheme(
    headlineLarge: GoogleFonts.judson(
      fontWeight: FontWeight.w700,
      color: ConstColors.textColor,
      fontSize: 128.sp,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      color: ConstColors.textColor,
      fontSize: 63.sp,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.w400,
      color: ConstColors.textColor,
      fontSize: 63.sp,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.w400,
      color: ConstColors.textColor,
      fontSize: 48.sp,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      color: ConstColors.textColor,
      fontSize: 48.sp,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.w400,
      color: ConstColors.textColor,
      fontSize: 53.sp,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.w700,
      color: ConstColors.backgroundColor,
      fontSize: 75.sp,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      color: ConstColors.backgroundColor,
      fontSize: 64.sp,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.normal,
      color: ConstColors.backgroundColor,
      fontSize: 53.sp,
    ),
    displayLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.w500,
      color: ConstColors.backgroundColor,
      fontSize: 69.sp,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      color: ConstColors.shadowColor,
      fontSize: 63.sp,
    ),
    displaySmall: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 64.sp,
        color: ConstColors.textblue,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.textblue),
  );
}
