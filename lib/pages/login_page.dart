import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget { // stateless is for nonchanging ui
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // basic layouts
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget { // stateful is dynamic with user input
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> { // for ui logic
  // manages user input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  // user log in, firebase auth is added
  void loginUser() async {
    // user input text fields
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // capture nav and scaffold, avoid widget deletion before await, same as register page
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword( // trying to log in with firebase auth
        email: email,
        password: password,
      );

      navigator.pushReplacementNamed('/home'); // will nav home if successful login
    } on FirebaseAuthException catch (e) {
      // error message if login is failed with snack bar of message
      messenger.showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // email field
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        const SizedBox(height: 16),

        // password field
        TextField(
          controller: passwordController,
          obscureText: true, // privacy *** instead of abc
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),
        const SizedBox(height: 24),

        // login button
        ElevatedButton(
          onPressed: loginUser, // calls loginUser() func
          child: const Text('Login'),
        ),
        const SizedBox(height: 12),

        // link below login buttons to nav to register page, do after
        TextButton(
          onPressed: () {
            // Navigate to register page
            Navigator.pushNamed(context, '/register'); // this will switch to register page
          },
          child: const Text("Register an account"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // frees memory
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}