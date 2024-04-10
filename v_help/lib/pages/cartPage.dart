import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_help/components/food_tile.dart';
import 'package:v_help/models/f_c_provider.dart';
import 'package:v_help/models/foodItem.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isProcessing = false;

  Future<void> payNow() async {
    setState(() => _isProcessing = true);
    final provider = Provider.of<FoodCartProvider>(context, listen: false);

    if (!provider.canMakePurchase()) {
      // Not enough credits
      setState(() => _isProcessing = false);
      _showDialog('Not enough credits', 'You do not have enough credits to complete this purchase.');
      return;
    }

    try {
      await provider.payForCart();
      _showDialog('Purchase Successful', 'Your order has been placed.');
    } catch (e) {
      _showDialog('Error', 'An error occurred while processing your purchase.');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<FoodCartProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text("Your Cart", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text("Credits: \$${cartProvider.userCredits}", style: TextStyle(fontSize: 16, color: Colors.blue)),
              Expanded(child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  FoodItem item = cartProvider.cartItems[index];
                  return FoodItemTile(
                    foodItem: item,
                    onPressed: () => cartProvider.removeItemFromCart(item),
                    icon: Icon(Icons.delete),
                  );
                },
              )),
              Text("Total Price: \$${cartProvider.totalPrice}"),
              SizedBox(height: 20),
              _isProcessing
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: payNow,
                    child: Text("Pay Now"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
