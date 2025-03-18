import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';
import '../../constants/global.dart';
import '../../constants/const_colors.dart';
import 'dart:developer';

class OrderItemsRepo {
  final API api = API();
  final GetStorage box = GetStorage();

  /// Create a new order item
  Future<bool> createOrderItem({
    required int orderId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    try {
      // Retrieve the saved token from persistent storage
      String? token = box.read('token');
      if (token == null || token.isEmpty) {
        Fluttertoast.showToast(
          msg: "Token not found. Please log in again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return false;
      }

      // Prepare the request payload
      Map<String, dynamic> data = {
        "order": orderId,
        "product": productId,
        "quantity": quantity,
        "price": price.toStringAsFixed(2), // Format to 2 decimal places
      };

      // Add the token to the request headers
      Response response = await api.sendRequest.post(
        Global.orderiteam,
        data: data,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 201) {
        log("Order item created successfully: ${response.data}");
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to create order item. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return false;
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
      return false;
    }
  }
}