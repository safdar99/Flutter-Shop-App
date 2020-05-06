import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _placingOrder = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      disabledColor: Colors.black12,
                      child: _placingOrder
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Order Now',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                      onPressed: cart.itemCount == 0
                          ? null
                          : () {
                              setState(() {
                                _placingOrder = true;
                              });
                              try {
                                Provider.of<Orders>(context, listen: false)
                                    .addOrder(cart.items.values.toList(),
                                        cart.totalAmount)
                                    .then((value) {
                                  setState(() {
                                    _placingOrder = false;
                                  });
                                  cart.clear();
                                });
                              } catch (error) {
                              }
                            },
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, index) {
                    return CartItem(
                      id: cart.items.values.toList()[index].id,
                      title: cart.items.values.toList()[index].title,
                      qty: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                    );
                  })),
        ],
      ),
    );
  }
}
