import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/products_grid.dart';

enum FavoriteOption {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FavoriteOption.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FavoriteOption.all,
                child: Text('Show All'),
              ),
            ],
            onSelected: (selectedOption) =>
                selectedOption == FavoriteOption.favorites
                    ? productsProvider.showOnlyFavorites()
                    : productsProvider.showAll(),
          ),
        ],
      ),
      body: const ProductsGrid(),
    );
  }
}
