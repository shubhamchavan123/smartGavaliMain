import 'package:flutter/foundation.dart';

class CartItem {
  final int id;
  final String name;
  final String image;
  final String price;
  final String quantity;
  int count;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.count = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  void addToCart(CartItem product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.count++;
    } else {
      _items[product.id] = product;
    }
    notifyListeners();
  }

  void increment(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.count++;
      notifyListeners();
    }
  }

  void decrement(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.count > 1) {
        _items[productId]!.count--;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  int getQuantity(int productId) {
    return _items[productId]?.count ?? 0;
  }
}
