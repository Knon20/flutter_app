import 'package:abraham_flutter_app/register_page.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';
import 'my_home_page.dart';

void main() {
  runApp(const MyApp());
  printAllUsers();
}

void printAllUsers() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> users = await dbHelper.getAllUsers();
  for (var user in users) {
    print('User: ${user['username']}, Password: ${user['password']}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poli-Fitness',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const MyHomePage(title: 'Poli-Fitness'),
      },
    );
  }
}
