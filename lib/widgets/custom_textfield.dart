import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:grocery/constants/custom_textsyle.dart';
import '../../constants/const_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String customText;
  final TextEditingController controller;
  final TextInputType? keyoardType;
  final String? Function(String?)? validator;
  final Function(String) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool obsercureText;
  final int minline;
  final int maxline;
  final Widget iconss;

  const CustomTextFormField({
    super.key,
    required this.customText,
    required this.controller,
    required this.validator,
    required this.inputFormatters,
    this.readOnly = false,
    this.obsercureText = false,
    this.minline = 1,
    this.maxline = 1,
    this.iconss = const SizedBox(),
    required this.onChanged,
    this.keyoardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsercureText,
      inputFormatters: inputFormatters,
      keyboardType: keyoardType ?? TextInputType.emailAddress,
      readOnly: readOnly,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: getTextTheme().headlineMedium?.copyWith(
        fontSize: 16.sp, // Responsive font size
      ),
      cursorColor: Colors.black,
      maxLines: maxline,
      minLines: minline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        label: Text(
          customText,
          style: getTextTheme().displayMedium?.copyWith(
            fontSize: 14.sp, // Responsive font size
          ),
        ),
        suffixIcon: iconss,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(255, 179, 179, 179),
          fontSize: 14.sp, // Responsive font size
        ),
        errorStyle: TextStyle(
          height: 0,
          color: Color.fromARGB(255, 244, 62, 1),
          fontSize: 12.sp, // Responsive font size
        ),
        filled: true,
        fillColor: ConstColors.backgroundColor.withOpacity(.7),
        contentPadding: EdgeInsets.symmetric(
          vertical: 15.h, // Responsive padding
          horizontal: 16.w, // Responsive padding
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ), // Responsive radius
          borderSide: BorderSide(
            width: 0.6.w, // Responsive border width
            color: Color(0xFF136F39),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ), // Responsive radius
          borderSide: BorderSide(
            width: 0.6.w, // Responsive border width
            color: Color(0xFF136F39),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ), // Responsive radius
          borderSide: BorderSide(
            width: 0.6.w, // Responsive border width
            color: Color(0xFF136F39),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ), // Responsive radius
          borderSide: BorderSide(
            width: 0.6.w, // Responsive border width
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ), // Responsive radius
          borderSide: BorderSide(
            width: 0.6.w, // Responsive border width
            color: Color(0xFF136F39),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ), // Responsive radius
          borderSide: BorderSide(
            width: 0.6.w, // Responsive border width
            color: Color(0xFF136F39),
          ),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
