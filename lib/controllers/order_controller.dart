import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/global.dart'; // Import the global file
import 'package:grocery/repo/orderrepo.dart';

class OrderController extends GetxController {
  final OrderRepo _orderRepo = OrderRepo();

  // Observables for managing orders
  var orders = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Fetch all orders for the authenticated user
  void fetchOrders() async {
    orders.value = await _orderRepo.getOrders();
  }

  /// Create a new order
  Future<void> createNewOrder({
    required double totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    // Use the hardcoded user ID and shop owner ID from global.dart
    final int userId = Global.userId;
    final int shopOwnerId = Global.shopOwnerId;

    // Call the createOrder method from OrderRepo
    Map<String, dynamic>? orderResponse = await _orderRepo.createOrder(
      userId: userId, // Pass the user ID from global.dart
      shopOwnerId: shopOwnerId, // Pass the shop owner ID from global.dart
      totalPrice: totalPrice,
      items: items,
    );

    if (orderResponse != null) {
      // Extract the order ID from the response
      int orderId = orderResponse['id'];

      // If the order was created successfully, refresh the list of orders
      fetchOrders();

      // Optionally, you can show a success message
      Get.snackbar(
        "Success",
        "Order created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // If the order creation failed, show an error message
      Get.snackbar(
        "Error",
        "Failed to create the order. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}