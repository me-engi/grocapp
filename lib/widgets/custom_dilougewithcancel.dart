import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery/constants/custom_textsyle.dart';


import '../constants/const_colors.dart';

// ignore: must_be_immutable, camel_case_types
class customDialogueWithCancel extends StatelessWidget {
  String? title;
  Color? backgroundColor;
  String? content;
  String? content1;
  String? content2;
  VoidCallback? onClick;
  String? dismissBtnTitle;
  String? cancelBtn;
  VoidCallback? onCancelClick;
  TextStyle? titleStyle;
  TextStyle? dismissBtnTitleStyle;
  TextStyle? cancelBtnStyle;
  Color? cancelBtnColor;
  // ignore: use_key_in_widget_constructors
  customDialogueWithCancel(
      {this.backgroundColor,
      this.content,
      this.content1,
      this.content2,
      this.dismissBtnTitle,
      this.onClick,
      this.titleStyle,
      this.dismissBtnTitleStyle,
      this.title,
      this.cancelBtnStyle,
      this.cancelBtn,
      this.onCancelClick,
      this.cancelBtnColor});
//child: Text(content)
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title: Text(
          title!,
          style: titleStyle ?? getTextTheme().headlineMedium,
        ),
        content: SizedBox(
          width: 1500.w,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                color: ConstColors.backgroundColor,
              ),
              children: <TextSpan>[
                TextSpan(text: content, style: getTextTheme().headlineSmall),
                TextSpan(text: content1, style: getTextTheme().headlineMedium),
                TextSpan(text: content2),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              return onClick!(); // dismisses only the dialog and returns nothing
            },
            child: Text(
              dismissBtnTitle!,
              style: dismissBtnTitleStyle ?? getTextTheme().displayLarge,
            ),
          ),
          TextButton(
            // color: cancelBtnColor,
            onPressed: () {
              return onCancelClick!(); // dismisses only the dialog and returns nothing
            },
            child: Text(
              cancelBtn!,
              style: cancelBtnStyle ?? getTextTheme().displayLarge,
            ),
          ),
        ],
      ),
    );
  }
}
