import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'admin_page.dart';
import 'database_helper.dart';
import 'login_page.dart';
import 'my_home_page.dart';
import 'register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que los bindings estén inicializados
  // await deleteDatabase(); // Espera a que la base de datos sea eliminada
  await initializeDatabase(); // Asegúrate de que la base de datos está inicializada
  runApp(const MyApp());
  await printAllUsers();
  await printAllActivities();
  await printAllFoodRegistries();
  await printAllFoods();
}

Future<void> deleteDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'app.db');
  await databaseFactory.deleteDatabase(path);
}

Future<void> initializeDatabase() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.database; // Asegura que la base de datos esté inicializada
}

Future<void> printAllActivities() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> activities = await dbHelper.getAllPhysicalActivities();
  for (var activity in activities) {
    print('Activity: ${activity['activity']}, Duration: ${activity['duration']}, '
        'Date: ${activity['date']} User Id: ${activity['user_id']} ');
  }
}

Future<void> printAllUsers() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> users = await dbHelper.getAllUsers();
  for (var user in users) {
    print('Id: ${user['id']}, User: ${user['username']}, Password: ${user['password']}');
  }
}

Future<void> printAllFoodRegistries() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> foodRegistries = await dbHelper.getAllFoodRegistries();
  for (var foodRegistry in foodRegistries) {
    print('Food Registry: ${foodRegistry['food_id']}, Meal: ${foodRegistry['meal']}, '
        'Date: ${foodRegistry['date']} User Id: ${foodRegistry['user_id']} ');
  }
}

Future<void> printAllFoods() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> foods = await dbHelper.getAllFoods();
  for (var food in foods) {
    print('Food: ${food['name']}, Calories: ${food['calories']} id: ${food['id']} ');
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
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}
