import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder({
    required List<CartItem> products,
    required double amount,
  }) {
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
