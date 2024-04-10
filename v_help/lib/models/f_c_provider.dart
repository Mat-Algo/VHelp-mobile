import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v_help/models/foodItem.dart';
import 'dart:math'; // For generating tokens or unique identifiers

class FoodCartProvider with ChangeNotifier {
  List<FoodItem> _cartItems = [];
  int _userCredits = 1000; // Initial user credits, adjust as needed

  List<FoodItem> get cartItems => _cartItems;
  int get userCredits => _userCredits;

  bool canMakePurchase() => _userCredits >= totalPrice;

  void deductCredits(int amount) {
    _userCredits -= amount;
    notifyListeners();
  }

  int get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);

  Future<void> payForCart() async {
  if (!canMakePurchase() || _cartItems.isEmpty) return;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference orders = firestore.collection('orders');

  // Generate a unique order ID for this cart session
  var orderId = Random().nextInt(999999).toString();
  // Simplified token generation for the entire order
  var token = "$orderId-${Random().nextInt(999999)}";

  // Create a list of maps representing each item in the cart
  List<Map<String, dynamic>> cartItemsData = _cartItems.map((item) => {
    'id': item.id,
    'name': item.name,
    'price': item.price,
    'mealType': item.mealType,
    'category': item.category,
  }).toList();

  // Add a single document for the cart session with all items as an array
  await orders.doc(orderId).set({
    'orderId': orderId,
    'token': token,
    'items': cartItemsData, // Cart items as an array
    'totalPrice': totalPrice,
    'timestamp': FieldValue.serverTimestamp(), // Optional: add server timestamp
  });

  deductCredits(totalPrice);
  _cartItems.clear(); // Clear cart items after payment
  notifyListeners();
}


  void addItemToCart(FoodItem item, BuildContext context) {
  int index = _cartItems.indexWhere((element) => element.id == item.id);
  if(index == -1) {
    _cartItems.add(item);
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item.name} added to cart"),
        duration: Duration(milliseconds: 500), // Display for half a second
      ),
    );
  }
}


  void removeItemFromCart(FoodItem item) {
    _cartItems.removeWhere((element) => element.id == item.id);
    notifyListeners();
  }
}
