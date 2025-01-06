import 'package:crypto_to_local_exchange_app/pages/auth/signup/signupScreen.dart';
import 'package:crypto_to_local_exchange_app/pages/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:  CryptoSwapScreen(),
     
    );
  }
}
