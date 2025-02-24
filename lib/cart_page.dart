import 'food.dart'; // ✅ Import Food model
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cartProvider.cartItems.isEmpty // ✅ Fixed getter error
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length, // ✅ Fixed error
                    itemBuilder: (context, index) {
                      final food = cartProvider.cartItems[index]; // ✅ Fixed error
                      return ListTile(
                        leading: Image.network(food.path, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(food.name),
                        subtitle: Text('Rs ${food.price}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            cartProvider.removeFromCart(food);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (cartProvider.cartItems.isNotEmpty) { // ✅ Fixed error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order placed successfully!')),
                        );
                        cartProvider.clearCart(); // ✅ Fixed error
                      }
                    },
                    child: Text('Place Order'),
                  ),
                ),
              ],
            ),
    );
  }
}
