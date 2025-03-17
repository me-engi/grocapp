// To parse this JSON data, do
//
//     final productbyid = productbyidFromJson(jsonString);

import 'dart:convert';

Productbyid productbyidFromJson(String str) => Productbyid.fromJson(json.decode(str));

String productbyidToJson(Productbyid data) => json.encode(data.toJson());

class Productbyid {
    int id;
    String name;
    String description;
    String price;
    int stock;
    int category;
    int shopOwner;
    String image;
    DateTime createdAt;
    DateTime updatedAt;

    Productbyid({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.stock,
        required this.category,
        required this.shopOwner,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Productbyid.fromJson(Map<String, dynamic> json) => Productbyid(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        stock: json["stock"],
        category: json["category"],
        shopOwner: json["shop_owner"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        "shop_owner": shopOwner,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
