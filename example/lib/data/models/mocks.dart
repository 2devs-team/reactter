import 'dart:convert';
import 'package:example/data/database/cart.json.dart';
import 'package:example/data/database/products.json.dart';
import 'package:example/data/database/users.json.dart';
import 'package:example/data/models/cart.dart';
import 'package:example/data/models/product.dart';
import 'package:example/data/models/user.dart';

class Mocks {
  static List<User>? getUsers() {
    final userList = Users.fromJson(jsonDecode(UserJson.get)).users;

    return userList;
  }

  static List<Product>? getProducts() {
    final productList = Products.fromJson(jsonDecode(ProductsJson.get));

    return productList.products;
  }

  static List<Cart>? getCarts() {
    final cartList = Carts.fromJson(jsonDecode(CartJson.get)).carts;

    final userList = getUsers();

    int i = 1;
    for (var itemCart in cartList!) {
      itemCart.userId = userList![i].id;
      itemCart.user = userList[i];

      final condition = i & 2 == 0;

      itemCart.products = condition ? null : itemCart.products;
      itemCart.totalProducts = condition ? 0 : itemCart.totalProducts;

      i++;
    }

    return cartList;
  }

  static Cart? getUserCart(int userId) {
    final carts = getCarts();

    try {
      return carts!.firstWhere((element) => element.userId == userId);
    } catch (e) {
      return null;
    }
  }
}
