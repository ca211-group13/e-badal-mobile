import 'package:flutter/material.dart';
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';

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
                  Navigator.pushNamed(context, '/payment');
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
