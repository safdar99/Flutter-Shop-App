import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../providers/auth.dart';

import '../models/http_exception.dart';

import '../providers/cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = []; 

  Auth authData;

  List<OrderItem> get orders {
    return [..._orders];
  }

  void updateAuthToken(Auth auth) {
    authData = auth;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    final url = 'https://flutter-shop-app-d12d6.firebaseio.com/orders/${authData.userId}.json?auth=${authData.token}';
    var productsJson = cartProducts.map((product) => product.toJson()).toList();
    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'cartProducts': productsJson,
          'dateTime': DateTime.now().toIso8601String()
        }));

    if (response.statusCode >= 400) {
      throw HttpException(
          'Could not add order due to some error, try again later...');
    }

    _orders.add(OrderItem(
        id: json.decode(response.body)['name'],
        amount: amount,
        dateTime: DateTime.now(),
        products: cartProducts));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = 'https://flutter-shop-app-d12d6.firebaseio.com/orders/${authData.userId}.json?auth=${authData.token}';
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw HttpException('Could not fetch your orders try again later...');
    }

    List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['cartProducts'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']);
          }).toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
