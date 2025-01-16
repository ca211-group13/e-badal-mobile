import 'package:flutter/material.dart';
import '../accounts/accounts.dart';
import 'package:crypto_to_local_exchange_app/widgets/app_scaffold.dart';

class CryptoExchangeApp extends StatelessWidget {
  const CryptoExchangeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserAccountPage(),
    );
  }
}

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({Key? key}) : super(key: key);

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.orange,
                        child: const Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'abdinajiib mohamed hassan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'naji@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Accounts Section
                const Text(
                  'Your Accounts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                AccountCard(
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                  label: 'USDT (TRC-20)',
                  value: 'TRXb...cbrE',
                ),
                const SizedBox(height: 12),
                AccountCard(
                  icon: Icons.phone_android,
                  color: Colors.blue,
                  label: 'EVC',
                  value: '612544158',
                ),
                const SizedBox(height: 32),

                // Options
                ListTile(
                  leading: const Icon(Icons.add_circle_outline),
                  title: const Text('Add or Edit Account'),
                  onTap: () {
                    AddAccountDialog.show(
                      context,
                      onAccountAdded: (accountType, value) {
                        setState(() {
                          // Add or update the account
                        });
                      },
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                  onTap: () {
                    // Sign out action
                  },
                ),

                // Footer
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Contact on WhatsApp action
                        },
                        child: const Text('Contact us on WhatsApp'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to website
                        },
                        child: const Text('Website'),
                      ),
                    ],
                  ),
                ),
                // Add extra padding at the bottom to ensure content is scrollable above keyboard
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const AccountCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
