import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/product_controller.dart';
import 'package:grocery/models/productmodel.dart';

class CategoryProductList extends StatelessWidget {
  final String categoryName;
  final int categoryId;

  CategoryProductList({required this.categoryName, required this.categoryId});

  final ProductController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Fetch products for the current category when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductsByCategory(categoryId);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Obx(() {
          if (controller.filteredProducts.isEmpty) {
            return Center(child: Text("No products available in this category."));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.filteredProducts.map((product) {
                return ProductCard(product: product);
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<ProductController>().showProductDetails(context, product);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                product.image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text("\$${product.price.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}