import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/controllers/cart_controller.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer package

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Instantiate the CartController
  final CartController _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ConstColors.primaryColor,
      ),
      body: SafeArea(
        child: Obx(() {
          // Show loading indicator while fetching data
          if (_cartController.isLoading.value) {
            return _buildShimmerEffect();
          }

          // Check if the cart is empty
          if (_cartController.cartItemsWithDetails.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 18.sp, color: ConstColors.textColor),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartController.cartItemsWithDetails.length,
                    itemBuilder: (context, index) {
                      final item = _cartController.cartItemsWithDetails[index];
                      final cartItemId = item['id'];
                      final product = item['product']; // Full product details
                      final quantity = item['quantity'];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                        elevation: 2,
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: NetworkImage(product.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "\₹${product.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ConstColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Control
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      _cartController.updateCartItem(cartItemId, quantity - 1);
                                    }
                                  },
                                  icon: Icon(Icons.remove_circle_outline, size: 24.sp),
                                ),
                                Text(
                                  "$quantity",
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _cartController.updateCartItem(cartItemId, quantity + 1);
                                  },
                                  icon: Icon(Icons.add_circle_outline, size: 24.sp),
                                ),
                              ],
                            ),

                            // Delete Button
                            IconButton(
                              onPressed: () {
                                _cartController.deleteCartItem(cartItemId);
                              },
                              icon: Icon(Icons.delete, size: 24.sp, color: ConstColors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Total Price Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      Obx(() => Text(
                            "\₹${_cartController.totalPrice.value.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),

                // Place Order Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _cartController.placeOrderAndNavigateToPayment(); // Call the placeOrder method
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Order",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  /// Shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            elevation: 2,
            child: Row(
              children: [
                // Shimmer for product image
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.w),

                // Shimmer for product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 16.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 60.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Shimmer for quantity control
                Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 24.w,
                      height: 24.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}