import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'food.dart';
import 'bill_page.dart'; // ✅ Import Bill Page

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final food = cartProvider.cartItems[index];
                      return ListTile(
                        leading: Image.network(food.path, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(food.name),
                        subtitle: Text('Rs ${food.price.toStringAsFixed(2)}'),
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
                      if (cartProvider.cartItems.isNotEmpty) {
                        double total = cartProvider.cartItems.fold(0, (sum, item) => sum + item.price);
                        
                        // ✅ Move cart items to a separate variable
                        List<Food> orderedItems = List.from(cartProvider.cartItems);
                        
                        // ✅ Navigate first, then clear the cart
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillPage(
                              cartItems: orderedItems, // ✅ Pass the copied list
                              totalPrice: total, // ✅ Pass the total price
                            ),
                          ),
                        ).then((_) => cartProvider.clearCart()); // ✅ Clears cart after returning from BillPage
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
