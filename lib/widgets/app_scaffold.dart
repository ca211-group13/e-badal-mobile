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
  final swapController = Get.find<SwapController>();

  @override
  void initState() {
    super.initState();
    // Ensure GetX is properly initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(Get.find<SwapController>());
    });
  }

  void _showValidationError(String title, String message) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        shouldIconPulse: true,
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }

  void _validateAndProceed() {
    // Trim leading zeros and check if the amount is empty or "0"
    final trimmedAmount =
        swapController.fromAmount.value.replaceAll(RegExp(r'^0+'), '');
    if (trimmedAmount.isEmpty || trimmedAmount == "0") {
      _showValidationError(
        'Invalid Amount',
        'Please enter a valid amount to proceed',
      );
      return;
    }

    swapController.setExchangeAccounts();
    if (swapController.fromAddress.isEmpty ||
        swapController.toAddress.isEmpty) {
      final missingCurrency = swapController.fromAddress.isEmpty
          ? swapController.fromCurrency.value?.name
          : swapController.toCurrency.value?.name;

      _showValidationError(
        'Missing Address',
        'Please add your $missingCurrency address to continue',
      );
      return;
    }

    Get.to(() => const PaymentProcessScreen());
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0: // Home
        Get.offNamed('/');
        break;
      case 1: // Accounts
        Get.offNamed('/');
        break;
      case 3: // Wallet
        Get.offNamed('/transactions');
        break;
      case 4: // Profile
        Get.offNamed('/profile');
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
              items: const [
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
                  icon: Icon(Icons.swap_vert_circle),
                  label: 'history',
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
                onPressed: _validateAndProceed,
                child: const Icon(Icons.swap_vert, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
