// laundry_service.dart
import 'package:flutter/material.dart';
import 'package:v_help/models/laundry.dart';

class LaundryService extends ChangeNotifier {
  final List<LaundryItem> _items = [
    LaundryItem(name: 'Pants', imagePath: 'assets/pants.png'),
    LaundryItem(name: 'Shirts', imagePath: 'assets/shirts.png'),
    LaundryItem(name: 'Bed Sheets', imagePath: 'assets/bed_sheets.png'),
  ];

  List<LaundryItem> get items => _items;

  void incrementItem(String itemName) {
    final item = _items.firstWhere((item) => item.name == itemName);
    item.count++;
    notifyListeners();
  }

  void decrementItem(String itemName) {
    // Attempt to find the item in the list
    final itemIndex = _items.indexWhere((item) => item.name == itemName);
    // Check if the item was found
    if (itemIndex != -1) {
      final item = _items[itemIndex];
      if (item.count > 0) {
        item.count--;
        notifyListeners();
      }
    }
  }
}
