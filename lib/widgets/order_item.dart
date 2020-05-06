import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  const OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.orderItem.products.length * 20 + 110.0, 200) : 95,
          child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          _expanded
              ? AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: _expanded ? min(widget.orderItem.products.length * 20 + 10.0, 100) : 0,
                  child: ListView.builder(
                      itemCount: widget.orderItem.products.length,
                      itemBuilder: (ctx, index) {
                        final item = widget.orderItem.products[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${item.title}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${item.quantity}x ${item.price}',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        );
                      }),
                )
              : Container()
        ]),
      ),
    );
  }
}
