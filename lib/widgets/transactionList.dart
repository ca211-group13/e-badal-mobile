import 'package:crypto_to_local_exchange_app/controllers/transactionController.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TransactionList extends StatefulWidget {
  final int? limit;
  final bool enableBlur;
  final bool useContainer;
  
  const TransactionList({
    Key? key, 
    this.limit,
    this.enableBlur = false,
    this.useContainer = true,
  }) : super(key: key);
  
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool _isBlurred = true;
  final transactionController = Get.put(TransactionControler());

  @override
  void initState() {
    super.initState();
    transactionController.fetchTransactionHistory();
  }

  void _toggleBlur() {
    if (widget.enableBlur) {
      setState(() {
        _isBlurred = !_isBlurred;
      });
    }
  }

  Widget _buildContent() {
    return Column(
      children: [
        if (widget.useContainer) 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.enableBlur)
                GestureDetector(
                  onTap: _toggleBlur,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(_isBlurred
                        ? Icons.visibility_off
                        : Icons.remove_red_eye),
                  ),
                )
            ],
          ),
        Expanded(
          child: Obx(() {
            if (transactionController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            
            final transactions = widget.limit != null
                ? transactionController.transactions.take(widget.limit!).toList()
                : transactionController.transactions;
                
            return ListView.builder(
              padding: EdgeInsets.all(widget.useContainer ? 16 : 0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return widget.enableBlur && _isBlurred
                    ? Blur(
                        blur: 8,
                        colorOpacity: 0.1,
                        child: _buildTransactionItem(transaction))
                    : _buildTransactionItem(transaction);
              },
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.useContainer) {
      return Expanded(child: _buildContent());
    }

    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    IconData getTransactionIcon() {
      switch (transaction['type'].toString().toLowerCase()) {
        case 'deposit':
          return Icons.arrow_downward;
        case 'withdrawal':
          return Icons.arrow_upward;
        default:
          return Icons.swap_horiz;
      }
    }

    Color getTransactionColor() {
      switch (transaction['type'].toString().toLowerCase()) {
        case 'deposit':
          return Colors.green;
        case 'withdrawal':
          return Colors.red;
        default:
          return Colors.blue;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: getTransactionColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  getTransactionIcon(),
                  color: getTransactionColor(),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['type'].toString().toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateTime.parse(transaction['createdAt']).toString().substring(0, 16),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '\$${transaction['amount']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: getTransactionColor(),
            ),
          ),
        ],
      ),
    );
  }
}
