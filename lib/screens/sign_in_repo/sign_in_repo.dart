import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';
import 'package:grocery/constants/global.dart';
import '../../../constants/const_colors.dart';

class SignInRepo {
  API api = API();
  GetStorage box = GetStorage();

  Future<String> signInCall(String userName, String password) async {
    try {
      Response response = await api.sendRequest.post(
        Global.login,
        data: {"username": userName, "password": password},
      );

      if (response.statusCode == 200) {
        // Save the token and user ID to persistent storage
        box.write('token', response.data["token"]);
        log("Access token saved: ${response.data["token"]}");

        // Return success status
        return "true";
      }
      return "false";
    } on DioException catch (e) {
      // Handle errors
      if (e.response != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! <= 500) {
        Fluttertoast.showToast(
          msg: e.response!.data.toString(),
          backgroundColor: ConstColors.primaryColor,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: "An unexpected error occurred.",
          backgroundColor: ConstColors.primaryColor,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      return "false";
    }
  }
}