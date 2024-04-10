import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v_help/components/my_button.dart';
import 'package:v_help/components/my_textfield.dart';
import 'package:v_help/components/square_tile.dart';
import 'package:v_help/pages/pages_login/login_register.dart';


class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents the dialog from closing on tap
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );

  try {
    // Using FirebaseAuth to create a new user with email and password
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: usernameController.text.trim(), // Ensure email is trimmed
      password: passwordController.text,
    );

    // If the registration is successful, navigate to the login page or the main page of your app
    Navigator.pop(context); // Close the loading dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginOrRegister()), // Assume LoginPage() is your login page widget
    );
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Close the loading dialog

    // Handling errors, showing a dialog with the error message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Registration Error"),
          content: Text(e.message ?? "An unknown error occurred"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the error dialog
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    // Handle any other errors that might occur
    Navigator.pop(context); // Ensure loading dialog is closed on error
    print(e); // For debugging purposes
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset("assets/create_account.png",
                  height: 150,),
                  // const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Create account",
                          style: TextStyle(fontSize: 30, color: Colors.grey[700], fontWeight:FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: usernameController,
                    hintText: "   e-mail ID",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: "   Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                   MyTextField(
                    controller: confirmPasswordController,
                    hintText: "   Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: signUserUp,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: "assets/google.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      SquareTile(imagePath: "assets/apple.png")
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Login now?",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
