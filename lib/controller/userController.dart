import 'dart:async';
import 'dart:convert';

import 'package:crypto_to_local_exchange_app/controllers/transactionController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_to_local_exchange_app/token/token_service.dart';

class UserController extends GetxController {
  final tokenService = TokenService();
  var loading = false.obs;
  final String baseUrl = 'http://10.0.2.2:8000';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confermPasswordController = TextEditingController();
  final nameController = TextEditingController();
  var Token = ''.obs;
  final user = {}.obs;
  final pendingTransaction = {}.obs;
  Timer? _timer;
  final lastTransactionStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Check if token exists in storage
    initializeToken();

    // Listen for changes in lastTransactionStatus
    ever(lastTransactionStatus, (status) {
      if (status == "success" || status == "failed") {
        // Stop refetching immediately
        stopRefetching();
        print('Refetching stopped. Last transaction status: $status');

        // Increment the step in TransactionController
        final transactionController = Get.find<TransactionControler>();
        transactionController.activeStep.value = 2; // Move to the next step
        print('Step incremented to: ${transactionController.activeStep.value}');
      }
    });
  }

  @override
  void onClose() {
    stopRefetching(); // Ensure the timer is canceled when the controller is closed
    super.onClose();
  }

  // Helper method to stop refetching
  void stopRefetching() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null; // Clear the timer reference
    }
  }

  Future<void> initializeToken() async {
    String? storedToken = await tokenService.getToken();
    if (storedToken != null) {
      Token.value = storedToken;
    }
  }

  Future<void> logout() async {
    // Clear token from storage
    await tokenService.removeToken();
    // Clear token from observable
    Token.value = '';
    // Clear all text controllers
    pendingTransaction.value = {};
    user.value = {};
    emailController.clear();
    passwordController.clear();
    confermPasswordController.clear();
    nameController.clear();
    // Navigate to login screen
    stopRefetching(); // Stop refetching on logout
    Get.offAllNamed('/signin');
  }

  Future<void> registerUser() async {
    Map<String, String> body = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };
    if (passwordController.text != confermPasswordController.text) {
      Get.snackbar("Error", "password missmatched");
      return;
    }
    try {
      loading.value = true;
      final response = await http.post(
          Uri.parse(baseUrl + '/api/auth/register'),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        Token.value = data["token"];
        // Store token using TokenService
        await tokenService.setToken(Token.value);
        loading.value = false;
        Get.offAllNamed('/');
      } else {
        loading.value = false;
        Get.snackbar(
          "Error",
          'Registration failed: ${data["message"]}',
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error",
        'Network error: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> login() async {
    Map<String, String> body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      loading.value = true;
      final response = await http.post(Uri.parse(baseUrl + '/api/auth/login'),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        Token.value = data["token"];
        // Store token using TokenService
        await tokenService.setToken(Token.value);
        loading.value = false;
        Get.offAllNamed('/');
      } else {
        print(response.statusCode);
        loading.value = false;
        Get.snackbar(
          "Error",
          'Registration failed: ${data["message"]}',
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error",
        'Network error: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> getUsersProfile() async {
    try {
      if (Token.value.isEmpty) {
        await initializeToken();
      }
      String? storedToken = tokenService.getToken();
      print(storedToken);
      loading.value = true;
      print(Token.value);
      final response = await http.get(
        Uri.parse(baseUrl + '/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Token.value}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        user.value = data["user"];
        pendingTransaction.value = {
          "isTherePendingTransaction": data["isTherePendingTransaction"],
          "lastPendingTransaction": data["lastPendingTransaction"]
        };
        if (data["lastTransactionStatus"] != null) {
          lastTransactionStatus.value = data["lastTransactionStatus"] ?? "";
          print("Last transaction status: ${lastTransactionStatus.value}");
        }
      } else {
        print(response.statusCode);
        Get.snackbar(
          "Error",
          "Failed to get user profile",
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        "Error",
        "Network error: $e",
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    } finally {
      loading.value = false;
    }
  }

  void startProfileRefetching() {
    if (lastTransactionStatus.value != "failed" &&
        lastTransactionStatus.value != "success" &&
        pendingTransaction["isTherePendingTransaction"]) {
      _timer = Timer.periodic(Duration(seconds: 20), (timer) {
        getUsersProfile();

        print('Refetching profile...');
      });
    } else {
      stopRefetching(); // Stop refetching if the status is already "success" or "failed"
    }
  }
}
