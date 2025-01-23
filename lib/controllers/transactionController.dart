import 'dart:convert';

import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:crypto_to_local_exchange_app/controllers/swapController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TransactionControler extends GetxController {
  final isLoading = false.obs;
  final activeStep = 0.obs;

  final String baseUrl = 'http://10.0.2.2:8000/api';
  Future<void> createTransaction() async {
    isLoading.value = true;
    final swapController = Get.find<SwapController>();
    final userController = Get.find<UserController>();
    String selectedLocalAcount;
    final String whereUsdtAt =
        swapController.fromCurrency.value?.symbol == "USDT" ? "Top" : "Bottom";
    String chainSeprator(chain) {
      if (chain == "BNB Smart Chain") {
        return "BEP-20";
      } else {
        return "TRC-20";
      }
    }

//  evcPhoneNumber, sahalPhoneNumber, zaadPhoneNumber
    if (swapController.fromCurrency.value?.symbol != "USDT") {
      selectedLocalAcount =
          "${swapController.fromCurrency.value?.symbol.toLowerCase()}PhoneNumber";
    } else {
      selectedLocalAcount =
          "${swapController.toCurrency.value?.symbol.toLowerCase()}PhoneNumber";
    }

    final Map<String, dynamic> body = {
      selectedLocalAcount: swapController.fromCurrency.value?.symbol != "USDT"
          ? swapController.fromAddress.value
          : swapController.toAddress.value,
      "usdtAddress": swapController.fromCurrency.value?.symbol == "USDT"
          ? swapController.fromAddress.value
          : swapController.toAddress.value,
      "chainType": whereUsdtAt == "Top"
          ? chainSeprator(swapController.fromCurrency.value?.chain)
          : chainSeprator(swapController.toCurrency.value?.chain),
      "amount": swapController.fromAmount.value,
      "type": whereUsdtAt == "Top"
          ? "USDT to ${swapController.toCurrency.value?.symbol}"
          : "${swapController.fromCurrency.value?.symbol} to USDT"
    };
    try {
      isLoading.value = true;
      final response = await http.post(
          Uri.parse(baseUrl + '/transactions/create-transaction'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${userController.Token.value}'
          });
      final data = json.decode(response.body);
      userController.getUsersProfile();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Transaction created successfully");
        userController.getUsersProfile();
        activeStep.value = 1;
      } else {
        Get.snackbar("Error", "Failed to create transaction");
        print(response.statusCode);
        print(response.body);
      }
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }
}


// {
//   "localPhoneNumber": "252634567890",
//   "usdtAddress": "TRx4h7dgf...",
//   "chainType": "BEP-20",
//   "amount": 100,
//   "type": "deposit"
// }