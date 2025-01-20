import 'package:crypto_to_local_exchange_app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _keepSignedIn = false;
  final _formKey = GlobalKey<FormState>();
  String? _passwordError;
  UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email Field
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: userController.emailController,
                    decoration: InputDecoration(
                      // hintText: 'Rhebhek@gmail.com',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Field

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),
                  TextFormField(
                    controller: userController.passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      // hintText: '••••••••',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      errorText: _passwordError,
                      errorStyle: const TextStyle(
                        color: Colors.red,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Container(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Keep me signed in checkbox
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: _keepSignedIn,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _keepSignedIn = value ?? false;
                  //         });
                  //       },
                  //       activeColor: Colors.green,
                  //     ),
                  //     const Text(
                  //       'Keep me signed in',
                  //       style: TextStyle(
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),
                  // Login Button
                  Obx(
                    () => 
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                      child: ElevatedButton(
                        onPressed: userController.loading.value
                            ? null
                            : () {
                                // if (_formKey.currentState!.validate()) {
                                //   // Handle login logic here
                                // }
                                userController.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFF9838), // Orange color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                        child: userController.loading.value
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an Account? ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle navigation to sign up screen
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign up here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
