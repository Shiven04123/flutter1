import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food.dart';
import 'cart_provider.dart';
import 'bill_page.dart';

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
                      if (cartProvider.cartItems.isNotEmpty) {
                        // ✅ Show "Order Placed" message BEFORE navigating
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('🎉 Order successfully placed!')),
                        );

                        // ✅ Navigate to BillPage FIRST
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillPage(
                              cartItems: List.from(cartProvider.cartItems),
                              totalPrice: cartProvider.totalPrice,
                            ),
                          ),
                        ).then((_) {
                          // ✅ Clear cart AFTER returning from BillPage
                          cartProvider.clearCart();

                          // ✅ Show "Collect Order" message 15 sec after returning
                          Future.delayed(Duration(seconds: 9), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('📦 Your order is ready! Please collect it from the canteen on the ground floor.'),
                              ),
                            );
                          });
                        });
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
