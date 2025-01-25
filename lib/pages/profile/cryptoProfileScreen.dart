import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
  final userController = Get.find<UserController>();
  void initState() {
    userController.getUsersProfile(); // Fetch user profile data
  }

  @override
  Widget build(BuildContext context) {
    String getFirstCarector(String name) {
      return name.substring(0, 1).toUpperCase();
    }


    return AppScaffold(
      body: SafeArea(
          child: Obx(() => userController.user.isNotEmpty
              ? SingleChildScrollView(
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
                        child: Obx(
                          () => userController.user["name"] != null
                              ? Text(
                                  getFirstCarector(userController.user["name"]),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(" "),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => Text(
                          userController.user["name"] != null
                              ? userController.user["name"]
                              : " ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          userController.user["email"] != null
                              ? userController.user["email"]
                              : " ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
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
                Obx(() {
                  final accounts = userController.user["accounts"];
                  if (accounts == null || accounts.isEmpty) {
                    return Center(
                      child: Text(
                        "No accounts found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap:
                        true, // Ensure the ListView doesn't take infinite height
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      return AccountCard(
                        icon: Icons.account_balance_wallet,
                        color: Colors.blue,
                        label: accounts[index]["type"],
                        value: accounts[index]["type"].contains("USDT")
                            ? accounts[index]["usdtAddress"]
                            : accounts[index]["phoneNumber"],
                      );
                    },
                  );
                }),
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
                    userController.logout();
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
                )
              : Center(child: CircularProgressIndicator()))),
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
        leading: label.contains("USDT")
            ? Image(
                image: AssetImage(label.contains("BEP-20")
                    ? 'assets/images/usdt-pep20.png'
                    : 'assets/images/usdt-trc20.png'),
                width: 40,
                height: 40)
            : SvgPicture.asset(
                'assets/images/${label.toLowerCase()}.svg',
                width: 40,
                height: 40,
              ),
      
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
