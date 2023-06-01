import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;

  const CartListItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
