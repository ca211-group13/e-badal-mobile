import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:crypto_to_local_exchange_app/pages/components/cryptoDropdown.dart';
import 'package:get/get.dart';
import 'package:crypto_to_local_exchange_app/controllers/swapController.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentProcessScreen extends StatefulWidget {
  const PaymentProcessScreen({Key? key}) : super(key: key);

  @override
  _PaymentProcessScreenState createState() => _PaymentProcessScreenState();
}

class _PaymentProcessScreenState extends State<PaymentProcessScreen> {
  bool _copied = false;
  int activeStep = 0;
  final swapController = Get.find<SwapController>();
  final userController = Get.put(UserController());
  late double serviceFee;
  late double receiveAmount;

  @override
  void initState() {
    super.initState();
    double amount = double.tryParse(swapController.fromAmount.value) ?? 0;
    serviceFee = amount * (swapController.serviceFeePercentage.value / 100);
    receiveAmount = amount - serviceFee;
    userController.getUsersProfile().then((_) {
      swapController.setExchangeAccounts();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    Get.snackbar(
      'Success',
      'Address copied to clipboard!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
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
          onPressed: () => Get.back(),
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
    print(userController.user);
    print("what happing");
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
                    Column(
                      children: [
                        Obx(() {
                          final currency = swapController.fromCurrency.value;
                          if (currency?.svgAsset != null) {
                            if (currency?.symbol == "USDT") {
                              return Image.asset(
                                currency?.chain == "TRON"
                                    ? "assets/images/usdt-trc20.png"
                                    : "assets/images/usdt-pep20.png",
                                width: 70,
                                height: 70,
                              );
                            } else {
                              return SvgPicture.asset(
                                currency!.svgAsset!,
                                width: 60,
                                height: 60,
                              );
                            }
                          }
                          return SizedBox(width: 60, height: 60);
                        }),
                        SizedBox(height: 8),
                        Obx(() => Text(
                              swapController.fromAddress.value.isEmpty
                                  ? "No address"
                                  : swapController.fromAddress.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.arrow_forward, color: Colors.grey),
                    ),
                    Column(
                      children: [
                        Obx(() {
                          final currency = swapController.toCurrency.value;
                          if (currency?.svgAsset != null) {
                            if (currency?.symbol == "USDT") {
                              return Image.asset(
                                currency?.chain == "TRON"
                                    ? "assets/images/usdt-trc20.png"
                                    : "assets/images/usdt-pep20.png",
                                width: 70,
                                height: 70,
                              );
                            } else {
                              return SvgPicture.asset(
                                currency!.svgAsset!,
                                width: 60,
                                height: 60,
                              );
                            }
                          }
                          return SizedBox(width: 60, height: 60);
                        }),
                        SizedBox(height: 8),
                        Obx(() => Text(
                              swapController.toAddress.value.isEmpty
                                  ? "No address"
                                  : swapController.toAddress.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Amount
                Obx(() => Text(
                      "\$${swapController.fromAmount.value}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 10),

                Obx(() => Text(
                      '≈ ${swapController.toAmount.value} ${swapController.fromCurrency.value?.symbol ?? ""}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                SizedBox(height: 30),

                // QR Codes Row (TRC-20 & QR Code)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      final isLocalMoney =
                          swapController.fromCurrency.value?.symbol == 'ZAAD' ||
                              swapController.fromCurrency.value?.symbol ==
                                  'SAHAL' ||
                              swapController.fromCurrency.value?.symbol ==
                                  'EVC';

                      if (isLocalMoney) {
                        // Local Money Payment Guide
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 370,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Qaabka lacag bixinta",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "si aad ubixiso lacagta fadlan garaac *712*612544158*100#, ama riix button ka hoose",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Add USSD dialer logic here
                                      final ussdCode = Uri.parse(
                                          'tel:*712*612544158*100%23');
                                      launchUrl(ussdCode);
                                    },
                                    icon: Icon(Icons.phone),
                                    label: Text("Bixi Lacagta"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Crypto Payment UI - Dynamic for TRC-20 and BEP-20
                        final isTRC20 =
                            swapController.fromCurrency.value?.chain == 'TRON';
                        final networkType = isTRC20 ? 'TRC-20' : 'BEP-20';
                        final networkImage = isTRC20
                            ? 'assets/images/trx.png'
                            : 'assets/images/bnb.png';

                        return Row(
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
                                      networkImage,
                                      width: 130,
                                      height: 130,
                                    ),
                                  ),
                                  Text(
                                    networkType,
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
                                    child: Obx(() {
                                      // Generate QR code based on the current address
                                      return Image.asset(
                                        'assets/images/qr-code.png', // Replace with QR code generation
                                        width: 130,
                                        height: 130,
                                      );
                                    }),
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
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(height: 20),

                // Dynamic Address/Instructions Section
                Obx(() {
                  final isLocalMoney =
                      swapController.fromCurrency.value?.symbol == 'ZAAD' ||
                          swapController.fromCurrency.value?.symbol ==
                              'SAHAL' ||
                          swapController.fromCurrency.value?.symbol == 'EVC';

                  if (!isLocalMoney) {
                    final isTRC20 =
                        swapController.fromCurrency.value?.chain == 'TRON';
                    final address = isTRC20
                        ? 'TRXb...cbrE' // Replace with actual TRC20 address
                        : 'BNB0...xyz'; // Replace with actual BEP20 address

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _copyToClipboard(address),
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
                                    address,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _copied ? Icons.check_circle : Icons.copy,
                                  color:
                                      _copied ? Colors.green : Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Send USDT (${swapController.fromCurrency.value?.chain == 'TRON' ? 'TRC-20' : 'BEP-20'}) to the above address or scan the QR code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.orange),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Make sure you're sending USDT on the correct network (${swapController.fromCurrency.value?.chain == 'TRON' ? 'TRC-20' : 'BEP-20'})",
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
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
              Get.back();
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
