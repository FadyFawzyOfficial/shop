import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => {..._cartItems};

  int get cartCount => _cartItems.length;

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach(
      (key, cartItem) => total += cartItem.price * cartItem.quantity,
    );
    return total;
  }

  void addCartItem(String productId, double price, String title) {
    if (_cartItems.containsKey(productId)) {
      // Change the quantity
      _cartItems.update(
        productId,
        (cartItem) => cartItem.copyWith(
          quantity: cartItem.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void reduceItemQuantity(String productId) {
    if (!_cartItems.containsKey(productId)) return;

    final cartItemQuantity = _cartItems[productId]?.quantity ?? 0;

    if (cartItemQuantity > 1) {
      _cartItems.update(
        productId,
        (cartItem) => cartItem.copyWith(quantity: cartItemQuantity - 1),
      );
    } else {
      _cartItems.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
  }
}
