import 'package:crypto_to_local_exchange_app/pages/accounts/accounts.dart';
import 'package:crypto_to_local_exchange_app/pages/auth/signin/loginScreen.dart';
import 'package:crypto_to_local_exchange_app/pages/auth/signup/signupScreen.dart';
import 'package:crypto_to_local_exchange_app/pages/home/home.dart';
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';
import 'package:crypto_to_local_exchange_app/pages/profile/cryptoProfileScreen.dart';
import 'package:crypto_to_local_exchange_app/middleware/auth_middleware.dart';
import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:crypto_to_local_exchange_app/pages/transactions/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  Get.put(UserController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = GetStorage();

  MyApp({super.key});

  String _getInitialRoute() {
    final token = storage.read('token');
    return (token != null && token.isNotEmpty) ? '/' : '/signin';
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Exchange App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: _getInitialRoute(),
      getPages: [
        GetPage(
          name: '/signup',
          page: () => const SignupScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/signin',
          page: () => const LoginScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/',
          page: () => const CryptoSwapScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profile',
          page: () => const UserAccountPage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/payment',
          page: () => PaymentProcessScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/transactions',
          page: () => TransactionsPage(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
