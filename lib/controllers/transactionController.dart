import 'dart:convert';

import 'package:crypto_to_local_exchange_app/controller/userController.dart';
import 'package:crypto_to_local_exchange_app/controllers/swapController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TransactionControler extends GetxController {
  final isLoading = false.obs;
  final activeStep = 0.obs;
  final transactions = <Map<String, dynamic>>[].obs;

  final String baseUrl = 'http://10.0.2.2:8000/api';

  final userController = Get.find<UserController>();
  Future<void> createTransaction() async {
    try {
      isLoading.value = true;
      final swapController = Get.find<SwapController>();
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

      final response = await http.post(
        Uri.parse('$baseUrl/transactions/create-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userController.Token.value}'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Wait for the transaction to be processed
        await Future.delayed(Duration(milliseconds: 500));
        
        // Fetch updated profile to get new pending transaction
        await userController.getUsersProfile();
        
        Get.snackbar(
          "Success",
          "Transaction created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        activeStep.value = 1;
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Failed to create transaction');
      }
    } catch (e) {
      print('Error creating transaction: $e');
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionHistory() async {
    try {
      isLoading.value = true;
      // final tokenService = Get.find<TokenService>();
      // final token = await tokenService.getToken();

      
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/transactions-history'),
        headers: {
          'Authorization': 'Bearer ${userController.Token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          transactions.value = List<Map<String, dynamic>>.from(data['transactions']);
        }
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }
}