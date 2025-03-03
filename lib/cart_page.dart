import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food.dart';
import 'cart_provider.dart';
import 'bill_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                    onPressed: () async {
                      if (cartProvider.cartItems.isNotEmpty) {
                        // ✅ Get current user
                        User? user = auth.currentUser;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('⚠️ Please log in to place an order.')),
                          );
                          return;
                        }

                        // ✅ Prepare order data (includes email now!)
                        List<Map<String, dynamic>> orderItems = cartProvider.cartItems.map((food) {
                          return {
                            "name": food.name,
                            "price": food.price,
                            "image": food.path,
                          };
                        }).toList();

                        Map<String, dynamic> orderData = {
                          "userId": user.uid,
                          "email": user.email, // ✅ Email added
                          "items": orderItems,
                          "totalPrice": cartProvider.totalPrice,
                          "timestamp": FieldValue.serverTimestamp(),
                        };

                        // ✅ Store order in Firestore
                        try {
                          await firestore.collection("Orders").add(orderData);

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

                            // ✅ Show "Collect Order" message 9 sec after returning
                            Future.delayed(Duration(seconds: 9), () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('📦 Your order is ready! Please collect it from the canteen on the ground floor.'),
                                ),
                              );
                            });
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('❌ Failed to place order. Please try again.')),
                          );
                        }
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
