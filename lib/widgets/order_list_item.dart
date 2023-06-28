import 'dart:math';

import 'package:flutter/material.dart';

import '../models/order.dart';

class OrderListItem extends StatefulWidget {
  final Order order;

  const OrderListItem({super.key, required this.order});

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(formateOrderDateTime(widget.order)),
            trailing: IconButton(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              icon: Icon(
                _isExpanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(16),
            height: _isExpanded
                ? min(widget.order.products.length * 32 + 16, 128)
                : 0,
            child: ListView.builder(
              itemCount: widget.order.products.length,
              itemBuilder: (context, index) {
                final product = widget.order.products[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${product.quantity}x \$${product.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formateOrderDateTime(Order order) =>
      '${order.dateTime.day}/${order.dateTime.month}/${order.dateTime.year} ${order.dateTime.hour}:${order.dateTime.minute}';
}
