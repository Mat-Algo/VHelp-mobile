import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LaundryFormPage extends StatefulWidget {
  final String scannedData;

  const LaundryFormPage({Key? key, required this.scannedData}) : super(key: key);

  @override
  _LaundryFormPageState createState() => _LaundryFormPageState();
}

class _LaundryFormPageState extends State<LaundryFormPage> {
  int numberOfPants = 0;
  int numberOfShirts = 0;
  int numberOfBedSheets = 0;

  void _submitLaundryDetails() async {
  final userDetails = json.decode(widget.scannedData); // Decode the JSON string
  final String regno = userDetails['regno'];

  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('LaundryStore')
      .where('regno', isEqualTo: regno)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    final DocumentSnapshot doc = querySnapshot.docs.first;
    if (doc['status'] == false) {
      // If status is false, show dialog with button to change status to true
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Status'),
            content: Text('The registration number already exists with status false. Would you like to update the status to true?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text('Update'),
                onPressed: () {
                  // Update the status to true
                  FirebaseFirestore.instance.collection('LaundryStore').doc(doc.id).update({'status': true})
                      .then((value) {
                        Navigator.of(context).pop(); // Close the dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Status updated to true successfully")),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to update status: $error"), backgroundColor: Colors.red),
                        );
                      });
                },
              ),
            ],
          );
        },
      );
    } else {
      // Status is already true, proceed with the form or notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("The registration number exists with status true. You may proceed.")),
      );
    }
  } else {
    // Proceed with adding new laundry details
    FirebaseFirestore.instance.collection('LaundryStore').add({
      'name': userDetails['name'],
      'regno': regno,
      'phoneno': userDetails['phoneno'],
      'roomno': userDetails['roomno'],
      'shirts': numberOfShirts,
      'pants': numberOfPants,
      'bedsheet': numberOfBedSheets,
      'date': DateTime.now(),
      'status': true // or false, based on your logic for new entries
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Laundry details submitted successfully")),
      );
      Navigator.of(context).pop(); // Optionally navigate back or to another page
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit laundry details: $error"), backgroundColor: Colors.red),
      );
    });
  }
}




  void incrementCount(String item) {
    setState(() {
      if (item == "pants") numberOfPants++;
      else if (item == "shirts") numberOfShirts++;
      else if (item == "bedSheets") numberOfBedSheets++;
    });
  }

  void decrementCount(String item) {
    setState(() {
      if (item == "pants" && numberOfPants > 0) numberOfPants--;
      else if (item == "shirts" && numberOfShirts > 0) numberOfShirts--;
      else if (item == "bedSheets" && numberOfBedSheets > 0) numberOfBedSheets--;
    });
  }

  Widget buildCounter(String item, String label, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label, style: TextStyle(fontSize: 18)),
        SizedBox(width: 20),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => decrementCount(item),
        ),
        Text('$count', style: TextStyle(fontSize: 18)),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => incrementCount(item),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laundry Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildCounter("pants", "Number of Pants:", numberOfPants),
            buildCounter("shirts", "Number of Shirts:", numberOfShirts),
            buildCounter("bedSheets", "Number of Bed Sheets:", numberOfBedSheets),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitLaundryDetails,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
