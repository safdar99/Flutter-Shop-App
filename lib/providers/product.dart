import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../providers/auth.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url =
        'https://flutter-shop-app-d12d6.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();

    final response =
        await http.put(url, body: json.encode(isFavorite));
    if (response.statusCode >= 405) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(
          'Cannot change the favortite status now please try again!');
    } else {
      throw HttpException('Favorite status updated');
    }
  }
}
