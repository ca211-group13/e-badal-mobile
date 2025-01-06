import 'package:crypto_to_local_exchange_app/pages/components/cryptoDropdown.dart';
import 'package:flutter/material.dart';

class CryptoSwapScreen extends StatefulWidget {
  const CryptoSwapScreen({Key? key}) : super(key: key);

  @override
  _CryptoSwapScreenState createState() => _CryptoSwapScreenState();
}

class _CryptoSwapScreenState extends State<CryptoSwapScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  double serviceFeePercentage = 2.0;
  late CurrencyOption selectedCrypto;
  late CurrencyOption selectedLocal;

  final List<CurrencyOption> cryptoOptions = [
    CurrencyOption(
      name: 'USDT BEP-20',
      symbol: 'USDT',
      chain: 'BNB Smart Chain',
      imageUrl:
          'https://assets.coingecko.com/coins/images/325/thumb/Tether.png',
    ),
    CurrencyOption(
      name: 'USDT TRC-20',
      symbol: 'USDT',
      chain: 'TRON',
      imageUrl:
          'https://assets.coingecko.com/coins/images/325/thumb/Tether.png',
    ),
  ];

  final List<CurrencyOption> localOptions = [
    CurrencyOption(
      name: 'EVC Money',
      symbol: 'EVC',
      backgroundColor: Colors.green,
    ),
    CurrencyOption(
      name: 'Zaad Service',
      symbol: 'ZAAD',
      backgroundColor: Colors.blue,
    ),
    CurrencyOption(
      name: 'Sahal Service',
      symbol: 'SAHAL',
      backgroundColor: Colors.orange,
    ),
  ];

  void updateReceiveAmount(String value) {
    if (value.isEmpty) {
      _toController.text = '';
      return;
    }
    double inputAmount = double.tryParse(value) ?? 0;
    double fee = inputAmount * (serviceFeePercentage / 100);
    double receiveAmount = inputAmount - fee;
    _toController.text = receiveAmount.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    selectedCrypto = cryptoOptions[0];
    selectedLocal = localOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // You Pay Section
              const Text(
                'You Pay',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
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
                        onChanged: updateReceiveAmount,
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
                      selected: selectedCrypto,
                      onChanged: (option) =>
                          setState(() => selectedCrypto = option),
                    ),
                  ],
                ),
              ),

              // Swap Icon
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Icon(Icons.swap_vert, color: Colors.blue),
                ),
              ),

              // You Receive Section
              const Text(
                'You Receive',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
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
                      options: localOptions,
                      selected: selectedLocal,
                      onChanged: (option) =>
                          setState(() => selectedLocal = option),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Fee Information
              Container(
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('You Pay'),
                        Text(
                          '\$${_fromController.text.isEmpty ? "0.00" : _fromController.text}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Service Fee'),
                        Text(
                          '${serviceFeePercentage}% (\$${(_fromController.text.isEmpty ? 0 : double.parse(_fromController.text) * serviceFeePercentage / 100).toStringAsFixed(2)})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('You Receive'),
                        Text(
                          '\$${_toController.text.isEmpty ? "0.00" : _toController.text}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Swap Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement swap functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Swap',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
