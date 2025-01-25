import 'package:flutter/material.dart';
import 'package:crypto_to_local_exchange_app/widgets/transactionList.dart';
import 'package:crypto_to_local_exchange_app/widgets/app_scaffold.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TransactionList(
              enableBlur: false,
              useContainer: false,
            ),
          ],
        ),
      ),
    );
  }
}
