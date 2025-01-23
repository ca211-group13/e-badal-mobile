// crypto_swap_screen.dart
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';
import 'package:crypto_to_local_exchange_app/widgets/paymentDetails%20.dart';
import 'package:crypto_to_local_exchange_app/widgets/transactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crypto_to_local_exchange_app/pages/components/cryptoDropdown.dart';
import 'package:crypto_to_local_exchange_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';
import 'package:crypto_to_local_exchange_app/controllers/swapController.dart';

class CryptoSwapScreen extends StatefulWidget {
  const CryptoSwapScreen({Key? key}) : super(key: key);

  @override
  _CryptoSwapScreenState createState() => _CryptoSwapScreenState();
}

class _CryptoSwapScreenState extends State<CryptoSwapScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final swapController = Get.put(SwapController());

  @override
  void initState() {
    super.initState();
    _fromController.addListener(
        () => swapController.updateReceiveAmount(_fromController.text));
    ever(swapController.toAmount, (value) {
      _toController.text = value.toString();
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("there is some thing goging on");
    print(swapController.toAmount.value);
    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You Pay',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _fromController,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Obx(() => CryptoDropdown(
                                options: swapController.cryptoOptions,
                                selected: swapController.fromCurrency.value!,
                                onChanged: swapController.updateFromCurrency,
                              )),
                        ],
                      ),
                    ),

                    // Fee Information (Below "You Pay")
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          'Service Fee: ${swapController.serviceFeePercentage}% ${_fromController.text.isNotEmpty ? '(\$${((double.tryParse(_fromController.text) ?? 0) * (swapController.serviceFeePercentage.value / 100)).toStringAsFixed(2)})' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )),

                    // Swap Icon Button
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert, color: Colors.blue),
                        onPressed: swapController.swapCurrencies,
                        padding: const EdgeInsets.only(top: 8),
                      ),
                    ),

                    const Text(
                      'You Receive',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _toController,
                              enabled: false,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                              ),
                            ),
                          ),
                          Obx(() => CryptoDropdown(
                                options: swapController.cryptoOptions,
                                selected: swapController.toCurrency.value!,
                                onChanged: swapController.updateToCurrency,
                              )),
                        ],
                      ),
                    ),

                    // Fee Information (Below "You Receive")
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          'Net Amount: ${swapController.toAmount.value.isNotEmpty ? '\$${swapController.toAmount.value}' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )),

                    // const SizedBox(height: 24),

                    // Add payment button
                    // Container(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       if (_fromController.text.isEmpty) {
                    //         Get.snackbar(
                    //           'Error',
                    //           'Please enter an amount',
                    //           backgroundColor: Colors.red,
                    //           colorText: Colors.white,
                    //         );
                    //         return;
                    //       }

                    //       // Update the swap controller values before navigation
                    //       swapController.fromAmount.value =
                    //           _fromController.text;
                    //       swapController.toAmount.value = _toController.text;
                    //       swapController.setExchangeAccounts();

                    //       Get.to(() => const PaymentProcessScreen());
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.orange,
                    //       padding: EdgeInsets.symmetric(vertical: 15),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       "Proceed to Payment",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 24),
                  ],
                ),
              ),
              TransactionList(),
            ],
          ),
        ),
      ),
    );
  }
}
