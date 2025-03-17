import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/models/category_model.dart'; // Import the CategoryModel
import 'package:grocery/models/productmodel.dart'; // Import the ProductModel
import 'package:grocery/common_repo.dart';
import 'package:grocery/constants/global.dart';
import 'package:grocery/constants/const_colors.dart';

class CategoryRepo {
  final API api = API();

  /// Fetch all categories from the API
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Make a GET request to the categories API
      Response response = await api.sendRequest.get(Global.category);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Log the response for debugging purposes
        log("Categories fetched successfully: ${response.data}");

        // Parse the response into a list of CategoryModel
        List<dynamic> rawCategories = response.data["results"];
        return rawCategories.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        // Show an error message if the request fails
        _showErrorToast("Failed to fetch categories. Please try again.");
        return [];
      }
    } on DioException catch (e) {
      // Handle errors
      _handleDioError(e);
      return [];
    }
  }

  /// Fetch products by category ID
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      // Make a GET request to the products by category API
      Response response = await api.sendRequest.get(
        "https://aspos.pythonanywhere.com/api/products/by-category/$categoryId/",
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Log the response for debugging purposes
        log("Products for category $categoryId fetched successfully: ${response.data}");

        // Parse the response into a list of ProductModel
        List<dynamic> rawProducts = response.data;
        return rawProducts.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        // Show an error message if the request fails
        _showErrorToast("Failed to fetch products for category $categoryId. Please try again.");
        return [];
      }
    } on DioException catch (e) {
      // Handle errors
      _handleDioError(e);
      return [];
    }
  }

  /// Handle Dio exceptions globally
  void _handleDioError(DioException e) {
    if (e.response != null &&
        e.response!.statusCode! >= 400 &&
        e.response!.statusCode! <= 500) {
      _showErrorToast(e.response!.data.toString());
    } else {
      _showErrorToast("An unexpected error occurred. Please try again.");
    }
  }

  /// Show an error toast message
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: ConstColors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}