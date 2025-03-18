import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/models/productmodel.dart'; // Import the ProductModel
import 'package:grocery/repo/cart_repo.dart';
import 'package:grocery/repo/orderrepo.dart';
import 'package:grocery/repo/product_repo.dart';
import 'package:grocery/screens/paymnetsscreen.dart'; // Import PaymentScreen

class CartController extends GetxController {
  final CartRepo _cartRepo = CartRepo();
  final ProductRepo _productRepo = ProductRepo();
  final OrderRepo _orderRepo = OrderRepo();

  // Observables for cart items and total price
  RxList<Map<String, dynamic>> cartItemsWithDetails = <Map<String, dynamic>>[].obs;
  RxDouble totalPrice = 0.0.obs;

  // Loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItemsWithDetails(); // Fetch cart items and product details on initialization
  }

  /// Fetch cart items and enrich them with product details
  Future<void> fetchCartItemsWithDetails() async {
    try {
      isLoading(true); // Start loading
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
    } finally {
      isLoading(false); // Stop loading
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

  /// Update cart item quantity via API and locally
  Future<void> updateCartItem(int cartItemId, int newQuantity) async {
    try {
      isLoading(true); // Start loading
      final success = await _cartRepo.updateCartItem(
        cartItemId: cartItemId,
        newQuantity: newQuantity,
      );

      if (success) {
        // Update the quantity locally
        final index = cartItemsWithDetails.indexWhere((item) => item['id'] == cartItemId);
        if (index != -1) {
          cartItemsWithDetails[index]['quantity'] = newQuantity;
          calculateTotalPrice(); // Recalculate total price
        }
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
    } finally {
      isLoading(false); // Stop loading
    }
  }

  /// Delete cart item via API and locally
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      isLoading(true); // Start loading
      final success = await _cartRepo.deleteCartItem(cartItemId: cartItemId);

      if (success) {
        // Remove the item locally
        cartItemsWithDetails.removeWhere((item) => item['id'] == cartItemId);
        calculateTotalPrice(); // Recalculate total price
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
    } finally {
      isLoading(false); // Stop loading
    }
  }

  /// Place an order and navigate to the payment screen
  Future<void> placeOrderAndNavigateToPayment() async {
    try {
      isLoading(true); // Start loading

      // Hardcoded user ID and shop owner ID
      const int userId = 9;
      const int shopOwnerId = 4;

      // Prepare list of items for the order
      List<Map<String, dynamic>> items = [];
      for (var item in cartItemsWithDetails) {
        final product = item['product'];
        items.add({
          "product_id": product.id,
          "quantity": item['quantity'],
          "price": product.price,
        });
      }

      // Call the createOrder method from OrderRepo
      Map<String, dynamic>? orderResponse = await _orderRepo.createOrder(
        userId: userId,
        shopOwnerId: shopOwnerId,
        totalPrice: totalPrice.value,
        items: items,
      );

      if (orderResponse != null) {
        // Extract the order ID and total price from the response
        int orderId = orderResponse['id'];
        double totalAmount = double.parse(orderResponse['total_price']);

        // Clear the cart after successfully placing the order
        cartItemsWithDetails.clear();
        calculateTotalPrice(); // Reset total price

        // Navigate to the payment screen
        Get.to(() => PaymentScreen(
          orderId: orderId,
          totalAmount: totalAmount,
        ));
      } else {
        Get.snackbar(
          "Error",
          "Failed to place the order. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while placing the order.",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false); // Stop loading
    }
  }
}