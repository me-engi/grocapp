import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/constants/global.dart'; // Import the global file
import 'package:grocery/repo/orderiteamrepo.dart';
import 'package:grocery/repo/orderrepo.dart';
import 'package:grocery/repo/paymnetrepo.dart';
import 'package:grocery/screens/paymnetsscreen.dart';
import 'package:grocery/screens/paymnetsucess.dart';

class OrderPaymentController extends GetxController {
  final OrderRepo _orderRepo = OrderRepo();
  final OrderItemsRepo _orderItemsRepo = OrderItemsRepo();
  final PaymentsRepo _paymentsRepo = PaymentsRepo();

  // Observables for managing order and payment
  var orderId = 0.obs; // Observable for order ID
  var totalAmount = 0.0.obs; // Observable for total amount

  // Store the items list
  List<Map<String, dynamic>> items = [];

  /// Create a new order and navigate to the payment screen
  Future<void> createOrderAndNavigateToPayment({
    required double totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // Store the items list
      this.items = items;

      // Use the hardcoded user ID and shop owner ID from global.dart
      final int userId = Global.userId;
      final int shopOwnerId = Global.shopOwnerId;

      // Create the order
      Map<String, dynamic>? orderResponse = await _orderRepo.createOrder(
        userId: userId, // Pass the user ID from global.dart
        shopOwnerId: shopOwnerId, // Pass the shop owner ID from global.dart
        totalPrice: totalPrice,
        items: items,
      );

      if (orderResponse != null) {
        // Extract the order ID and total price from the response
        int createdOrderId = orderResponse['id'];
        double totalAmountFromResponse = double.parse(orderResponse['total_price']);

        // Update the order ID and total amount
        orderId.value = createdOrderId;
        totalAmount.value = totalAmountFromResponse;

        // Log the orderId and totalAmount
        print("Order ID after creating order: ${orderId.value}");
        print("Total Amount after creating order: ${totalAmount.value}");

        // Navigate to the payment screen
        Get.to(() => PaymentScreen(
          orderId: orderId.value,
          totalAmount: totalAmount.value,
        ));
      } else {
        Get.snackbar(
          "Error",
          "Failed to create the order. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while creating the order: $e",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Create payment and order items
  Future<bool> createPaymentAndOrderItems({
    required String paymentMethod,
  }) async {
    try {
      // Log the orderId and totalAmount before making the payment
      print("Order ID in createPaymentAndOrderItems: ${orderId.value}");
      print("Total Amount in createPaymentAndOrderItems: ${totalAmount.value}");

      // Validate the orderId
      if (orderId.value <= 0) {
        Get.snackbar(
          "Error",
          "Invalid order ID. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Create payment
      bool paymentSuccess = await _paymentsRepo.createPayment(
        orderId: orderId.value,
        amount: totalAmount.value,
        paymentMethod: paymentMethod,
        status: "completed", // Always set status to "completed"
      );

      if (paymentSuccess) {
        // Create order items
        for (var item in items) {
          bool orderItemSuccess = await _orderItemsRepo.createOrderItem(
            orderId: orderId.value,
            productId: item['product_id'],
            quantity: item['quantity'],
            price: item['price'],
          );

          if (!orderItemSuccess) {
            Get.snackbar(
              "Error",
              "Failed to create order items. Please try again.",
              backgroundColor: ConstColors.red,
              colorText: Colors.white,
            );
            return false;
          }
        }

        // Navigate to the success screen
        Get.off(() => PaymentSuccessScreen());
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to create the payment. Please try again.",
          backgroundColor: ConstColors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while processing the payment: $e",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}