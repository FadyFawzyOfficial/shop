import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    //! Now the ProductGridItem Widgets Tree doesn't update the entire Tree
    //! when the Product changes (because listen: false), but the IconButton
    //! Wrapped with Consumer that rebuild its child on product changes.
    //* So the only (Favorite) IconButton will be rebuilt in the Tree.
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // debugPrint('Product Rebuild');
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (_, product, __) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
              onPressed: product.toggleFavorite,
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: const Icon(Icons.shopping_cart_rounded),
            onPressed: () =>
                cart.addCartItem(product.id, product.price, product.title),
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
