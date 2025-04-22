import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Food> _cartItems = [];
  final Map<Food, int> _itemQuantities = {};

  List<Food> get cartItems => _cartItems;
  Map<Food, int> get itemsWithQuantity => _itemQuantities;


  int getQuantity(Food food) => _itemQuantities[food] ?? 1;

  void addToCart(Food food) {
    if (_itemQuantities.containsKey(food)) {
      _itemQuantities[food] = _itemQuantities[food]! + 1;
    } else {
      _itemQuantities[food] = 1;
      _cartItems.add(food);
    }
    notifyListeners();
  }

  void decreaseQuantity(Food food) {
    if (_itemQuantities.containsKey(food)) {
      if (_itemQuantities[food]! > 1) {
        _itemQuantities[food] = _itemQuantities[food]! - 1;
      } else {
        removeFromCart(food);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Food food) {
    _cartItems.remove(food);
    _itemQuantities.remove(food);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _itemQuantities.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * getQuantity(item);
    }
    return total;
  }

  Future<void> placeOrder() async {
    if (_cartItems.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'email': user.email,
        'items': _cartItems.map((item) => {
          'name': item.name,
          'price': item.price,
          'quantity': getQuantity(item),
          'image': item.path,
        }).toList(),
        'totalPrice': totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
      });

      clearCart(); // Empty cart after storing in DB
    } catch (e) {
      print("Error placing order: $e");
    }
  }
}
