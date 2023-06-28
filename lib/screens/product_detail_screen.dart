import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'productDetail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false)
        .getProductById(id: productId);
    return Scaffold(
      // We don't set up an appBar anymore because instead, we will now manually
      // animate a widget from our body into the appBar over time.
      body: CustomScrollView(
        // 1. The fist step it that you replace you SingleChildScrollView here
        // with a CustomScrollView because you need more control over how scrolling
        // is handled because different things will now be scrolling or we need
        // to do different things when we scroll, we need to change that images
        // into the app bar.
        //* Slivers are just scrollable areas on the screen.
        slivers: [
          // For The SliverAppBar, that's the thing which should dynamically
          // change into the app bar, for that you need to configure it.
          SliverAppBar(
            // You five it an expandedHeight which is the height that should have
            // if it's not the app bar but the image.
            expandedHeight: 300,
            //* I'll set pinned to true which means that the app bar will always
            //* be visible when we scroll, it will not scroll out of view but
            //* instead it will simply change to an app bar and then stick at top.
            //* and the rest of the content can scroll beneath that.
            pinned: true,
            // We need to define the flexibleSpace property, and that's in the end
            // what should be inside of that app bar.
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              // That's the part which you'll not always see, that's the part which
              // you'll see if this (AppBar) is expanded. Here, I want to have my image.
              // So it's where we use this Hero Widget with the image inside of it.
              // Because that is what should be visible if this app bar is expanded.
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '\$${product.price}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                product.description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 700),
            ]),
          ),
        ],
      ),
    );
  }
}
