import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:get/get.dart';
import 'package:crypto_to_local_exchange_app/pages/components/cryptoDropdown.dart';

class SwapController extends GetxController {
  // Observable variables
  final fromAmount = ''.obs;
  final toAmount = ''.obs;
  final serviceFeePercentage = 2.0.obs;
  final fromCurrency = Rxn<CurrencyOption>();
  final toCurrency = Rxn<CurrencyOption>();
  final fromAddress = ''.obs;
  final toAddress = ''.obs;

  // List of available crypto options
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
      symbol: 'Zaad',
      svgAsset: 'assets/images/zaad.svg',
    ),
    CurrencyOption(
      name: 'Sahal Service',
      symbol: 'Sahal',
      svgAsset: 'assets/images/sahal.svg',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Set initial values
    fromCurrency.value = cryptoOptions[0];
    toCurrency.value = cryptoOptions[2];
    setExchangeAccounts();
  }

  // Calculate receive amount based on input amount and fee
  void updateReceiveAmount(String value) {
    fromAmount.value = value;
    if (value.isEmpty) {
      toAmount.value = '';
      return;
    }
    double inputAmount = double.tryParse(value) ?? 0;
    double fee = inputAmount * (serviceFeePercentage.value / 100);
    double receiveAmount = inputAmount - fee;
    toAmount.value = receiveAmount.toStringAsFixed(2);
  }

  // Swap currencies
  void swapCurrencies() {
    final temp = fromCurrency.value;
    fromCurrency.value = toCurrency.value;
    toCurrency.value = temp;
    setExchangeAccounts();
  }

  // Update from currency with validation
  void updateFromCurrency(CurrencyOption option) {
    if (option.symbol == 'USDT' && toCurrency.value?.symbol == 'USDT') {
      toCurrency.value = cryptoOptions[2];
    } else if (option.symbol != 'USDT' && toCurrency.value?.symbol != 'USDT') {
      toCurrency.value = cryptoOptions[0];
    }
    fromCurrency.value = option;
    setExchangeAccounts();
  }

  // Update to currency with validation
  void updateToCurrency(CurrencyOption option) {
    if (option.symbol == 'USDT' && fromCurrency.value?.symbol == 'USDT') {
      fromCurrency.value = cryptoOptions[2];
    } else if (option.symbol != 'USDT' &&
        fromCurrency.value?.symbol != 'USDT') {
      fromCurrency.value = cryptoOptions[0];
    }
    toCurrency.value = option;
    setExchangeAccounts();
  }

  // Format address to show only start and end
  String formatAddress(String address) {
    if (address.length < 10) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
  }

  void setExchangeAccounts() {
    final userMap = Get.find<UserController>().user.value;
  if (userMap == null || !(userMap['accounts'] is List)) {
    fromAddress.value = '';
    toAddress.value = '';
    return;
  }
    final userAccounts = userMap['accounts'] as List;
    // Find matching account for fromCurrency
    if (fromCurrency.value?.symbol == 'USDT') {
      final usdtAccount = userAccounts.firstWhere(
        (account) =>
            account['type'] ==
            'USDT(${fromCurrency.value?.chain == 'TRON' ? 'TRC-20' : 'BEP-20'})',
        orElse: () => {},
      );
      fromAddress.value = usdtAccount['usdtAddress']??'';
    } else {
      final evcAccount = userAccounts.firstWhere(
        (account) => account['type'] == fromCurrency.value?.symbol,
        orElse: () => {},
      );
      fromAddress.value = evcAccount['phoneNumber'] ?? '';
    }

    // Find matching account for toCurrency
    if (toCurrency.value?.symbol == 'USDT') {
      final usdtAccount = userAccounts.firstWhere(
        (account) =>
            account['type'] ==
            'USDT(${toCurrency.value?.chain == 'TRON' ? 'TRC-20' : 'BEP-20'})',
        orElse: () => {},
      );
      toAddress.value = usdtAccount['usdtAddress']??'';
    } else {
      final evcAccount = userAccounts.firstWhere(
        (account) => account['type'] == toCurrency.value?.symbol,
        orElse: () => {},
      );
      toAddress.value = evcAccount['phoneNumber'] ?? '';
    }
  }
}
