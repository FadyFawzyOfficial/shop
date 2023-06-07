import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
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

  // Just to be sure it's first time to open the ProductsOverviewScreen
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    // In initState, all these of context things don't work
    // Like ModalRoute.of(context) and so on ...
    // Because the widget is not fully wired up with everything here.
    // So therefore we can't do that here.

    // Important: If you add listen: false, you CAN use this in initState()!
    // Workarounds are only needed if you don't set listen to false.
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Provider.of<Products>(context, listen: false).fetchProducts(); // WILL WORK!

    // => First Approach
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  // => Second Approach
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context, listen: false)
          .fetchProducts()
          .then((_) => setState(() => _isLoading = false));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(showFavorites: showFavorites),
    );
  }
}
