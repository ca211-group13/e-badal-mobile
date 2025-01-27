import 'package:crypto_to_local_exchange_app/controllers/transactionController.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE HH:mm').format(date);
    } else {
      return DateFormat('MMM d, y HH:mm').format(date);
    }
  }

  Widget _buildContent() {
    return Column(
      children: [
        if (widget.useContainer) 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.enableBlur)
                  GestureDetector(
                    onTap: _toggleBlur,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isBlurred ? Icons.visibility_off : Icons.remove_red_eye,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 4),
                          Text(
                            _isBlurred ? 'Show' : 'Hide',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: Obx(() {
            if (transactionController.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading transactions...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            if (transactionController.transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your transaction history will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            final transactions = widget.limit != null
                ? transactionController.transactions.take(widget.limit!).toList()
                : transactionController.transactions;
                
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    // Get the transaction type (USDT to EVC or EVC to USDT)
    String getTransactionTypeImage() {
      final type = transaction['type'].toString().toLowerCase();
      if (type.contains('usdt')) {
        if (type.startsWith('usdt')) {
          return 'assets/images/usdt-pep20.png';
        } else {
          return 'assets/images/evc.png';
        }
      }
      return 'assets/images/usdt-pep20.png';
    }

    // Get status color and icon
    Color getStatusColor() {
      final status = transaction['status'].toString().toLowerCase();
      switch (status) {
        case 'completed':
        case 'success':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'failed':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    IconData getStatusIcon() {
      final status = transaction['status'].toString().toLowerCase();
      switch (status) {
        case 'completed':
        case 'success':
          return Icons.check_circle;
        case 'pending':
          return Icons.access_time;
        case 'failed':
          return Icons.error;
        default:
          return Icons.help;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Show transaction details in a bottom sheet
            Get.bottomSheet(
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildDetailRow('Type', transaction['type']),
                    _buildDetailRow('Amount', '\$${transaction['amount']}'),
                    _buildDetailRow('Status', transaction['status']),
                    _buildDetailRow('Date', _formatDate(transaction['createdAt'])),
                    if (transaction['localPhoneNumber'] != null)
                      _buildDetailRow('Phone', transaction['localPhoneNumber']),
                    if (transaction['usdtAddress'] != null)
                      _buildDetailRow('USDT Address', transaction['usdtAddress']),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    getTransactionTypeImage(),
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              transaction['type'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${transaction['amount']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            getStatusIcon(),
                            size: 14,
                            color: getStatusColor(),
                          ),
                          SizedBox(width: 4),
                          Text(
                            transaction['status'].toString().toUpperCase(),
                            style: TextStyle(
                              color: getStatusColor(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' • ${_formatDate(transaction['createdAt'])}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
