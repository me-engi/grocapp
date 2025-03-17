import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';

import '../../constants/global.dart';
import '../../constants/const_colors.dart';

class CategoryRepo {
  final API api = API();
  final GetStorage box = GetStorage();

  /// Fetch all categories from the API
  Future<List<dynamic>> getCategories() async {
    try {
      // Make a GET request to the categories API
      Response response = await api.sendRequest.get(Global.category);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Log the response for debugging purposes
        log("Categories fetched successfully: ${response.data}");

        // Return the list of categories
        return response.data as List<dynamic>;
      } else {
        // Show an error message if the request fails
        Fluttertoast.showToast(
          msg: "Failed to fetch categories. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return [];
      }
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
      return [];
    }
  }
}