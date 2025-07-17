import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // signing out method
  void _signOut(BuildContext context) async {
    final navigator = Navigator.of(context); // capturing nav object before logging out
    await FirebaseAuth.instance.signOut(); // logs out user with firebase auth
    navigator.pushNamedAndRemoveUntil('/login', (route) => false); // clears nav stack, so when going back to the login screen
  }

  // ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // sign out
          ListTile(
            leading: const Icon(Icons.logout), // added icon
            title: const Text('Sign Out'),
            onTap: () => _signOut(context), // calls method
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Built by Jodie',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}