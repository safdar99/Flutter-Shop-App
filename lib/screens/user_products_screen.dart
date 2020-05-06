import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

import '../providers/products.dart';

import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, products, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: products.items.length,
                              itemBuilder: (_, index) {
                                return Column(children: [
                                  UserProductItem(
                                      products.items[index].id,
                                      products.items[index].title,
                                      products.items[index].imageUrl),
                                  Divider()
                                ]);
                              })),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
