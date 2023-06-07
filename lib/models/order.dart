import 'dart:convert';

import 'cart_item.dart';

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

  Order copyWith({
    String? id,
    double? amount,
    List<CartItem>? products,
    DateTime? dateTime,
  }) {
    return Order(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      amount: map['amount'],
      products: List<CartItem>.from(
        (map['products']).map<CartItem>(
          (x) => CartItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'products': products.map((x) => x.toMap()).toList(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'Order(id: $id, amount: $amount, products: $products, dateTime: $dateTime)';
}
