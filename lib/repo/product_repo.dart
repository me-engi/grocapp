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
      Response response = await api.sendRequest.get(Global.products);

      if (response.statusCode == 200) {
        log("Products fetched successfully: ${response.data}");

        // Parse the response
        return _parseProductResponse(response.data);
      } else {
        _showErrorToast("Failed to fetch products. Please try again.");
        return [];
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    }
  }

  /// Fetch products filtered by category ID
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      Response response = await api.sendRequest.get(
        "${Global.products}?category=$categoryId",
      );

      if (response.statusCode == 200) {
        log("Products for category $categoryId fetched successfully: ${response.data}");

        // Parse the response
        return _parseProductResponse(response.data);
      } else {
        _showErrorToast("Failed to fetch products for category $categoryId. Please try again.");
        return [];
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    }
  }

  /// Fetch products by search query
  Future<List<ProductModel>> getProductsBySearch(String query) async {
    try {
      Response response = await api.sendRequest.get(
        "${Global.products}?search=$query",
      );

      if (response.statusCode == 200) {
        log("Products for search query '$query' fetched successfully: ${response.data}");

        // Parse the response
        return _parseProductResponse(response.data);
      } else {
        _showErrorToast("Failed to fetch products for search query '$query'. Please try again.");
        return [];
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    }
  }

  /// Fetch a single product by its ID
  Future<ProductModel?> getProductById(int productId) async {
    try {
      Response response = await api.sendRequest.get("${Global.products}/$productId");

      if (response.statusCode == 200) {
        log("Product with ID $productId fetched successfully: ${response.data}");

        // Ensure the response is a map before parsing
        if (response.data is Map<String, dynamic>) {
          return ProductModel.fromJson(response.data as Map<String, dynamic>);
        } else {
          _showErrorToast("Unexpected response format. Please contact support.");
          return null;
        }
      } else {
        _showErrorToast("Failed to fetch product with ID $productId. Please try again.");
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  /// Parse the product response from the API
  List<ProductModel> _parseProductResponse(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey("results")) {
        List<dynamic> productList = responseData["results"] as List<dynamic>;
        return productList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        _showErrorToast("Unexpected response format. Please contact support.");
        return [];
      }
    } else if (responseData is List<dynamic>) {
      // If the response is already a list, use it directly
      return responseData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      _showErrorToast("Unexpected response format. Please contact support.");
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