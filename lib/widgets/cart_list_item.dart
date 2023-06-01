import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final CartItem cartItem;

  const CartListItem({
    super.key,
    required this.productId,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeCartItem(productId),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 8,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                ),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Price: \$${cartItem.price}'),
          trailing: Text('${cartItem.quantity} x'),
        ),
      ),
    );
  }
}
