import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/fade_route_transition.dart';
import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

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
            // onTap: () => Navigator.pushReplacementNamed(
            //   context,
            //   OrdersScreen.routeName,
            // ),
            //* With this go to Shop and then go to the order screen and observe.
            //* It just has a fade animation, it doesn't have that push from the
            //* bottom animation, it just fades because it's using our CustomRoute.
            onTap: () => Navigator.of(context).pushReplacement(
              FadeRouteTransition(
                builder: (context) => const OrdersScreen(),
              ),
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
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).signOut();
            },
          ),
        ],
      ),
    );
  }
}
