import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'providers/products.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';

void main() => runApp(const MyApp());

const appName = 'Shop';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //! For Efficiency: Use 'create:' if you are creating a new instance.
          //* It's recommended more than '.value:' Constructor.
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        title: appName,
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
        },
      ),
    );
  }
}
