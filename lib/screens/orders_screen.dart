import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_list_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This print statement to be sure the build method should now build one time.
    print('building orders');
    //! Don't set up the listener here for Orders data when U use the FutureBuilder
    //! Because this will continue rebuilding the entire Screen.
    final ordersProvider = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      drawer: const AppDrawer(),
      // FutureBuilder Widget takes a future and then automatically starts listening to that.
      //! So it adds the then and the catch error method for you as developer.
      // And it takes a builder which will get the current snapshot to current state
      // of your future so that you can build different content based on what your future return.
      body: FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('An error occurred!'));
          } else {
            // Use a consumer of the Orders data in here
            // In that case here, because only here I'm interested in order data.
            return Consumer<Orders>(
              // It will really just rebuild the parts that do need rebuilding.
              builder: (context, ordersProvider, child) => ListView.builder(
                itemCount: ordersProvider.orders.length,
                itemBuilder: (context, index) => OrderListItem(
                  order: ordersProvider.orders[index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
