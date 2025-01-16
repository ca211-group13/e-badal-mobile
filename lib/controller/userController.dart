import 'dart:convert';

import 'package:crypto_to_local_exchange_app/pages/storage/token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var loading = false.obs;
  final String baseUrl = 'http://10.0.2.2:8000';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confermPasswordController = TextEditingController();
  final nameController = TextEditingController();
  var Token = ''.obs;
  final TokenStorage tokenStorage = TokenStorage();

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
          Uri.parse(baseUrl + '/api/users/register'),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        // print(data);
        TokenStorage.saveToken(data.token);
        Token.value = data.token;
        print(Token.value);
      } else {
        Get.snackbar(
          "Error",
          'failed to fetch',
        );
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
}
