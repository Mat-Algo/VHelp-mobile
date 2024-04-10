import 'package:flutter/material.dart';
import 'package:v_help/pages/pages_login/login_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginOrRegister()
    );
  }
}