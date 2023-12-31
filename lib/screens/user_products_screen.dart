import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_list_item.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'userProducts';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              EditProductScreen.routeName,
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.error != null) {
            // Do error handling stuff here
            return const Center(child: Text('An error occurred!'));
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(
                builder: (context, provider, child) => ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) => UserProductListItem(
                    product: provider.products[index],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) async =>
      await Provider.of<Products>(context, listen: false)
          .fetchProducts(filterByUser: true);
}
