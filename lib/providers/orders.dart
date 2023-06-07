import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/cart_item.dart';
import '../models/http_exception.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  static const baseUrl =
      'fady-shop-default-rtdb.europe-west1.firebasedatabase.app';
  static const ordersPath = '/orders.json';
  final ordersUri = Uri.https(baseUrl, ordersPath);

  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> addOrder({
    required List<CartItem> products,
    required double amount,
  }) async {
    Order order = Order(
      id: '',
      amount: amount,
      products: products,
      dateTime: DateTime.now(),
    );
    try {
      final response = await post(ordersUri, body: order.toJson());
      order = order.copyWith(id: json.decode(response.body)['name']);
      _orders.insert(0, order);
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
      // Throw the error to handle it in Widget Level
      throw HttpException(message: 'Could not Make an Order.');
    }
  }
}
