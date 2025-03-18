import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';
import 'package:grocery/screens/sign_in_repo/profile_repo.dart';
import '../../constants/global.dart';
import '../../constants/const_colors.dart';

class OrderRepo {
  final API api = API();
  final GetStorage box = GetStorage();
  final ProfileRepo _profileRepo = ProfileRepo(); // Instance of ProfileRepo

  /// Fetch all orders for the authenticated user
  Future<Map<String, dynamic>> getOrders() async {
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
        return {};
      }

      // Add the token to the request headers
      Response response = await api.sendRequest.get(
        Global.order,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 200) {
        log("Orders fetched successfully: ${response.data}");
        return response.data as Map<String, dynamic>;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch orders. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return {};
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
      return {};
    }
  }

  /// Create a new order
  Future<Map<String, dynamic>?> createOrder({
    required int userId, // Add userId as a required parameter
    required int shopOwnerId,
    required double totalPrice,
    required List<Map<String, dynamic>> items,
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
        return null;
      }

      // Prepare the request payload
      Map<String, dynamic> data = {
        "user": userId, // Include the user ID in the payload
        "shop_owner": shopOwnerId, // Shop owner ID
        "total_price": totalPrice.toStringAsFixed(2), // Format to 2 decimal places
        "status": "pending", // Default status
        "items": items.map((item) => {
              "product_id": item['product_id'], // Extract product ID
              "quantity": item['quantity'], // Extract quantity
            }).toList(), // List of items in the order
      };

      log("Order payload: $data");

      // Add the token to the request headers
      Response response = await api.sendRequest.post(
        Global.order,
        data: data,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 201) {
        log("Order created successfully: ${response.data}");
        Fluttertoast.showToast(
          msg: "Order placed successfully!",
          backgroundColor: ConstColors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );

        // Return the entire response data
        return response.data as Map<String, dynamic>;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to place the order. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
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
      return null;
    }
  }
}