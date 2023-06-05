import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
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
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, imageUrl: $imageUrl, price: $price, isFavorite: $isFavorite)';
  }
}
