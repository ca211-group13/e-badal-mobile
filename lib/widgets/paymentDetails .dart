import 'package:flutter/material.dart';

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded values
    const double youPay = 100.00;
    const double serviceFeePercentage = 2.0;
    const double serviceFee = 2.00;
    const double youReceive = 98.00;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header

          // Fee Breakdown
          _buildDetailRow(
            'You Pay',
            '\$${youPay.toStringAsFixed(2)}',
            bold: true,
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 24),
          _buildDetailRow(
            'Service Fee',
            '$serviceFeePercentage% (\$${serviceFee.toStringAsFixed(2)})',
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 24),
          _buildDetailRow(
            'You Receive',
            '\$${youReceive.toStringAsFixed(2)}',
            bold: true,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool bold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
