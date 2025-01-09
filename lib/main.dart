import 'package:crypto_to_local_exchange_app/pages/auth/signup/signupScreen.dart';
import 'package:crypto_to_local_exchange_app/pages/home/home.dart';
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';
import 'package:crypto_to_local_exchange_app/pages/profile/cryptoProfileScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoExchangeApp(),
    );
  }
}
