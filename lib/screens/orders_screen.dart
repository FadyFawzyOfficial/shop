import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_list_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'orders';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Just to be sure it's first time to open the Edit Product Screen
  // var _isInit = true;

  @override
  void initState() {
    super.initState();

    // In initState, all these of context things don't work
    // Like ModalRoute.of(context) and so on ...
    // Because the widget is not fully wired up with everything here.
    // So therefore we can't do that here.

    // Important: If you add listen: false, you CAN use this in initState()!
    // Workarounds are only needed if you don't set listen to false.
    // Provider.of<Orders>(context).fetchOrders(); // WON'T WORK!
    Provider.of<Orders>(context, listen: false).fetchOrders(); // WILL WORK!

    // => First Approach
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  // => Second Approach
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<Products>(context).fetchAndSetProducts();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (context, index) => OrderListItem(
          order: ordersProvider.orders[index],
        ),
      ),
    );
  }
}
