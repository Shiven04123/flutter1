import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Food> _cartItems = [];

  List<Food> get cartItems => _cartItems;
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);

  void addToCart(Food food) {
    _cartItems.add(food);
    notifyListeners();
  }

  void removeFromCart(Food food) {
    _cartItems.remove(food);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> placeOrder() async {
    if (_cartItems.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'items': _cartItems.map((item) => {
          'name': item.name,
          'price': item.price,
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
