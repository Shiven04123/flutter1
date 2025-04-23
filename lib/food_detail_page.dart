import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'home_page.dart';
import 'food.dart'; 

class FoodDetailPage extends StatelessWidget {
  final Food food;

  FoodDetailPage({required this.food});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(food.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(food.path, width: double.infinity, height: 200, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(food.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(food.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Rs ${food.price}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                cartProvider.addToCart(food);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${food.name} added to cart'),
                    duration: Duration(seconds: 1))); 
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
