import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:crypto_to_local_exchange_app/controllers/transactionController.dart';
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
  final swapController = Get.find<SwapController>();
  final userController = Get.find<UserController>();
  final transactionController = Get.put(TransactionControler());
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
          Obx(
            () => Container(
              height: 100,
              padding: EdgeInsets.only(top: 5, bottom: 0),
              child: EasyStepper(
                activeStep: transactionController.activeStep.value,
                showStepBorder: false,
                enableStepTapping: false,
                activeStepBackgroundColor: Colors.transparent,
                finishedStepBackgroundColor: Colors.transparent,
                internalPadding: 25,
                showLoadingAnimation: false,
                stepRadius: 18,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                activeStepTextColor: Colors.orange,
                finishedStepTextColor: Colors.black87,
                defaultStepBorderType: BorderType.normal,
                steps: [
                  EasyStep(
                    customStep: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: transactionController.activeStep.value >= 0
                            ? Colors.orange
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.payment,
                        color: transactionController.activeStep.value >= 0
                            ? Colors.white
                            : Colors.grey.shade500,
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
                        color: transactionController.activeStep.value >= 1
                            ? Colors.orange
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.rate_review,
                        color: transactionController.activeStep.value >= 1
                            ? Colors.white
                            : Colors.grey.shade500,
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
                        color: transactionController.activeStep.value >= 2
                            ? Colors.orange
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: transactionController.activeStep.value >= 2
                            ? Colors.white
                            : Colors.grey.shade500,
                        size: 20,
                      ),
                    ),
                    title: 'Complete',
                  ),
                ],
                onStepReached: (index) =>
                    transactionController.activeStep.value = index,
              ),
            ),
          ),
          Expanded(
              child: Obx(() =>
                  _buildStepContent(transactionController.activeStep.value)))
        ],
      ),
    );
  }

  Widget PaymentGuide() {
    print(userController.user);
    print(userController.pendingTransaction);
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
                                  : swapController.formatAddress(
                                      swapController.fromAddress.value),
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
                                  : swapController.formatAddress(
                                      swapController.toAddress.value),
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
                          swapController.fromCurrency.value?.symbol == 'Zaad' ||
                              swapController.fromCurrency.value?.symbol ==
                                  'Sahal' ||
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
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Bixi Lacagta",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
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
                                    child:
                                        // Generate QR code based on the current address
                                        Image.asset(
                                      'assets/images/qr-code.png', // Replace with QR code generation
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
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(height: 20),

                // Dynamic Address/Instructions Section
                Obx(() {
                  final isLocalMoney =
                      swapController.fromCurrency.value?.symbol == 'Zaad' ||
                          swapController.fromCurrency.value?.symbol ==
                              'Sahal' ||
                          swapController.fromCurrency.value?.symbol == 'EVC';

                  if (!isLocalMoney) {
                    final isTRC20 =
                        swapController.fromCurrency.value?.chain == 'TRON';
                    final address = isTRC20
                        ? 'TRXb5btFMrUcp6Srnk47rVpfTsscYTcbrE' // Replace with actual TRC20 address
                        : '0xFf5cFcE49b63c0a26cf49e13d7106D07719dCBcE'; // Replace with actual BEP20 address

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
              onPressed: () async {
                try {
                  // Show loading indicator
                  transactionController.isLoading.value = true;

                  // Create transaction
                  await transactionController.createTransaction();
                  userController.startProfileRefetching();
                } catch (e) {
                  // Error is already handled in the controller
                } finally {
                  // Hide loading indicator
                  transactionController.isLoading.value = false;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(
                () => transactionController.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
        ),
      ],
    );
  }

  Widget ReviewStep() {
    userController.startProfileRefetching();
    return Obx(() {
      // Show loading state while fetching transaction details
      if (userController.pendingTransaction.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              SizedBox(height: 16),
              Text(
                "Fetching transaction details...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      // Show message if no pending transaction
      if (!userController.pendingTransaction["isTherePendingTransaction"]) {
        // Schedule the state update for after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (userController.lastTransactionStatus.value == "failed") {
            transactionController.activeStep.value = 2;
          } else if (userController.lastTransactionStatus.value ==
              "completed") {
            transactionController.activeStep.value = 2;
          }
        });

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                "No pending transaction found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      // Show transaction details
      final transaction =
          userController.pendingTransaction["lastPendingTransaction"];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Waiting for Confirmation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please wait while we confirm your transaction',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTransactionDetail(
                          'Status',
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Pending',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        _buildTransactionDetail(
                          'Transaction ID',
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  userController.pendingTransaction[
                                          "lastPendingTransaction"]["_id"]
                                      .substring(
                                          0, 6), // Placeholder transaction ID
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.copy_outlined,
                                  size: 18, color: Colors.grey),
                            ],
                          ),
                        ),
                        _buildTransactionDetail(
                          'Amount',
                          Obx(() {
                            return (Text(
                              "\$${userController.pendingTransaction["lastPendingTransaction"]["amount"].toString()}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                          }),
                        ),
                        _buildTransactionDetail(
                          'Services Fee',
                          Text(
                            '\$${serviceFee.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildTransactionDetail(
                          'Type',
                          Row(
                            children: [
                              Container(
                                  width: 24,
                                  height: 24,
                                  child: Obx(
                                    () => Image.asset(
                                      userController.pendingTransaction[
                                                      "lastPendingTransaction"]
                                                      ["type"]
                                                  .split(" ")[0] ==
                                              "USDT"
                                          ? 'assets/images/usdt-pep20.png'
                                          : 'assets/images/evc.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                  )),
                              SizedBox(width: 8),
                              Obx(() {
                                return (Text(
                                  "${userController.pendingTransaction["lastPendingTransaction"]["type"].toString()}",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ));
                              }),
                            ],
                          ),
                        ),
                        _buildTransactionDetail(
                          'Local Phone',
                          Obx(() {
                            return (Text(
                              "${userController.pendingTransaction["lastPendingTransaction"]["localPhoneNumber"].toString()}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                          }),
                        ),
                        _buildTransactionDetail(
                          'USDT Address',
                          Obx(() {
                            return (Text(
                              swapController.formatAddress(
                                  userController.pendingTransaction[
                                      "lastPendingTransaction"]["usdtAddress"]),
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                          }),
                        ),
                        _buildTransactionDetail(
                          'Date',
                          Obx(() {
                            return (Text(
                              "${userController.pendingTransaction["lastPendingTransaction"]["createdAt"].split("T")[0]}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                          }),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.message, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Having issues?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "If you're experiencing any problems, please contact our support",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your transaction is being processed. This may take a few minutes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTransactionDetail(String label, Widget value,
      {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
              value,
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  Widget CompleteStep() {
    userController.stopRefetching();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Icon(
                      userController.lastTransactionStatus.value == "failed"
                          ? Icons.cancel_rounded
                          : Icons.check_circle_rounded,
                      size: 80,
                      color:
                          userController.lastTransactionStatus.value == "failed"
                              ? Colors.red
                              : Colors.green,
                    )),
                SizedBox(height: 20),
                Obx(() => Text(
                      userController.lastTransactionStatus.value == "failed"
                          ? 'Transaction Failed'
                          : 'Transaction Successful',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 10),
                Obx(() => Text(
                      userController.lastTransactionStatus.value == "failed"
                          ? "We're sorry, but your transaction couldn't be completed.\nPlease try again or contact support for assistance."
                          : "We sent your money. Please check your account. Thank you!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    )),
                SizedBox(height: 30),
                // Need help section
                Text(
                  userController.lastTransactionStatus.value == "failed"
                      ? "Need help ?"
                      : "Didn't receive your money?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    // Add WhatsApp contact functionality
                    final whatsappUrl =
                        Uri.parse('https://wa.me/your_number_here');
                    launchUrl(whatsappUrl);
                  },
                  icon: SvgPicture.asset("assets/images/whatsapp.svg",
                      width: 24, height: 24),
                  label: Text(
                    'Contact us on WhatsApp',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              if (userController.lastTransactionStatus.value == "failed")
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Reset to first step
                      transactionController.activeStep.value = 0;
                      transactionController.fetchTransactionHistory();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Try Again",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (userController.lastTransactionStatus.value == "failed")
                SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    transactionController.activeStep.value = 0;
                    if (userController.lastTransactionStatus.value ==
                        "failed") {
                      Get.back();
                    } else {
                      Get.offNamed('/transactions');
                    }
                    transactionController.fetchTransactionHistory();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        userController.lastTransactionStatus.value == "failed"
                            ? Colors.grey[300]
                            : Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    userController.lastTransactionStatus.value == "failed"
                        ? "Close"
                        : "View Transaction",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          userController.lastTransactionStatus.value == "failed"
                              ? Colors.black87
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
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
