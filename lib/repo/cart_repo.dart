import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';

import '../../constants/global.dart';
import '../../constants/const_colors.dart';

class CartRepo {
  final API api = API();
  final GetStorage box = GetStorage();

  /// Fetch all items in the cart for the authenticated user
  Future<List<dynamic>> getCartItems() async {
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
        return [];
      }

      // Add the token to the request headers
      Response response = await api.sendRequest.get(
        Global.cart,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 200) {
        log("Cart items fetched successfully: ${response.data}");

        // Check if the response contains a key that holds the list of cart items
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('results')) {
          final List<dynamic> cartItems = data['results'] as List<dynamic>;
          return cartItems;
        } else {
          Fluttertoast.showToast(
            msg: "Unexpected response format. Please contact support.",
            backgroundColor: ConstColors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
          );
          return [];
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch cart items. Please try again.",
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

  /// Add a product to the cart
  Future<bool> addToCart({
    required int productId,
    required int quantity, required int userId,
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

      // Hardcoded user ID
      const int userId = 9;

      // Prepare the request payload
      Map<String, dynamic> data = {
        "user": userId, // Hardcoded user ID
        "product": productId,
        "quantity": quantity,
      };

      // Add the token to the request headers
      Response response = await api.sendRequest.post(
        Global.cart,
        data: data,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 201) {
        log("Product added to cart successfully: ${response.data}");
        Fluttertoast.showToast(
          msg: "Product added to cart!",
          backgroundColor: ConstColors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to add product to cart. Please try again.",
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

  /// Update the quantity of a product in the cart
  Future<bool> updateCartItem({
    required int cartItemId,
    required int newQuantity,
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
        "quantity": newQuantity,
      };

      // Add the token to the request headers
      Response response = await api.sendRequest.patch(
        "${Global.cart}$cartItemId/",
        data: data,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 200) {
        log("Cart item updated successfully: ${response.data}");
        Fluttertoast.showToast(
          msg: "Cart item updated!",
          backgroundColor: ConstColors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update cart item. Please try again.",
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

  /// Delete a product from the cart
  Future<bool> deleteCartItem({
    required int cartItemId,
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

      // Add the token to the request headers
      Response response = await api.sendRequest.delete(
        "${Global.cart}$cartItemId/",
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 204) {
        log("Cart item deleted successfully.");
        Fluttertoast.showToast(
          msg: "Item removed from cart!",
          backgroundColor: ConstColors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to remove item from cart. Please try again.",
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