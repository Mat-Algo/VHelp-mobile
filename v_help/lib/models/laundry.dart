// laundry_item.dart
class LaundryItem {
  final String name;
  final String imagePath;
  int count;

  LaundryItem({
    required this.name,
    required this.imagePath,
    this.count = 0,
  });
}
