import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.color,
                      ),
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartCount,
                itemBuilder: (context, index) => CartListItem(
                  productId: cart.cartItems.keys.toList()[index],
                  cartItem: cart.cartItems.values.toList()[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// We put this into a separate widget with setState() (StatefulWidget), so we now
// only re-execute this build method instead of that entire build
// method up there (in the CartScreen) so we rebuild less which is not bad.
class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({super.key, required this.cart});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      // Disable 'Order Now' button if the cart is empty
      onPressed:
          widget.cart.cartItems.isEmpty ? null : () => addOrder(widget.cart),
      child: _isLoading
          ? const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            )
          : Text('Order Now'.toUpperCase()),
    );
  }

  Future<void> addOrder(Cart cart) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<Orders>(context, listen: false).addOrder(
        products: cart.cartItems.values.toList(),
        amount: cart.totalAmount,
      );
      cart.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    setState(() => _isLoading = false);
  }
}
