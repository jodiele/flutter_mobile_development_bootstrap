import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget { // user input ui
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controller text fields,  same as login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  // calls when register line is tapped, firebase implementation
  void registerUser() async {
    // user input
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // capture nav and scaffold, avoids widget deletion before await
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword( // try to create user with firebase
        email: email,
        password: password,
      );

      navigator.pushReplacementNamed('/home'); // nav to home, clears nav history so it won't go back to login
    } on FirebaseAuthException catch (e) {
      // if try is failed, shows snack bar with message of error
      messenger.showSnackBar( // shows up at bottom of screen, goes away after a couple of seconds
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
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

