import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/product_controller.dart';

class SearchBarw extends StatelessWidget {
  final ProductController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search products...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (query) {
          controller.searchProducts(query); // Trigger search on text change
          if (query.isEmpty) {
            controller.clearCategoryFilter(); // Show all products if the query is empty
          }
        },
      ),
    );
  }
}