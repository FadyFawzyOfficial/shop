import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(product.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded),
            onPressed: product.toggleFavorite,
          ),
          title: Text(product.title),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: const Icon(Icons.shopping_cart_rounded),
            onPressed: () {},
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
