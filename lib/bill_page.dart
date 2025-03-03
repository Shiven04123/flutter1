import 'package:flutter/material.dart';
import 'food.dart';

class BillPage extends StatelessWidget {
  final List<Food> cartItems;
  final double totalPrice;

  BillPage({required this.cartItems, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('🧾 Your Bill', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                Divider(),
                ...cartItems.map((food) => ListTile(
                      title: Text(food.name, style: TextStyle(fontSize: 16)),
                      trailing: Text('Rs ${food.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: Rs ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // ✅ Close BillPage and return to CartPage
                    },
                    child: Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
