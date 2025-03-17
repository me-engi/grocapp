import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/common_repo.dart';
import 'package:grocery/models/productmodel.dart';


import '../../constants/global.dart';
import '../../constants/const_colors.dart';

class ProductRepo {
  final API api = API();

  /// Fetch all products from the API
  Future<List<ProductModel>> getAllProducts() async {
    try {
      Response response = await api.sendRequest.get(Global.productById);

      if (response.statusCode == 200) {
        log("Products fetched successfully: ${response.data}");
        List<dynamic> productList = response.data as List<dynamic>;
        return productList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch products. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return [];
      }
    } on DioException catch (e) {
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

  /// Fetch products filtered by category ID
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      Response response = await api.sendRequest.get(
        "${Global.productById}?category=$categoryId",
      );

      if (response.statusCode == 200) {
        log("Products for category $categoryId fetched successfully: ${response.data}");
        List<dynamic> productList = response.data as List<dynamic>;
        return productList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch products for category $categoryId. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return [];
      }
    } on DioException catch (e) {
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