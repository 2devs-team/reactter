// To parse this JSON data, do
//
//     final carts = cartsFromJson(jsonString);

import 'dart:convert';

import 'package:example/data/models/product.dart';
import 'package:example/data/models/user.dart';

Carts cartsFromJson(String str) => Carts.fromJson(json.decode(str));

String cartsToJson(Carts data) => json.encode(data.toJson());

class Carts {
  Carts({
    this.carts,
    this.total,
    this.skip,
    this.limit,
  });

  List<Cart>? carts;
  int? total;
  int? skip;
  int? limit;

  factory Carts.fromJson(Map<String, dynamic> json) => Carts(
        carts: json["carts"] == null
            ? null
            : List<Cart>.from(json["carts"].map((x) => Cart.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "carts": carts == null
            ? null
            : List<dynamic>.from((carts ?? []).map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class Cart {
  Cart({
    this.id,
    this.products,
    this.total,
    this.discountedTotal,
    this.userId,
    this.totalProducts,
    this.totalQuantity,
    this.user,
  });

  int? id;
  List<Product>? products;
  int? total;
  int? discountedTotal;
  int? userId;
  User? user;
  int? totalProducts;
  int? totalQuantity;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        total: json["total"],
        discountedTotal: json["discountedTotal"],
        userId: json["userId"],
        totalProducts: json["totalProducts"],
        totalQuantity: json["totalQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "products": products == null
            ? null
            : List<dynamic>.from((products ?? []).map((x) => x.toJson())),
        "total": total,
        "discountedTotal": discountedTotal,
        "userId": userId,
        "totalProducts": totalProducts,
        "totalQuantity": totalQuantity,
      };

  Cart copyWith({
    int? id,
    List<Product>? products,
    int? total,
    int? discountedTotal,
    int? userId,
    User? user,
    int? totalProducts,
    int? totalQuantity,
  }) =>
      Cart(
        id: id,
        products: products,
        total: total,
        discountedTotal: discountedTotal,
        userId: userId,
        totalProducts: totalProducts,
        totalQuantity: totalQuantity,
        user: user,
      );
}
