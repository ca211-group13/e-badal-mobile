// crypto_swap_screen.dart
import 'package:crypto_to_local_exchange_app/pages/paymentProcess/paymentProcess.dart';
import 'package:crypto_to_local_exchange_app/widgets/paymentDetails%20.dart';
import 'package:crypto_to_local_exchange_app/widgets/transactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crypto_to_local_exchange_app/pages/components/cryptoDropdown.dart';
import 'package:crypto_to_local_exchange_app/widgets/app_scaffold.dart';

class CryptoSwapScreen extends StatefulWidget {
  const CryptoSwapScreen({Key? key}) : super(key: key);

  @override
  _CryptoSwapScreenState createState() => _CryptoSwapScreenState();
}

class _CryptoSwapScreenState extends State<CryptoSwapScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  double serviceFeePercentage = 2.0;
  late CurrencyOption upperSelectedOption;
  late CurrencyOption lowerSelectedOption;

  final List<CurrencyOption> cryptoOptions = [
    CurrencyOption(
      name: 'USDT BEP-20',
      symbol: 'USDT',
      chain: 'BNB Smart Chain',
      svgAsset: 'assets/images/usdt.svg',
    ),
    CurrencyOption(
      name: 'USDT TRC-20',
      symbol: 'USDT',
      chain: 'TRON',
      svgAsset: 'assets/images/usdt.svg',
    ),
    CurrencyOption(
      name: 'EVC Money',
      symbol: 'EVC',
      svgAsset: 'assets/images/evc.svg',
    ),
    CurrencyOption(
      name: 'Zaad Service',
      symbol: 'ZAAD',
      svgAsset: 'assets/images/zaad.svg',
    ),
    CurrencyOption(
      name: 'Sahal Service',
      symbol: 'SAHAL',
      svgAsset: 'assets/images/sahal.svg',
    ),
  ];

  void updateReceiveAmount(String value) {
    setState(() {
      if (value.isEmpty) {
        _toController.text = '';
        return;
      }
      double inputAmount = double.tryParse(value) ?? 0;
      double fee = inputAmount * (serviceFeePercentage / 100);
      double receiveAmount = inputAmount - fee;
      _toController.text = receiveAmount.toStringAsFixed(2);
    });
  }

  void swapCurrencies() {
    setState(() {
      final temp = upperSelectedOption;
      upperSelectedOption = lowerSelectedOption;
      lowerSelectedOption = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    upperSelectedOption = cryptoOptions[0];
    lowerSelectedOption = cryptoOptions[2];
    _fromController
        .addListener(() => updateReceiveAmount(_fromController.text));
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          CryptoDropdown(
                            options: cryptoOptions,
                            selected: upperSelectedOption,
                            onChanged: (option) {
                              if (option.symbol == 'USDT' &&
                                  lowerSelectedOption.symbol == 'USDT') {
                                setState(() {
                                  lowerSelectedOption = cryptoOptions[2];
                                });
                              } else if (option.symbol != 'USDT' &&
                                  lowerSelectedOption.symbol != 'USDT') {
                                setState(() {
                                  lowerSelectedOption = cryptoOptions[0];
                                });
                              }
                              setState(() => upperSelectedOption = option);
                            },
                          ),
                        ],
                      ),
                    ),

                    // Fee Information (Below "You Pay")
                    const SizedBox(height: 8),
                    Text(
                      'Service Fee: $serviceFeePercentage% ${_fromController.text.isNotEmpty ? '(\$${((double.tryParse(_fromController.text) ?? 0) * (serviceFeePercentage / 100)).toStringAsFixed(2)})' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    // Swap Icon Button
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert, color: Colors.blue),
                        onPressed: swapCurrencies,
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
                          CryptoDropdown(
                            options: cryptoOptions,
                            selected: lowerSelectedOption,
                            onChanged: (option) {
                              if (option.symbol == 'USDT' &&
                                  upperSelectedOption.symbol == 'USDT') {
                                setState(() {
                                  upperSelectedOption = cryptoOptions[2];
                                });
                              } else if (option.symbol != 'USDT' &&
                                  upperSelectedOption.symbol != 'USDT') {
                                setState(() {
                                  upperSelectedOption = cryptoOptions[0];
                                });
                              }
                              setState(() => lowerSelectedOption = option);
                            },
                          ),
                        ],
                      ),
                    ),

                    // Fee Information (Below "You Receive")
                    const SizedBox(height: 8),
                    Text(
                      'Net Amount: ${_toController.text.isNotEmpty ? '\$${_toController.text}' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),
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
