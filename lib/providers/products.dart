import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  static const baseUrl =
      'fady-shop-default-rtdb.europe-west1.firebasedatabase.app';
  static const productsPath = '/products.json';

  Products({
    this.authToken,
    this.userId,
    List<Product>? products,
  }) {
    productsUri = Uri.https(baseUrl, productsPath, {'auth': authToken});
    _products = products ?? [];
  }

  final String? authToken;
  final String? userId;
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

      // When we fetch products, we of course also want to fetch data for the
      // favorite status according to each user.
      // So, we also fetch the favorite statuses before transforming products data.
      // Here because: I don't want to do that if we have no products.
      // So, I'll wait for the previous check (if statement).

      // It's time for another request where we get our favorite response
      print(favoriteProductsUri(userId!));
      final favoriteResponse = await get(favoriteProductsUri(userId!));
      final favoriteData = json.decode(favoriteResponse.body);
      print(favoriteData);

      fetchedData.forEach(
        (productId, productData) {
          products.add(
            Product.fromMap(productData).copyWith(
              id: productId,
              // If favoriteData is null, then this user has never favorited anything.
              // So then obviously every product will just be not a favorite,
              // so we set this to false.
              // If favoriteData isn't null, then the user has some favorite data
              // we can check for that productId(key here), but that productId still
              // might not exist (null). So, I want to user an alternative value if
              // it is null. With double question mark (??) operator to use that value
              // and if it is null it will fallback to the value after the ?? marks.
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
            ),
          );
        },
      );

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
      await post(productsUri, body: product.copyWith(userId: userId).toJson())
          .then(
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
      final response = await put(
        favoriteProductsUri(userId!, product.id),
        body: json.encode(product.isFavorite),
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

  Uri favoriteProductsUri(String userId, [String? productId]) {
    return Uri.https(
      baseUrl,
      '/userFavorites/$userId${productId != null ? '/$productId' : ''}.json',
      {'auth': authToken},
    );
  }

  Uri getProductUri(String id) {
    return Uri.https(
      baseUrl,
      '/products/$id.json',
      {'auth': authToken},
    );
  }
}
