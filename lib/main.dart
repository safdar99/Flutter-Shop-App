import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';

import './providers/auth.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';

import './screens/spalsh_screen.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, authData, previousProducts) =>
              previousProducts..updateAuthToken(authData),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (context, authData, previousOrders) =>
              previousOrders..updateAuthToken(authData),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SpalshScreen()
                          : AuthScreen()),
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTansitionBuilder(),
                TargetPlatform.iOS: CustomPageTansitionBuilder(),
              }
            ),
              primarySwatch: Colors.purple,
              accentColor: Colors.orange,
              fontFamily: 'Lato'),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
