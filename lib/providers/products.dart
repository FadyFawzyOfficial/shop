import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  static const baseUrl =
      'fady-shop-default-rtdb.europe-west1.firebasedatabase.app';
  static const productsPath = '/products.json';
  final productsUri = Uri.https(baseUrl, productsPath);

  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get products => [..._products];

  List<Product> get favoriteProducts =>
      _products.where((product) => product.isFavorite).toList();

  Product getProductById({required String id}) =>
      _products.firstWhere((product) => product.id == id);

  Future<void> fetchProducts() async {
    try {
      final List<Product> products = [];
      final response = await get(productsUri);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;

      fetchedData.forEach((productId, productData) {
        products.add(Product.fromMap(productData).copyWith(id: productId));
      });

      _products = products;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // When using async, the function which you use it always returns future,
  // that future might then not yield anything in the end but it always returns a future
  Future<void> addProduct(Product product) async {
    try {
      // We don't have to return future anymore because we automatically have
      // this all wrapped into a future and that future will also be returned
      // automatically.
      await post(productsUri, body: product.toJson()).then(
        (response) {
          final postedProduct =
              product.copyWith(id: json.decode(response.body)['name']);
          _products.add(postedProduct);
          // _products.insert(0, product); // at the start of the list
          notifyListeners();
        },
      );
    } catch (error) {
      debugPrint('$error');
      // Throw the error to handle it in the Widget Level.
      rethrow;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final updatedProductId = updatedProduct.id;
    final updateProductUri =
        Uri.https(baseUrl, '/products/$updatedProductId.json');
    final productIndex =
        _products.indexWhere((product) => product.id == updatedProductId);
    if (productIndex > -1) {
      try {
        await patch(updateProductUri, body: updatedProduct.toJson());
        _products[productIndex] = updatedProduct;
        notifyListeners();
      } catch (e) {
        debugPrint('$e');
        rethrow;
      }
    } else {
      debugPrint('...');
    }
  }

  Future<void> toggleProductFavorite(Product product) async {
    product.toggleFavorite();
    final productId = product.id;
    final productUri = Uri.https(baseUrl, '/products/$productId.json');
    final updatedProduct = product.toJson();
    try {
      final response = await patch(
        productUri,
        body: updatedProduct,
      );

      // The HTTP package only throws its own error for get and post requests
      // if the server returns an error status code.
      // For patch, put, delete, it doesn't do that.
      if (response.statusCode >= 400) {
        product.toggleFavorite();
        throw HttpException(message: 'Could not update that product!.');
      }
    } catch (e) {
      product.toggleFavorite();
      rethrow;
    }
  }

  Future<void> removeProduct(String id) async {
    final productIndex = _products.indexWhere((product) => product.id == id);
    final removeProductUri = Uri.https(baseUrl, '/products/$id.json');
    final product = _products[productIndex];

    try {
      _products.removeAt(productIndex);
      notifyListeners();

      // For get and post, the HTTP package would have thrown an error and catch
      // would've kicked off, but here (delete) that is not happening and
      // therefore I want to throw my own error if that's the case.
      final response = await delete(removeProductUri);

      // Check if response status code is greater than or equal than 400 which
      // means something went wrong and in that case, I want to throw my own error
      // and not continue with the following code.
      if (response.statusCode >= 400) {
        _products.insert(productIndex, product);
        notifyListeners();
        throw HttpException(message: 'Could not delete this product.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
