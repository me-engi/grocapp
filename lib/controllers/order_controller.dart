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
    required int shopOwnerId,
    required double totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    bool success = await _orderRepo.createOrder(
      shopOwnerId: shopOwnerId,
      totalPrice: totalPrice,
      items: items,
    );
    if (success) {
      fetchOrders(); // Refresh the list of orders
    }
  }
}