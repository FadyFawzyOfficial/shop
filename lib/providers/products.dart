import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  static const baseUrl =
      'fady-shop-default-rtdb.europe-west1.firebasedatabase.app';
  static const productsPath = '/products.json';

  Products({this.authToken, List<Product>? products}) {
    productsUri = Uri.https(baseUrl, productsPath, {'auth': authToken});
    _products = products ?? [];
  }

  final String? authToken;

  late final Uri productsUri;

  List<Product> _products = [];

  List<Product> get products => [..._products];

  List<Product> get favoriteProducts =>
      _products.where((product) => product.isFavorite).toList();

  Product getProductById({required String id}) =>
      _products.firstWhere((product) => product.id == id);

  Future<void> fetchProducts() async {
    try {
      final List<Product> products = [];
      final response = await get(productsUri);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>?;

      // So that the following code doesn't run if fetched data is null and
      // return here to avoid that you run code which would fail if you have no data
      if (fetchedData == null) return;

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

  Future<void> updateProduct(Product product) async {
    final productIndex = _products.indexWhere((x) => x.id == product.id);
    if (productIndex > -1) {
      try {
        await patch(getProductUri(product.id), body: product.toJson());
        _products[productIndex] = product;
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

    try {
      final response = await patch(
        getProductUri(product.id),
        body: product.toJson(),
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
    final product = _products[productIndex];

    try {
      _products.removeAt(productIndex);
      notifyListeners();

      // For get and post, the HTTP package would have thrown an error and catch
      // would've kicked off, but here (delete) that is not happening and
      // therefore I want to throw my own error if that's the case.
      final response = await delete(getProductUri(id));

      // Check if response status code is greater than or equal than 400 which
      // means something went wrong and in that case, I want to throw my own error
      // and not continue with the following code.
      if (response.statusCode >= 400) {
        _products.insert(productIndex, product);
        notifyListeners();
        throw HttpException(message: 'Could not delete this product.');
      }
    } catch (e) {
      _products.insert(productIndex, product);
      notifyListeners();
      rethrow;
    }
  }

  Uri getProductUri(String id) => Uri.https(baseUrl, '/products/$id.json');
}
