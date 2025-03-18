import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/screens/cartscreen/cartscreen.dart';
import 'package:grocery/screens/customerprofile/customerprofile.dart';
import 'package:grocery/screens/history/history.dart';
import 'package:grocery/screens/homepage/home_page.dart';
import 'package:grocery/screens/menu_drawer.dart';
import 'package:grocery/screens/notification.dart';
import 'package:grocery/widgets/custom_dilougewithcancel.dart';

class GroceryNavBar extends StatefulWidget {
  const GroceryNavBar({super.key});

  @override
  State<GroceryNavBar> createState() => _GroceryNavBarState();
}

class _GroceryNavBarState extends State<GroceryNavBar> {
  // GlobalKey for the scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Selected index for the bottom navigation bar
  int _selectedIndex = 0;

  // List of widgets for each tab
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Home Screen
    const OrderScreen(), // Favorites Screen
    const CartScreen(), // Cart Screen
    const CustomerProfileScreen(), // Profile Screen
  ];

  // Exit dialog for when the user presses the back button

  Future<bool> exitDialog() async {
    return await showDialog(
          barrierDismissible: true,
          barrierColor: ConstColors.textColor.withOpacity(0.1),
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: ConstColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    15.r,
                  ), // Responsive border radius
                ),
                title: Text(
                  "Hold on!",
                  style: TextStyle(
                    fontSize: 20.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: ConstColors.textColor,
                  ),
                ),
                content: Text(
                  "Are you sure you want to exit?",
                  style: TextStyle(
                    fontSize: 16.sp, // Responsive font size
                    fontWeight: FontWeight.w500,
                    color: ConstColors.textColor,
                  ),
                ),
                actions: [
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 16.sp, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF136F39),
                      ),
                    ),
                  ),
                  // Exit Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Confirm exit
                      exit(0); // Exit the app
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 16.sp, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: ConstColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitDialog,
      child: Scaffold(
        extendBody: true,
        key: scaffoldKey,
        backgroundColor: ConstColors.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: ConstColors.backgroundColor,
          backgroundColor: ConstColors.backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w), // Responsive padding
                child: IconButton(
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF136F39),
                    size: 28.sp, // Responsive icon size
                  ),
                ),
              ),
              Text(
                'FarmIn Grow',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp, // Responsive font size
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF136F39),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.w), // Responsive padding
                child: IconButton(
                  onPressed: () {
                    Get.to(() => NotificationScreen());
                  },
                  icon: Icon(
                    CupertinoIcons.bell,
                    color: Color(0xFF136F39),
                    size: 28.sp, // Responsive icon size
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        drawer: MenuDrawer(),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 15.w,
          ), // Responsive margin
          decoration: BoxDecoration(
            color: const Color(0xFF2C2F43),
            borderRadius: BorderRadius.circular(20.r), // Responsive radius
            boxShadow: [
              BoxShadow(
                blurRadius: 10.r, // Responsive blur radius
                color: Colors.black.withOpacity(.1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ), // Responsive padding
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8.w, // Responsive gap
                activeColor: ConstColors.backgroundColor,
                iconSize: 24.sp, // Responsive icon size
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 8.h,
                ), // Responsive padding
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: const Color(0xFF27A84A),
                color: const Color(0xFF83899E),
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(
                    icon: Icons.history, // Changed from favorite to history
                    text: 'History',
                  ),
                  GButton(icon: Icons.shopping_cart, text: 'Cart'),
                  GButton(icon: Icons.person, text: 'Profile'),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
