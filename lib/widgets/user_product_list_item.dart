import 'package:flutter/material.dart';

import '../providers/product.dart';
import '../screens/edit_product_screen.dart';

class UserProductListItem extends StatelessWidget {
  final Product product;

  const UserProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              EditProductScreen.routeName,
              arguments: product,
            ),
            icon: Icon(
              Icons.edit_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
