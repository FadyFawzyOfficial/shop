import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_list_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'userProducts';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<Products>(
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
}
