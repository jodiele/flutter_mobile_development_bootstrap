import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget { // user input ui
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controller text fields,  same as login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // calls when register line is tapped
  void registerUser() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    print('Registering user with email $email and password $password'); // placeholder, will do firebase later
    Navigator.pushReplacementNamed(context, '/home');
  }

  // ui for registration page, same as login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Register'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // will go back to login page
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }

  // frees memory
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

