import 'package:flutter/material.dart';

class UpdateStatusPage extends StatelessWidget {
  final Function onUpdate;

  const UpdateStatusPage({Key? key, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Status")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await onUpdate(); // Assuming onUpdate is an asynchronous operation
            // Navigate back after updating
            Navigator.of(context).pop();
          },
          child: Text('Update Status to Washed'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green, // button color
          ),
        ),
      ),
    );
  }
}
