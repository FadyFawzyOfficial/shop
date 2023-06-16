import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  String userId;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    this.userId = '',
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Product.initial() {
    return Product(
      id: DateTime.now().toString(),
      userId: '',
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
    );
  }

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      isFavorite: map['isFavorite'],
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  @override
  String toString() =>
      'Product(id: $id, userId: $userId, title: $title, description: $description, imageUrl: $imageUrl, price: $price, isFavorite: $isFavorite)';
}
