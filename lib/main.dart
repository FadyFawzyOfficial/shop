import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products_screen.dart';

void main() => runApp(const MyApp());

const appName = 'Shop';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        // How do we actually get the authToken (out of Auth class) into our Products class?
        // Use ChangeNotifierProxyProvider which is Generic class<>
        // This allows you to set up a provider, which itself depends on another
        // provider which was defined before (Auth Provider).
        // 1st Generic argument: is the class that the type of data you depend on.
        // 2nd Generic argument: is the class that the type of data will provide here.
        ChangeNotifierProxyProvider<Auth, Products>(
          // We just add create method because it just required.
          create: (context) => Products(),
          // So, the update here will receive that 'authProvider' object (1st Generic argument)
          // and whenever Auth Provider changes, this provider here will also be rebuilt.
          // Only this one, not the entire widget, not the other providers.
          // Because this 'authProvider' object is now dependent on Auth Provider.
          // So, it makes sense that this provider rebuilds and new products
          // object here would be built when auth changes instead of previous
          // state of products object (old products object).
          // So, pervious products object which passed (2nd Generic argument)
          // will update by returning a new object of type Products after
          // we pass an auth token.
          update: (context, authProvider, previous) => Products(
            // Pass the user's auth token for outgoing HTTP requests of Products Provider.
            authToken: authProvider.token!,
            // We have to make sure that when gets rebuild and we create a new
            // instance of Products, we don't lose all the data we had in there
            // before (previousProducts) because in Products Provider you mustn't
            // forget that you had a list of your products that was the what
            // we were managing in there, the list of our products.
            // While it's first time to initialize Products object, the previousProducts
            // will be empty [] (not instantiated) with no products list at all.
            // So, this will create the products object with auth token and then
            // either with an empty list of products or with the previous items.
            products: previous?.products,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, authProvider, previous) => Orders(
            authToken: authProvider.token,
            orders: previous?.orders,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authProvider, _) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          title: appName,
          home: authProvider.isAuthenticated
              ? const ProductsOverviewScreen()
              : const AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            UserProductsScreen.routeName: (_) => const UserProductsScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
