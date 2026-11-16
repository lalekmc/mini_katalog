import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductService {
  static const String _path = 'assets/data/products.json';

  Future<List<Product>> fetchProducts() async {
    final raw = await rootBundle.loadString(_path);
    return parseProducts(raw);
  }

  static List<Product> parseProducts(String raw) {
    final data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
