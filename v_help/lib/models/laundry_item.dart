// laundry_item_tile.dart
import 'package:flutter/material.dart';
import 'package:v_help/models/laundry.dart';


class LaundryItemTile extends StatelessWidget {
  final LaundryItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  LaundryItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(item.imagePath, width: 50),
          Text(item.name, style: TextStyle(fontSize: 18)),
          Text('${item.count}', style: TextStyle(fontSize: 18)),
          IconButton(icon: Icon(Icons.remove), onPressed: onDecrement),
          IconButton(icon: Icon(Icons.add), onPressed: onIncrement),
        ],
      ),
    );
  }
}
