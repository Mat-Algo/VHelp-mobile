import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_help/firebase_options.dart';
import 'package:v_help/models/f_c_provider.dart';
import 'package:v_help/pages/laundry_service.dart';
import 'package:v_help/pages/pages_login/login_register.dart';
import 'package:v_help/pages/user_laundry_data.dart';
    
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Use platform-specific Firebase options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserLaundryData()),
        ChangeNotifierProvider(create: (context) => LaundryService()),
        ChangeNotifierProvider(create: (context) => FoodCartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginOrRegister(),
      ),
    );
  }
}