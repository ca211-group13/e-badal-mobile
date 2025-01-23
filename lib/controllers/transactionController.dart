import 'package:crypto_to_local_exchange_app/controllers/swapController.dart';
import 'package:get/get.dart';

class TransactionControler extends GetxController {
  final loading = false.obs;

  Future<void> createTransaction() async {
    final userController = Get.find<SwapController>();
    final String whereUsdtAt =
        userController.fromCurrency.value?.symbol == "USDT" ? "Top" : "Bottom";
    String chainSeprator(chain) {
      if (chain == "BNB Smart Chain") {
        return "BEP-20";
      } else {
        return "TRC-20";
      }
    }

    final Map<String, dynamic> body = {
      "localPhoneNumber": userController.fromCurrency.value?.symbol != "USDT"
          ? userController.fromAddress.value
          : userController.toAddress.value,
      "usdtAddress": userController.fromCurrency.value?.symbol == "USDT"
          ? userController.fromAddress.value
          : userController.toAddress.value,
      "chainType": whereUsdtAt == "Top"
          ? chainSeprator(userController.fromCurrency.value?.chain)
          : chainSeprator(userController.toCurrency.value?.chain),
      "amount": userController.fromAmount.value,
      "type": whereUsdtAt == "Top"
          ? "USDT to ${userController.toCurrency.value?.symbol}"
          : "${userController.fromCurrency.value?.symbol} to USDT"
    };
    print(body);
  }
}


// {
//   "localPhoneNumber": "252634567890",
//   "usdtAddress": "TRx4h7dgf...",
//   "chainType": "BEP-20",
//   "amount": 100,
//   "type": "deposit"
// }