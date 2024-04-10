import 'package:flutter/material.dart';

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SizedBox(height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(

            child: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // MyTextField(controller:   , hintText: hintText, obscureText: obscureText)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(

            ),
          ),   
        ],
      )),
    ));
  }
}
