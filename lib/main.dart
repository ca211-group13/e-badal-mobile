import 'package:crypto_to_local_exchange_app/pages/accounts/accounts.dart';
import 'package:crypto_to_local_exchange_app/pages/auth/signin/loginScreen.dart';
import 'package:crypto_to_local_exchange_app/pages/auth/signup/signupScreen.dart';
import 'package:crypto_to_local_exchange_app/pages/home/home.dart';
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';
import 'package:crypto_to_local_exchange_app/pages/profile/cryptoProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Exchange App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/signin': (context) => const LoginScreen(),
        '/': (context) => const CryptoSwapScreen(),
        '/profile': (context) => const UserAccountPage(),
        // '/accounts': (context) => const AccountsScreen(),
        '/payment': (context) => PaymentProcessScreen(),
      },
    );
  }
}
