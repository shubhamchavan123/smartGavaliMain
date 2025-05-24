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
  final Map<String, int> _quantities = {}; // {productId: quantity}
  String _errorMessage = "";
  bool _isLoading = false;

  List<CalciumMineralMixtureProductListModel> get products => _products;
  Map<String, int> get quantities => _quantities;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProducts(String subCatId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
          ApiService.productListUrl,
        // Uri.parse('https://sks.sitsolutions.co.in/product_list'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List items = jsonData['details'];

        _products = items
            .map((e) => CalciumMineralMixtureProductListModel.fromJson(e))
            .where((p) => p.subcatId == subCatId && p.isdeleted == "0")
            .toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      _errorMessage = "Error fetching products: $e";
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void increment(CalciumMineralMixtureProductListModel product) {
    _quantities[product.id] = (_quantities[product.id] ?? 0) + 1;
    _saveCartToPreferences();
    notifyListeners();
  }

  void decrement(CalciumMineralMixtureProductListModel product) {
    if (_quantities.containsKey(product.id) && _quantities[product.id]! > 1) {
      _quantities[product.id] = _quantities[product.id]! - 1;
    } else {
      _quantities.remove(product.id);
    }
    _saveCartToPreferences();
    notifyListeners();
  }

  void removeProduct(CalciumMineralMixtureProductListModel product) {
    _quantities.remove(product.id);
    _saveCartToPreferences();
    notifyListeners();
  }

  void removeAll() {
    _quantities.clear();
    _saveCartToPreferences();
    notifyListeners();
  }

  int getQuantity(CalciumMineralMixtureProductListModel product) {
    return _quantities[product.id] ?? 0;
  }

  List<CalciumMineralMixtureProductListModel> get selectedProducts {
    return _products
        .where((product) => _quantities.containsKey(product.id) && _quantities[product.id]! > 0)
        .toList();
  }

  // Load cart data from SharedPreferences
  Future<void> loadCartFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load stored quantities (if any)
    final storedQuantities = prefs.getString('cart_quantities');
    if (storedQuantities != null) {
      final Map<String, dynamic> quantitiesMap = jsonDecode(storedQuantities);
      _quantities.clear();
      _quantities.addAll(quantitiesMap.map((key, value) => MapEntry(key, value as int)));
      notifyListeners();
    }
  }

  // Save cart data to SharedPreferences
  Future<void> _saveCartToPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert quantities map to a JSON string and store it
    final cartData = jsonEncode(_quantities);
    await prefs.setString('cart_quantities', cartData);
  }
}

// class CalciumMineralProductProvider with ChangeNotifier {
//   List<CalciumMineralMixtureProductListModel> _products = [];
//   final Map<String, int> _quantities = {}; // {productId: quantity}
//
//   bool _isLoading = false;
//
//   List<CalciumMineralMixtureProductListModel> get products => _products;
//   Map<String, int> get quantities => _quantities;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchProducts(String subCatId) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await http.get(
//         Uri.parse('https://sks.sitsolutions.co.in/product_list'),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         final List items = jsonData['details'];
//
//         _products = items
//             .map((e) => CalciumMineralMixtureProductListModel.fromJson(e))
//             .where((p) => p.subcatId == subCatId && p.isdeleted == "0")
//             .toList();
//       } else {
//         throw Exception("Failed to load products");
//       }
//     } catch (e) {
//       print("Error fetching products: $e");
//       _products = [];
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   void increment(CalciumMineralMixtureProductListModel product) {
//     _quantities.update(product.id, (existing) => existing + 1,
//         ifAbsent: () => 1);
//     notifyListeners();
//   }
//
//   void decrement(CalciumMineralMixtureProductListModel product) {
//     if (_quantities.containsKey(product.id)) {
//       if (_quantities[product.id]! > 1) {
//         _quantities[product.id] = _quantities[product.id]! - 1;
//       } else {
//         _quantities.remove(product.id);
//       }
//       notifyListeners();
//     }
//   }
//
//   void removeProduct(CalciumMineralMixtureProductListModel product) {
//     _quantities.remove(product.id);
//     notifyListeners();
//   }
//
//   void removeAll() {
//     _quantities.clear();
//     notifyListeners();
//   }
//
//   int getQuantity(CalciumMineralMixtureProductListModel product) {
//     return _quantities[product.id] ?? 0;
//   }
//
//   List<CalciumMineralMixtureProductListModel> get selectedProducts {
//     return _products.where((p) => _quantities.containsKey(p.id)).toList();
//   }
// }
