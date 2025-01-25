import 'dart:convert';

import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AccountsController extends GetxController {
  final type = "".obs;
  final AccountVlue = "".obs;
  final loading = false.obs;
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> addAccount() async {
    final Map<String, String> body = {
      "type": type.value,
      type.value.contains("USDT") ? "usdtAddress" : "phoneNumber":
          AccountVlue.value
    };

    try {
      loading.value = true;
      final userController = Get.find<UserController>();
      final response = await http.post(
          Uri.parse(baseUrl + '/users/add-account'),
          body: json.encode(body),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${userController.Token.value}',
          });
      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        loading.value = false;
        Get.snackbar(
          "Success",
          "${data["message"]}",
          backgroundColor: Colors.green.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
        print(data);
        userController.getUsersProfile();
      } else {
        loading.value = false;
        Get.snackbar(
          "Error",
          "Failed to add account",
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      loading.value = false;
      print(e);
      Get.snackbar(
        "error",
        "Failed to add account ${e}",
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }
}


// ['EVC', 'Sahal', 'Zaad', 'USDT(TRC-20)','USDT(BEP-20)'],

// {
//   "type": "EVC",
//   "phoneNumber": "string",
//   "usdtAddress": "string"
// }