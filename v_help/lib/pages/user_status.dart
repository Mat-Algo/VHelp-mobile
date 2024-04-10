import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v_help/models/student_model.dart'; // Ensure this path is correct

class StudentInfoPage extends StatefulWidget {
  StudentInfoPage({Key? key}) : super(key: key);

  @override
  _StudentInfoPageState createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  final regnoController = TextEditingController();
  Student? studentInfo;
  bool isLoading = false;
  String errorMessage = '';

  void fetchStudentData() async {
    setState(() {
      isLoading = true; // Show a loading indicator
      errorMessage = ''; // Reset error message
    });

    try {
      var document = await FirebaseFirestore.instance
          .collection('LaundryStore')
          .where('regno', isEqualTo: regnoController.text.trim())
          .get();

      if (document.docs.isNotEmpty) {
        // Assuming regno is unique and only using the first document found
        setState(() {
          studentInfo = Student.fromFirestore(document.docs.first.data());
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No data found for this registration number.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching student data: $e";
        isLoading = false;
      });
      print("Error fetching student data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: regnoController,
                    decoration: InputDecoration(
                      labelText: "Enter Registration Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchStudentData,
                    child: Text('Fetch Info'),
                  ),
                  if (errorMessage.isNotEmpty) ...[
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                  ],
                  if (studentInfo != null) ...[
                    ListTile(
                      title: Text(studentInfo!.name),
                      subtitle: Text(
                          "Reg No: ${studentInfo!.regno}, Room No: ${studentInfo!.roomno}"),
                      trailing:
                          Text(studentInfo!.status ? "Washed" : "Not Washed"),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
