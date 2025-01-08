import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:flutter/widgets.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool _isBlurred = true;

  void _toggleBlur() {
    setState(() {
      _isBlurred = !_isBlurred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
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
              GestureDetector(
                onTap: _toggleBlur,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                      _isBlurred ? Icons.visibility_off : Icons.remove_red_eye),
                ),
              )
              // TextButton(
              //   onPressed: _toggleBlur,
              //   child: Text(
              //     _isBlurred ? "Show" : "Hide",
              //     style: TextStyle(
              //       color: Colors.blue,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 2,
              itemBuilder: (context, index) {
                return _isBlurred
                    ? Blur(
                        blur: 8,
                        colorOpacity: 0.1,
                        child: _buildTransactionItem())
                    : _buildTransactionItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem() {
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
              CircleAvatar(
                backgroundColor: Colors.yellow,
                child: Text(
                  "B",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BNB TO USDT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "PENDING",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _isBlurred
              ? Blur(
                  blur: 8,
                  colorOpacity: 0.1,
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    "\$200",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : Text(
                  "\$200",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }
}
