import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:crypto_to_local_exchange_app/controllers/swapController.dart';
import 'package:flutter/material.dart';
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';
import 'package:get/get.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final bool showBackButton;
  final PreferredSizeWidget? appBar;

  const AppScaffold({
    Key? key,
    required this.body,
    this.title,
    this.showBackButton = false,
    this.appBar,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1: // Accounts
        Navigator.pushReplacementNamed(context, '/accounts');
        break;
      case 3: // Wallet
        Navigator.pushReplacementNamed(context, '/accounts');
        break;
      case 4: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: Colors.grey[100],
      body: widget.body,
      bottomNavigationBar: Stack(
        children: [
          ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'accounts',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  final swapController = Get.find<SwapController>();
                  if (swapController.fromAmount.value.isEmpty) {
                    Get.snackbar(
                      'empty', // Title
                      'Please enter an amount', // Message
                      animationDuration:
                          Duration(milliseconds: 300), // Smooth animation
                      backgroundColor: Colors.red[700], // Dark red background
                      colorText: Colors.white, // White text
                      snackPosition: SnackPosition.TOP, // Display at the top
                      borderRadius: 8, // Rounded corners
                      margin: EdgeInsets.all(16), // Margin around the Snackbar
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14), // Inner padding
                      icon: Icon(Icons.error_outline,
                          color: Colors.white), // Add an icon
                      shouldIconPulse: true, // Animate the icon
                      duration: Duration(seconds: 3), // Display duration
                    );
                    return;
                  }

                  swapController.setExchangeAccounts();
                  if (swapController.fromAddress.isEmpty ||
                      swapController.toAddress.isEmpty) {
                    Get.snackbar(
                      'missin ',
                      'Please add your ${swapController.fromAddress.isEmpty ? swapController.fromCurrency.value?.name : swapController.toCurrency.value?.name} addres',
                      animationDuration:
                          Duration(milliseconds: 300), // Smooth animation
                      backgroundColor: Colors.red[700], // Dark red background
                      colorText: Colors.white, // White text
                      snackPosition: SnackPosition.TOP, // Display at the top
                      borderRadius: 8, // Rounded corners
                      margin: EdgeInsets.all(16), // Margin around the Snackbar
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14), // Inner padding
                      icon: Icon(Icons.error_outline,
                          color: Colors.white), // Add an icon
                      shouldIconPulse: true, // Animate the icon
                      duration: Duration(seconds: 3), // Display duration
                    );
                    return;
                  }

                  Get.to(() => const PaymentProcessScreen());
                },
                child: Icon(Icons.swap_vert, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
