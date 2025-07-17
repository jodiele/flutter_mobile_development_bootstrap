import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import pages created
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
//import 'pages/weekly_schedule_page.dart';
//import 'pages/todo_page.dart';
//import 'pages/settings_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// root for app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar/TODO App ',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // default page
      routes: {
        // screens for my pages to nav to
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        //'/weekly': (context) => const WeeklySchedulePage(),
        //'/todo': (context) => const TodoPage(),
        //'/settings': (context) => const SettingsPage(),
      },
    );
  }
}