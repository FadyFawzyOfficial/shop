import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FavoriteOption {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavorites = false;

  @override
  Widget build(BuildContext context) {
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
            onSelected: (selectedOption) => setState(() =>
                showFavorites = selectedOption == FavoriteOption.favorites),
          ),
        ],
      ),
      body: ProductsGrid(showFavorites: showFavorites),
    );
  }
}
