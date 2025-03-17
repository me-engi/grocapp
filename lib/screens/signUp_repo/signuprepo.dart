import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';
import 'package:grocery/constants/global.dart';


import '../../../constants/const_colors.dart';


class SignUpRepo {
  API api = API();
  GetStorage box = GetStorage();

  /// Perform user registration
  Future<String> signUpCall({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    bool isShopOwner = false,
    bool isCustomer = true,
  }) async {
    try {
      // Make a POST request to the registration API
      Response response = await api.sendRequest.post(
        Global.register, // Endpoint for user registration
        data: {
          "username": username,
          "email": email,
          "password": password,
          "first_name": firstName,
          "last_name": lastName,
          "is_shop_owner": isShopOwner,
          "is_customer": isCustomer,
        },
      );

      // Check if the registration was successful
      if (response.statusCode == 201) {
        // Save the token and user ID to persistent storage
        await box.write('token', response.data["id"]); // Assuming "id" is returned
        log("User registered successfully. User ID: ${response.data["id"]}");
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
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: "An unexpected error occurred. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      return "false";
    }
  }
}