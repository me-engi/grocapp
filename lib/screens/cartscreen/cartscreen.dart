import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Instantiate the CartController
  final CartController _cartController = Get.put(CartController());

  /// Place an order and clear the cart
  Future<void> _placeOrder() async {
    final shopOwnerId = 4; // Hardcoded shop owner ID

    // Prepare list of items for the order
    List<Map<String, dynamic>> items = [];
    for (var item in _cartController.cartItemsWithDetails) {
      final product = item['product'];
      items.add({
        "product": product.id,
        "quantity": item['quantity'],
      });
    }

    // Call the placeOrder method in the CartController
    final success = await _cartController.placeOrder(
      shopOwnerId: shopOwnerId,
      totalPrice: _cartController.totalPrice.value,
      items: items,
    );

    if (success) {
      Get.snackbar(
        "Success",
        "Order placed successfully!",
        backgroundColor: ConstColors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to place the order.",
        backgroundColor: ConstColors.red,
        colorText: Colors.white,
      );
    }
  }

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
                    onPressed: () {
                      _placeOrder();
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
}