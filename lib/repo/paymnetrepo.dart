import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';
import '../../constants/global.dart';
import '../../constants/const_colors.dart';
import 'dart:developer';

class PaymentsRepo {
  final API api = API();
  final GetStorage box = GetStorage();

  /// Create a new payment
  Future<bool> createPayment({
    required int orderId,
    required double amount,
    required String paymentMethod,
    required String status,
  }) async {
    try {
      // Validate the orderId
      if (orderId <= 0) {
        Fluttertoast.showToast(
          msg: "Invalid order ID. Please try again.",
          backgroundColor: ConstColors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return false;
      }

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
        "amount": amount.toStringAsFixed(2), // Format to 2 decimal places
        "payment_method": paymentMethod,
        "status": status,
      };

      // Log the payload for debugging
      log("Payment payload: $data");

      // Add the token to the request headers
      Response response = await api.sendRequest.post(
        Global.payments,
        data: data,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 201) {
        log("Payment created successfully: ${response.data}");
        Fluttertoast.showToast(
          msg: "Payment created successfully!",
          backgroundColor: ConstColors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to create payment. Please try again.",
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