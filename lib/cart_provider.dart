import 'package:flutter/material.dart';
import 'food.dart'; // ✅ Import Food model

class CartProvider extends ChangeNotifier {
  final List<Food> _cartItems = []; // ✅ Store added items

  List<Food> get cartItems => _cartItems; // ✅ Get cart items

  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price); // ✅ Calculate total price

  void addToCart(Food food) {
    _cartItems.add(food);
    notifyListeners(); // ✅ Notify UI to update
  }

  void removeFromCart(Food food) {
    _cartItems.remove(food);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear(); // ✅ Clear cart after order
    notifyListeners();
  }
}
