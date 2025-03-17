import 'package:get/get.dart';
import 'package:grocery/screens/cartscreen/cartscreen.dart';
import 'package:grocery/screens/customerprofile/customerprofile.dart';
import 'package:grocery/screens/history/history.dart';
import 'package:grocery/screens/homepage/home_page.dart';
import 'package:grocery/screens/sign_in.dart';
import 'package:grocery/screens/signupscreen.dart';
import 'package:grocery/screens/splash_screen.dart';
import 'package:grocery/utils/nav_bar.dart';


class Routes {
  // Define route names as constants for better readability and maintainability
  static const String splash = '/'; // Splash Screen
  static const String signIn = '/signin'; // Sign In Screen
  static const String signUp = '/signup'; // Sign Up Screen
  static const String navbar = '/navbar'; // Navigation Bar Screen
  static const String home = '/home'; // Home Screen
  static const String cart = '/cart'; // Cart Screen
  static const String history = '/history'; // Order History Screen
  static const String profile = '/profile'; // Customer Profile Screen

  // Define all app routes
  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: signIn, page: () => const SignIn()),
    GetPage(name: signUp, page: () => const SignUp()),
    GetPage(name: navbar, page: () => const GroceryNavBar()),
    GetPage(name: home, page: () => const Homepage()),
    GetPage(name: cart, page: () => const Cart()),
    GetPage(name: history, page: () => const History()),
    GetPage(name: profile, page: () => const Customerprofile()),
  ];
}