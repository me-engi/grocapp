import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/product_controller.dart';
import 'package:grocery/models/category_model.dart';
import 'package:grocery/models/productmodel.dart';
import 'package:grocery/repo/cart_repo.dart';
import 'package:grocery/widgets/searchbar_widget.dart';

class HomePage extends StatelessWidget {
  final ProductController _productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          SearchBarw(),

          // Categories Section
          Obx(() {
            if (_productController.categories.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _productController.categories.length + 1, // +1 for "All Categories"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "All Categories" option
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                        label: Text("All Categories"),
                        selected: _productController.selectedCategoryId.value == 0,
                        onSelected: (selected) {
                          _productController.clearCategoryFilter();
                        },
                      ),
                    );
                  } else {
                    // Other categories
                    CategoryModel category = _productController.categories[index - 1];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                        label: Text(category.name),
                        selected: _productController.selectedCategoryId.value == category.id,
                        onSelected: (selected) {
                          _productController.selectedCategoryId.value = category.id;
                          _productController.fetchProductsByCategory(category.id);
                        },
                      ),
                    );
                  }
                },
              ),
            );
          }),

          // Products Grid View
          Expanded(
            child: Obx(() {
              if (_productController.filteredProducts.isEmpty) {
                return Center(child: Text("No products found for this category."));
              }
              return GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: _productController.filteredProducts.length,
                itemBuilder: (context, index) {
                  ProductModel product = _productController.filteredProducts[index];
                  return ProductCard(product: product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Product Card Widget


class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartRepo _cartRepo = CartRepo(); // Initialize CartRepo

    return GestureDetector(
      onTap: () {
        // Optional: You can keep this if you want to navigate to a product details page later
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: _buildProductImage(product.image),
              ),
            ),

            // Product Name and Price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\₹${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity, // Make the button full width
                child: ElevatedButton(
                  onPressed: () async {
                    // Hardcoded user ID and default quantity
                    const int userId = 9; // Hardcoded user ID
                    const int quantity = 1; // Default quantity

                    // Call the addToCart method from CartRepo
                    bool success = await _cartRepo.addToCart(
                      productId: product.id,
                      quantity: quantity,
                      userId: userId,
                    );

                    // Show feedback to the user
                    if (success) {
                      Get.snackbar(
                        "Success",
                        "${product.name} added to cart!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to add ${product.name} to cart.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Text("Add to Cart"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build the product image with error handling
  Widget _buildProductImage(String? imageUrl) {
    // Validate the image URL
    if (imageUrl == null || imageUrl.isEmpty) {
      return Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
      );
    }

    // Use Image.network with errorBuilder for robust error handling
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(Icons.error, color: Colors.red, size: 50),
        );
      },
    );
  }
}