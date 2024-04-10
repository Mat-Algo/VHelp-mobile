class MessEntry {
  final String mess;
  final String messtype;
  final String name;
  final String regno;

  MessEntry({required this.mess, required this.messtype, required this.name, required this.regno});

  factory MessEntry.fromJson(Map<String, dynamic> json) {
    return MessEntry(
      mess: json['mess'],
      messtype: json['messtype'],
      name: json['name'],
      regno: json['regno'],
    );
  }
}
