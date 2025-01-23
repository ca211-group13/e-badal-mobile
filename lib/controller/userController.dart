import 'dart:convert';

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

  @override
  void onInit() {
    super.onInit();
    // Check if token exists in storage
    initializeToken();
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
      print("there is......${e}");
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
}
