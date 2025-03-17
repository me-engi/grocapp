import 'package:get/get.dart';
import 'package:grocery/repo/cart_repo.dart';


class CartController extends GetxController {
  final CartRepo _cartRepo = CartRepo();

  // Observables for managing cart items
  var cartItems = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  /// Fetch all cart items for the authenticated user
  void fetchCartItems() async {
    cartItems.value = await _cartRepo.getCartItems();
  }

  /// Add a product to the cart
  void addToCart({
    required int productId,
    required int quantity,
  }) async {
    bool success = await _cartRepo.addToCart(
      productId: productId,
      quantity: quantity,
    );
    if (success) {
      fetchCartItems(); // Refresh the list of cart items
    }
  }

  /// Update the quantity of a product in the cart
  void updateCartItem({
    required int cartItemId,
    required int newQuantity,
  }) async {
    bool success = await _cartRepo.updateCartItem(
      cartItemId: cartItemId,
      newQuantity: newQuantity,
    );
    if (success) {
      fetchCartItems(); // Refresh the list of cart items
    }
  }
}