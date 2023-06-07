import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductListItem extends StatelessWidget {
  final Product product;

  const UserProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);
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
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .removeProduct(product.id);
              } catch (e) {
                // of(context) can't actually be resolved anymore (in Future or async)
                // It's already updating the widget there at this point of time,
                // therefore it's not sure whether a context still refers to the
                // same context it did before.
                //!  ScaffoldMessenger.of(context)
                scaffoldContext.showSnackBar(SnackBar(content: Text('$e')));
              }
            },
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
