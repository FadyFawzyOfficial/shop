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

// 1. Convert to StatefulWidget.
class _OrdersScreenState extends State<OrdersScreen> {
  // 2. Add a property (Variable) of type Future.
  late Future _orderFuture;

  // 3. Add new method which return a Future.
  // 4. In this method return the result of this call to fetch and set orders.
  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  // 5. You should add initState, set the result of method to the earlier variable.
  @override
  void initState() {
    super.initState();
    _orderFuture = _obtainOrderFuture();
  }

  // If you had something (some other state you're managing or anything like that)
  // in this widget which cause build method to run again (rebuild),
  // then fetchOrder() would of course, also be executed.
  // We might want to avoid if just something else changed in this widget,
  // if there is no reason to fetch new orders.
  // You don't want to fetch new orders just because something else changed in
  // this widget, which doesn't affect the orders.
  @override
  Widget build(BuildContext context) {
    // This print statement to be sure the build method should now build one time.
    print('building orders');
    //! Don't set up the listener here for Orders data when U use the FutureBuilder
    //! Because this will continue rebuilding the entire Screen.
    // final ordersProvider = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      drawer: const AppDrawer(),
      // FutureBuilder Widget takes a future and then automatically starts listening to that.
      //! So it adds the then and the catch error method for you as developer.
      // And it takes a builder which will get the current snapshot to current state
      // of your future so that you can build different content based on what your future return.
      body: FutureBuilder(
        // 6. Set future using variable initialized in initState()
        future: _orderFuture,
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
