import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery/repo/orderrepo.dart'; // Import OrderRepo
import 'package:grocery/constants/const_colors.dart'; // Import colors
import 'package:grocery/widgets/custom_textfield.dart'; // Import custom widgets
import 'package:fluttertoast/fluttertoast.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderRepo _orderRepo = OrderRepo(); // Instance of OrderRepo
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs; // Observable list for orders
  RxBool isLoading = true.obs; // Loading state

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the screen initializes
  }

  /// Fetch orders from the backend
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true; // Show loading indicator
      Map<String, dynamic> fetchedOrders = await _orderRepo.getOrders();

      if (fetchedOrders.isNotEmpty) {
        // Assuming the API response contains a key 'results' with the list of orders
        List<dynamic>? orderList = fetchedOrders['results'];
        if (orderList != null) {
          orders.assignAll(orderList.cast<Map<String, dynamic>>()); // Update observable list
        }
      } else {
        Fluttertoast.showToast(
          msg: "No orders found.",
          backgroundColor: ConstColors.primaryColor,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      log("Error fetching orders: $e");
      Fluttertoast.showToast(
        msg: "Failed to fetch orders. Please try again.",
        backgroundColor: ConstColors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        backgroundColor: ConstColors.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: ConstColors.primaryColor,
            ),
          );
        } else if (orders.isEmpty) {
          return Center(
            child: Text(
              "No orders available.",
              style: TextStyle(
                fontSize: 16.sp,
                color: ConstColors.textColor,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orders[index];
              return OrderCard(order: order); // Display each order in a card
            },
          );
        }
      }),
    );
  }
}

/// Widget to display individual order details
class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: ${order['id'] ?? 'N/A'}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: ConstColors.primaryColor,
                  ),
                ),
                Text(
                  "Total: \₹${order['total_price'] ?? 'N/A'}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: ConstColors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Shop Owner: ${order['shop_owner_name'] ?? 'N/A'}",
              style: TextStyle(fontSize: 14.sp, color: ConstColors.textColor),
            ),
            SizedBox(height: 8.h),
            Text(
              "Placed On: ${order['created_at'] ?? 'N/A'}",
              style: TextStyle(fontSize: 14.sp, color: ConstColors.textColor),
            ),
            SizedBox(height: 8.h),
            Divider(color: ConstColors.shadowColor),
            SizedBox(height: 8.h),
            Text(
              "Items:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: ConstColors.primaryColor,
              ),
            ),
            SizedBox(height: 8.h),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: order['items']?.length ?? 0,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = order['items'][index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item['product_image'] ?? ''),
                  ),
                  title: Text(
                    "${item['product_name'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    "Qty: ${item['quantity'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 12.sp, color: ConstColors.textColor),
                  ),
                  trailing: Text(
                    "\$${item['price'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 14.sp, color: ConstColors.red),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}