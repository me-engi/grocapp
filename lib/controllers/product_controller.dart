import 'package:get/get.dart';
import 'package:grocery/models/productmodel.dart';
import 'package:grocery/repo/product_repo.dart';


class ProductController extends GetxController {
  final ProductRepo _productRepo = ProductRepo();

  // Observables for managing product lists
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts(); // Fetch all products on initialization
  }

  /// Fetch all products
  void fetchAllProducts() async {
    allProducts.value = await _productRepo.getAllProducts();
  }

  /// Fetch products filtered by category ID
  void fetchProductsByCategory(int categoryId) async {
    filteredProducts.value = await _productRepo.getProductsByCategory(categoryId);
  }
}