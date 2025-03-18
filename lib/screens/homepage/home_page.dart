import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/product_controller.dart';
import 'package:grocery/models/category_model.dart';
import 'package:grocery/models/productmodel.dart';
import 'package:grocery/widgets/searchbar_widget.dart';
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class HomePage extends StatelessWidget {
  final ProductController _productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data when pulled down
          await _productController.fetchAllProducts();
          await _productController.fetchCategories();
        },
        child: Column(
          children: [
            // Search Bar
            SearchBarw(),

            // Categories Section
            Obx(() {
              if (_productController.categories.isEmpty) {
                return _buildCategoryShimmer(); // Shimmer effect for categories
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
                if (_productController.filteredProducts.isEmpty && _productController.allProducts.isNotEmpty) {
                  return Center(child: Text("No products found for this category."));
                }
                if (_productController.allProducts.isEmpty) {
                  return _buildProductShimmer(); // Shimmer effect for products
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
      ),
    );
  }

  /// Shimmer effect for categories
  Widget _buildCategoryShimmer() {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6, // Number of shimmer items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Shimmer effect for products
  Widget _buildProductShimmer() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: 6, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shimmer for image
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),

                // Shimmer for text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 60,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Shimmer for button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Product Card Widget
class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController _productController = Get.find();

    return GestureDetector(
      onTap: () {
        // Show product details dialog
        _productController.showProductDetails(context, product);
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
                    bool success = await _productController.addToCart(product.id);
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