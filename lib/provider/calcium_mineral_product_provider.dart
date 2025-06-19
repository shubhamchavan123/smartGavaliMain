import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../features/ApiService/api_service.dart';
import '../features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';

class CalciumMineralProductProvider with ChangeNotifier {
  List<CalciumMineralMixtureProductListModel> _products = [];
  final Map<String, int> _quantities = {};
  String _errorMessage = "";
  bool _isLoading = false;

  // Getters
  List<CalciumMineralMixtureProductListModel> get products => _products;
  Map<String, int> get quantities => _quantities;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  final Map<String, CalciumMineralMixtureProductListModel> _cartProducts = {};
  Future<void> fetchProducts(String subCatId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://sks.sitsolutions.co.in/product_list'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List items = jsonData['details'];

        _products = items
            .map((e) => CalciumMineralMixtureProductListModel.fromJson(e))
            .where((p) => p.subcatId == subCatId && p.isdeleted == "0")
            .toList();

        print('[DEBUG] Loaded ${_products.length} products');
        print('[DEBUG] Product IDs: ${_products.map((p) => p.id).toList()}');
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      _errorMessage = "Error fetching products: $e";
      _products = [];
      print('[ERROR] fetchProducts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void increment(CalciumMineralMixtureProductListModel product) {
    _quantities[product.id] = (_quantities[product.id] ?? 0) + 1;
    _cartProducts[product.id] = product;
    _saveCartToPreferences();
    notifyListeners();
  }

  void decrement(CalciumMineralMixtureProductListModel product) {
    print('[DEBUG] Decrementing product ${product.id} (${product.name})');
    if (_quantities.containsKey(product.id) && _quantities[product.id]! > 1) {
      _quantities[product.id] = _quantities[product.id]! - 1;
    } else {
      _quantities.remove(product.id);
    }
    _saveCartToPreferences();
    print('[DEBUG] Current quantities: $_quantities');
    notifyListeners();
  }

  void removeProduct(CalciumMineralMixtureProductListModel product) {
    print('[DEBUG] Removing product ${product.id} (${product.name})');
    _quantities.remove(product.id);
    _saveCartToPreferences();
    print('[DEBUG] Current quantities: $_quantities');
    notifyListeners();
  }

  void removeAll() {
    print('[DEBUG] Clearing entire cart');
    _quantities.clear();
    _saveCartToPreferences();
    notifyListeners();
  }

  int getQuantity(CalciumMineralMixtureProductListModel product) {
    final qty = _quantities[product.id] ?? 0;
    print('[DEBUG] Getting quantity for ${product.id}: $qty');
    return qty;
  }

  List<CalciumMineralMixtureProductListModel> get selectedProducts {
    final selected = _cartProducts.entries
        .where((entry) =>
    _quantities.containsKey(entry.key) && _quantities[entry.key]! > 0)
        .map((entry) => entry.value)
        .toList();

    print('[DEBUG] Selected products:');
    selected.forEach((p) => print(' - ${p.name} : ${_quantities[p.id]}'));

    return selected;
  }

  Future<void> loadCartFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final storedQuantities = prefs.getString('cart_quantities');
    final storedProducts = prefs.getString('cart_products');

    if (storedQuantities != null) {
      final Map<String, dynamic> quantitiesMap = jsonDecode(storedQuantities);
      _quantities.clear();
      _quantities.addAll(
        quantitiesMap.map((key, value) => MapEntry(key, value as int)),
      );
    }

    if (storedProducts != null) {
      final Map<String, dynamic> productsMap = jsonDecode(storedProducts);
      _cartProducts.clear();
      productsMap.forEach((key, value) {
        _cartProducts[key] =
            CalciumMineralMixtureProductListModel.fromJson(value);
      });
    }

    print('[DEBUG] Loaded cart: $_quantities, $_cartProducts');
    notifyListeners();
  }

  Future<void> _saveCartToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cartQuantities = jsonEncode(_quantities);
    final cartProducts = jsonEncode(
      _cartProducts.map((key, value) => MapEntry(key, value.toJson())),
    );

    await prefs.setString('cart_quantities', cartQuantities);
    await prefs.setString('cart_products', cartProducts);

    print('[DEBUG] Saved cart to preferences: $cartQuantities, $cartProducts');
  }
}
