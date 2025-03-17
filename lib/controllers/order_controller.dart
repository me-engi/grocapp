import 'package:get/get.dart';
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
  void createNewOrder({
    required double totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    const int userId = 9; // Hardcoded user ID
    const int shopOwnerId = 4; // Hardcoded shop owner ID

    bool success = await _orderRepo.createOrder(
      userId: userId, // Pass the hardcoded user ID
      shopOwnerId: shopOwnerId, // Pass the hardcoded shop owner ID
      totalPrice: totalPrice,
      items: items,
    );

    if (success) {
      fetchOrders(); // Refresh the list of orders
    }
  }
}