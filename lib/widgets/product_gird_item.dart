import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.favorite_rounded),
          onPressed: () {},
        ),
        title: Text(product.title),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart_rounded),
          onPressed: () {},
        ),
      ),
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
