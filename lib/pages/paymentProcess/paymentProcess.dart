import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_stepper/easy_stepper.dart';

class PaymentProcessScreen extends StatefulWidget {
  @override
  _PaymentProcessScreenState createState() => _PaymentProcessScreenState();
}

class _PaymentProcessScreenState extends State<PaymentProcessScreen> {
  bool _copied = false;
  int activeStep = 0;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Address copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return PaymentGuide();
      case 1:
        return ReviewStep();
      case 2:
        return CompleteStep();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Guide',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.only(top: 5, bottom: 0),
            child: EasyStepper(
              activeStep: activeStep,
              showStepBorder: false,
              enableStepTapping: false,
              activeStepBackgroundColor: Colors.transparent,
              finishedStepBackgroundColor: Colors.transparent,
              internalPadding: 25,
              showLoadingAnimation: false,
              stepRadius: 18,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              activeStepTextColor: Colors.orange,
              finishedStepTextColor: Colors.black87,
              defaultStepBorderType: BorderType.normal,
              steps: [
                EasyStep(
                  customStep: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: activeStep >= 0
                          ? Colors.orange
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.payment,
                      color:
                          activeStep >= 0 ? Colors.white : Colors.grey.shade500,
                      size: 20,
                    ),
                  ),
                  title: 'Payment',
                ),
                EasyStep(
                  customStep: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: activeStep >= 1
                          ? Colors.orange
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.rate_review,
                      color:
                          activeStep >= 1 ? Colors.white : Colors.grey.shade500,
                      size: 20,
                    ),
                  ),
                  title: 'Review',
                ),
                EasyStep(
                  customStep: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: activeStep >= 2
                          ? Colors.orange
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color:
                          activeStep >= 2 ? Colors.white : Colors.grey.shade500,
                      size: 20,
                    ),
                  ),
                  title: 'Complete',
                ),
              ],
              onStepReached: (index) => setState(() => activeStep = index),
            ),
          ),
          Expanded(child: _buildStepContent(activeStep))
        ],
      ),
    );
  }

  Widget PaymentGuide() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Currency Exchange Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCurrencyIcon(
                      "T",
                      "TRXb...cbrE",
                      Colors.green,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.arrow_forward, color: Colors.grey),
                    ),
                    _buildCurrencyIcon(
                      "EVC+",
                      "617890989",
                      Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Amount
                Text(
                  "\$100",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                Text('≈ 100 USDT',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 30),

                // QR Codes Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/trx.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                          Text(
                            "TRC-20",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 20),

                    // QR Code Image
                    Container(
                      width: 175,
                      height: 175,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/qr-code.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "SCAN",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => _copyToClipboard('TRXb...cbrE'),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'TRXb...cbrE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Icon(
                          _copied ? Icons.check_circle : Icons.copy,
                          color: _copied ? Colors.green : Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Instructions Text
                Text(
                  "Send the USDT to the above address or scan the QR code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom Button
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (activeStep < 2) activeStep++;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Confirm",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ReviewStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review_outlined,
                    size: 80, color: Colors.orange),
                SizedBox(height: 20),
                Text(
                  'Review Your Payment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please review your payment details before proceeding',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (activeStep < 2) activeStep++;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Proceed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget CompleteStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                SizedBox(height: 20),
                Text(
                  'Payment Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your payment has been processed successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Done",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressStep(String number, String title, bool isActive) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.orange : Colors.grey[200],
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.orange : Colors.grey[600],
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      width: 50,
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: isActive ? Colors.orange : Colors.grey[300],
    );
  }

  Widget _buildCurrencyIcon(String symbol, String address, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              symbol,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          address,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
