import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get products => [..._products];

  List<Product> get favoriteProducts =>
      _products.where((product) => product.isFavorite).toList();

  Product getProductById({required String id}) =>
      _products.firstWhere((product) => product.id == id);

  Future<void> addProduct(Product product) {
    const domain = 'fady-shop-default-rtdb.europe-west1.firebasedatabase.app';
    const path = '/products.json';

    final uri = Uri.https(domain, path);
    return post(uri, body: product.toJson()).then(
      (response) {
        final postedProduct =
            product.copyWith(id: json.decode(response.body)['name']);
        _products.add(postedProduct);
        // _products.insert(0, product); // at the start of the list
        notifyListeners();
      },
    );
  }

  void updateProduct(Product updatedProduct) {
    final productIndex =
        _products.indexWhere((product) => product.id == updatedProduct.id);
    if (productIndex > -1) {
      _products[productIndex] = updatedProduct;
      notifyListeners();
    } else {
      debugPrint('...');
    }
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
