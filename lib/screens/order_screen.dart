import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null) {
              return Center(
                child: Text('An error has occured'),
              );
            }
            return Consumer<Orders>(builder: (context, value, child) {
              return ListView.builder(
                  itemCount: value.orders.length,
                  itemBuilder: (ctx, index) =>
                      OrderItem(value.orders[index]));
            });
          }),
      drawer: AppDrawer(),
    );
  }
}
