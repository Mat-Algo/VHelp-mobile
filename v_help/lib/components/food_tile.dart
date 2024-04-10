import 'package:flutter/material.dart';
import 'package:v_help/models/foodItem.dart';

class FoodItemTile extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onPressed;
  final Icon icon;

  const FoodItemTile({Key? key, required this.foodItem, required this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(foodItem.name),
      subtitle: Text('${foodItem.mealType} - ${foodItem.category}'),
      trailing: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
      leading: Text('\$${foodItem.price}'),
    );
  }
}
