import 'package:examples/examples/3_shopping_cart/data/data_source.dart';
import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

abstract class IProductRepository {
  Future<List<Product>> getAllProducts();
}

class ProductRepository implements IProductRepository {
  final _uDataSource = UseDependency.create(DataSource.new);

  DataSource get _dataSource {
    return _uDataSource.instance ?? (throw Exception('DataSource not found'));
  }

  @override
  Future<List<Product>> getAllProducts() async {
    return _dataSource.fetchAllProducts();
  }
}
