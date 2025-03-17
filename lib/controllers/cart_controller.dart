import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/models/productmodel.dart'; // Import the ProductModel
import 'package:grocery/repo/cart_repo.dart';
import 'package:grocery/repo/orderrepo.dart';
import 'package:grocery/repo/product_repo.dart';

class CartController extends GetxController {
  final CartRepo _cartRepo = CartRepo();
  final ProductRepo _productRepo = ProductRepo();
  final OrderRepo _orderRepo = OrderRepo();

  // Observables for cart items and total price
  RxList<Map<String, dynamic>> cartItemsWithDetails = <Map<String, dynamic>>[].obs;
  RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItemsWithDetails(); // Fetch cart items and product details on initialization
  }

  /// Fetch cart items and enrich them with product details
  Future<void> fetchCartItemsWithDetails() async {
    try {
      // Clear existing cart items
      cartItemsWithDetails.clear();

      // Fetch cart items from CartRepo
      final cartItems = await _cartRepo.getCartItems();

      // Enrich each cart item with product details
      for (var cartItem in cartItems) {
        final productId = cartItem['product']; // Assuming 'product' is just the product ID
        final quantity = cartItem['quantity'];

        try {
          // Fetch product details from ProductRepo using getProductById
          final productModel = await _fetchProductDetails(productId);

          if (productModel != null) {
            // Add enriched cart item to the list
            cartItemsWithDetails.add({
              "id": cartItem['id'],
              "product": productModel, // Use ProductModel here
              "quantity": quantity,
            });
          } else {
            log("Product details not found for ID: $productId");
          }
        } catch (e) {
          // Log error if product details cannot be fetched
          log("Failed to fetch product details for ID: $productId - $e");
        }
      }

      // Calculate total price after fetching all items
      calculateTotalPrice();
    } catch (e) {
      // Show error message if cart items cannot be fetched
      Get.snackbar(
        "Error",
        "Failed to fetch cart items. Please try again.",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Fetch product details by product ID
  Future<ProductModel?> _fetchProductDetails(int productId) async {
    try {
      // Use getProductById to fetch a single product
      return await _productRepo.getProductById(productId);
    } catch (e) {
      log("Error fetching product details for ID: $productId - $e");
      return null;
    }
  }

  /// Calculate total price of all cart items
  void calculateTotalPrice() {
    double total = 0.0;
    for (var item in cartItemsWithDetails) {
      total += item['product'].price * item['quantity']; // Access price from ProductModel
    }
    totalPrice.value = total;
  }

  /// Update cart item quantity via API
  Future<void> updateCartItem(int cartItemId, int newQuantity) async {
    try {
      final success = await _cartRepo.updateCartItem(
        cartItemId: cartItemId,
        newQuantity: newQuantity,
      );

      if (success) {
        fetchCartItemsWithDetails(); // Refresh cart items after update
      } else {
        Get.snackbar(
          "Error",
          "Failed to update cart item. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while updating the cart item.",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Delete cart item via API
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      final success = await _cartRepo.deleteCartItem(cartItemId: cartItemId);

      if (success) {
        fetchCartItemsWithDetails(); // Refresh cart items after deletion
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete cart item. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while deleting the cart item.",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Place an order using the OrderRepo
  Future<bool> placeOrder({
    required int shopOwnerId,
    required double totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // Call the createOrder method from OrderRepo
      final success = await _orderRepo.createOrder(
        shopOwnerId: shopOwnerId,
        totalPrice: totalPrice,
        items: items,
      );

      if (success) {
        // Clear the cart after successfully placing the order
        for (var item in cartItemsWithDetails) {
          await _cartRepo.deleteCartItem(cartItemId: item['id']);
        }
        cartItemsWithDetails.clear();
        calculateTotalPrice(); // Reset total price

        // Show success message
        Get.snackbar(
          "Success",
          "Order placed successfully!",
          backgroundColor: ConstColors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to place the order. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
      }

      return success;
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while placing the order.",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}