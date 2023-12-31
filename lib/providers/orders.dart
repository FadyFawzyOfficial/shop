import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/cart_item.dart';
import '../models/http_exception.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  static const baseUrl =
      'fady-shop-default-rtdb.europe-west1.firebasedatabase.app';

  Orders({this.authToken, this.userId, List<Order>? orders})
      : ordersUri = Uri.https(
          baseUrl,
          '/orders/$userId.json',
          {'auth': authToken},
        ),
        _orders = orders ?? [];

  final String? authToken;
  final String? userId;
  late final Uri ordersUri;
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> fetchOrders() async {
    try {
      final List<Order> orders = [];
      final response = await get(ordersUri);
      final fetchedOrders = json.decode(response.body) as Map<String, dynamic>?;

      // So that the following code doesn't run if fetched data is null and
      // return here to avoid that you run code which would fail if you have no data
      if (fetchedOrders == null) return;

      fetchedOrders.forEach((orderId, orderData) =>
          orders.insert(0, Order.fromMap(orderData).copyWith(id: orderId)));
      _orders = orders;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

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
