import 'dart:convert';
import 'package:flutter/material.dart';

class UserLaundryData extends ChangeNotifier {
  // Assume QR code includes "roomNumber" and "scheduledDate"
  String? qrDataRaw;
  Map<String, dynamic>? qrData;

  // Dummy variable for testing date scheduling
  final String dummyScheduledDate = "2024-04-08"; // Format: YYYY-MM-DD

  void updateData(String qrDataRaw) {
    this.qrDataRaw = qrDataRaw;
    qrData = json.decode(qrDataRaw);
    notifyListeners();
  }

  // Temporarily adjusted to always return true for bypassing schedule checks
  bool isScheduledForToday() {
    // final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // return qrData?['scheduledDate'] == today;
    return true; // Always returns true temporarily
  }

  String? get roomNumber => qrData?['roomNumber'];

  void clearData() {
    qrDataRaw = null;
    qrData = null;
    notifyListeners();
  }
}
