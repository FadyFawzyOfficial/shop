import 'package:flutter/material.dart';
import 'package:shop/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello, Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag_rounded),
            title: const Text('Shop'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment_rounded),
            title: const Text('Orders'),
            onTap: () => Navigator.pushReplacementNamed(
              context,
              OrdersScreen.routeName,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Manage Products'),
            onTap: () => Navigator.pushReplacementNamed(
              context,
              UserProductsScreen.routeName,
            ),
          )
        ],
      ),
    );
  }
}
