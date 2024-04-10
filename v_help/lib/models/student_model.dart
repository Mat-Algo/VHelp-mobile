class Student {
  final String name;
  final String regno;
  final int roomno;
  final bool status;

  Student({required this.name, required this.regno, required this.roomno, required this.status});

  factory Student.fromFirestore(Map<String, dynamic> firestore) {
    return Student(
      name: firestore['name'] ?? '',
      regno: firestore['regno'] ?? '',
      roomno: firestore['roomno'] ?? '',
      status: firestore['status'] ?? false,
    );
  }
}
