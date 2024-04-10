import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:v_help/components/food_tile.dart';
import 'package:v_help/models/f_c_provider.dart';
import 'package:v_help/models/foodItem.dart';
 // Ensure you have the correct import for FoodCartProvider

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Future<List<FoodItem>> fetchFoodItems() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('FoodParkAvailableMenu').get();

    return snapshot.docs.map((doc) => FoodItem(
      id: doc['id'],
      name: doc['name'],
      price: doc['price'],
      mealType: doc['mealType'],
      category: doc['category'],
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the provider
    final cartProvider = Provider.of<FoodCartProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<List<FoodItem>>(
        future: fetchFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FoodItem foodItem = snapshot.data![index];
                return FoodItemTile(
                  foodItem: foodItem,
                  onPressed: () => cartProvider.addItemToCart(foodItem,context), // Add item to cart
                  icon: Icon(Icons.add_shopping_cart),
                );
              },
            );
          } else {
            return Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}
