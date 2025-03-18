import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/controllers/orderPaymentController.dart';
import 'package:grocery/screens/paymnetsucess.dart'; // Import PaymentSuccessScreen

class PaymentScreen extends StatelessWidget {
  final int orderId;
  final double totalAmount;
  final OrderPaymentController _controller = Get.put(OrderPaymentController());

  PaymentScreen({required this.orderId, required this.totalAmount}) {
    // Set the orderId and totalAmount in the controller
    _controller.orderId.value = orderId;
    _controller.totalAmount.value = totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    // Log the orderId and totalAmount to verify they are being passed correctly
    print("Order ID in PaymentScreen: $orderId");
    print("Total Amount in PaymentScreen: $totalAmount");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ConstColors.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID
            Text(
              "Order ID: $orderId",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ConstColors.textColor,
              ),
            ),
            SizedBox(height: 16.h),

            // Total Amount
            Text(
              "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ConstColors.textColor,
              ),
            ),
            SizedBox(height: 32.h),

            // Payment Method (Cash on Delivery)
            Text(
              "Payment Method: Cash on Delivery",
              style: TextStyle(
                fontSize: 16.sp,
                color: ConstColors.textColor,
              ),
            ),
            SizedBox(height: 32.h),

            // Pay Now Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Log the orderId and totalAmount before processing payment
                  print("Order ID before payment: $orderId");
                  print("Total Amount before payment: $totalAmount");

                  // Process payment
                  bool success = await _controller.createPaymentAndOrderItems(
                    paymentMethod: "cash_on_delivery", // Hardcoded payment method
                  );

                  if (success) {
                    // Navigate to the success screen
                    Get.off(() => PaymentSuccessScreen());
                  } else {
                    // Show error message if payment fails
                    Get.snackbar(
                      "Error",
                      "Payment failed. Please try again.",
                      backgroundColor: ConstColors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 32.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}