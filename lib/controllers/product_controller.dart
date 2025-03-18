import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/category_model.dart';
import 'package:grocery/models/productbyid_model.dart';
import 'package:grocery/models/productmodel.dart'; // Import ProductModel
// Import ProductByIdModel
import 'package:grocery/repo/cart_repo.dart';
import 'package:grocery/repo/category_repo.dart';
import 'package:grocery/repo/product_repo.dart';
import 'dart:developer';

class ProductController extends GetxController {
  final ProductRepo _productRepo = ProductRepo();
  final CartRepo _cartRepo = CartRepo();
  final CategoryRepo _categoryRepo = CategoryRepo();

  // Observables for managing product lists
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var searchResults = <ProductModel>[].obs;

  // Observable for managing categories
  var categories = <CategoryModel>[].obs;

  // Observable to track the selected category ID
  var selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts(); // Fetch all products on initialization
    fetchCategories(); // Fetch all categories on initialization
  }

  /// Fetch all products
  Future<void> fetchAllProducts() async {
    try {
      allProducts.value = await _productRepo.getAllProducts();
      filteredProducts.value = allProducts; // Initialize filtered products with all products
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products. Please try again.");
    }
  }

  /// Search products by name
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      filteredProducts.value = allProducts; // Show all products if the query is empty
      return;
    }

    try {
      // Filter products by name
      filteredProducts.value = allProducts
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to search products. Please try again.");
    }
  }

  /// Fetch all categories
  Future<void> fetchCategories() async {
    try {
      // Fetch categories from the repository
      categories.value = await _categoryRepo.getCategories();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories. Please try again.");
    }
  }

  /// Fetch products filtered by category ID
  Future<void> fetchProductsByCategory(int categoryId) async {
    try {
      if (categoryId == 0) {
        // If categoryId is 0, show all products
        filteredProducts.value = allProducts;
      } else {
        // Fetch products for the selected category using CategoryRepo
        List<ProductModel> products = await _categoryRepo.getProductsByCategory(categoryId);

        // Sanitize product data (ensure image URLs are valid)
        filteredProducts.value = products.map((product) {
          if (product.image == null || product.image.isEmpty) {
            // product.image = "https://via.placeholder.com/150"; // Default placeholder image
          }
          return product;
        }).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products for this category.");
    }
  }

  /// Clear category filter and show all products
  void clearCategoryFilter() {
    selectedCategoryId.value = 0;
    filteredProducts.value = allProducts;
  }

  /// Show product details in a dialog box
  void showProductDetails(BuildContext context, ProductModel product) async {
    try {
      // Fetch product details by ID
      ProductModel? productDetails = await _productRepo.getProductById(product.id);

      // Show product details in a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(productDetails!.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (productDetails.image != null && productDetails.image.isNotEmpty)
                  Image.network(
                    productDetails.image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 10),
                Text("Price: \₹${productDetails.price}"),
                SizedBox(height: 10),
                Text("Stock: ${productDetails.stock}"),
                SizedBox(height: 10),
                Text("Description: ${productDetails.description}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await addToCart(productDetails.id);
                if (success) {
                  Get.snackbar("Success", "${productDetails.name} added to cart!");
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Error", "Failed to add product to cart.");
                }
              },
              child: Text("Add to Cart"),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch product details.");
    }
  }

  /// Add product to cart via API with default quantity 1
  Future<bool> addToCart(int productId) async {
    try {
      // Hardcode user ID to 9 and set default quantity to 1
      final success = await _cartRepo.addToCart(productId: productId, quantity: 1, userId: 9);
      return success;
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred while adding to cart.");
      return false;
    }
  }
}