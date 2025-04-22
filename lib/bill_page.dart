import 'package:flutter/material.dart';
import 'food.dart';

class BillPage extends StatelessWidget {
  final Map<Food, int> itemsWithQuantity;
  final double totalPrice;

  BillPage({
    required this.itemsWithQuantity,
    required this.totalPrice,
  });

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
                ...itemsWithQuantity.entries.map((entry) {
                  final food = entry.key;
                  final quantity = entry.value;
                  final subtotal = food.price * quantity;

                  return ListTile(
                    title: Text('${food.name} x$quantity', style: TextStyle(fontSize: 16)),
                    trailing: Text(
                      'Rs ${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
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
                      Navigator.pop(context);
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
