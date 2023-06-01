import 'package:flutter/foundation.dart';

import 'cart.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(List<CartItem> products, double amount) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: amount,
        products: products,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
