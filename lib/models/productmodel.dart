class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int categoryId;
  final int shopOwnerId;
  final String image;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.shopOwnerId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to convert JSON to ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      stock: json['stock'],
      categoryId: json['category'],
      shopOwnerId: json['shop_owner'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}