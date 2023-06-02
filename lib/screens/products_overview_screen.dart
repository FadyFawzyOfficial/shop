import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart' as custom;
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

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
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => custom.Badge(
              value: '${cart.cartCount}',
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_rounded),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
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
