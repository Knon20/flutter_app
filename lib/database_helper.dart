import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      username TEXT NOT NULL,
      password TEXT NOT NULL
    )
  ''');

    await db.execute('''
   CREATE TABLE physical_activity (
      id INTEGER PRIMARY KEY,
      activity TEXT NOT NULL,
      duration INTEGER NOT NULL,
      date TEXT NOT NULL,
      user_id INTEGER,
      FOREIGN KEY(user_id) REFERENCES users(id)
    )
  ''');

    await db.execute('''
    CREATE TABLE foods (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      calories INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE food_registry (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      food_id INTEGER,
      meal TEXT NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id),
      FOREIGN KEY(food_id) REFERENCES foods(id)
    )
  ''');

    List<Map<String, dynamic>> foods = [
      {'name': 'Manzana', 'calories': 52},
      {'name': 'Banana', 'calories': 96},
      {'name': 'Zanahoria', 'calories': 41},
      {'name': 'Pollo', 'calories': 335},
      {'name': 'Arroz', 'calories': 130},
    ];

    for (var food in foods) {
      await db.insert('foods', food);
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map?> getUser(String username, String password) async {
    Database db = await database;
    List<Map> results = await db.query(
      'users',
      columns: ['id', 'username', 'password'],
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> insertPhysicalActivity(int userId, Map<String, dynamic> physicalActivity) async {
    Database db = await database;
    physicalActivity['user_id'] = userId; // Añade el id del usuario al mapa
    return await db.insert('physical_activity', physicalActivity);
  }

  Future<List<Map<String, dynamic>>> getAllPhysicalActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    Database db = await database;
    return await db.query('physical_activity', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> deletePhysicalActivity(int id) async {
    Database db = await database;
    return await db.delete('physical_activity', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePhysicalActivity(Map<String, dynamic> physicalActivity) async {
    Database db = await database;
    return await db.update('physical_activity', physicalActivity, where: 'id = ?', whereArgs: [physicalActivity['id']]);
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app.db');
    await databaseFactory.deleteDatabase(path);
  }

  Future<int> insertFood(Map<String, dynamic> food) async {
    Database db = await database;
    return await db.insert('foods', food);
  }

  Future<List<Map<String, dynamic>>> getAllFoods() async {
    Database db = await database;
    return await db.query('foods');
  }

  Future<int> deleteFood(int id) async {
    Database db = await database;
    return await db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFood(Map<String, dynamic> food) async {
    Database db = await database;
    return await db.update('foods', food, where: 'id = ?', whereArgs: [food['id']]);
  }

  Future<int> insertFoodRegistry(int userId, int foodId, Map<String, dynamic> foodRegistry) async {
    Database db = await database;
    foodRegistry['user_id'] = userId; // Añade el id del usuario al mapa
    foodRegistry['food_id'] = foodRegistry['food_id']; // Añade el id del alimento al mapa
    return await db.insert('food_registry', foodRegistry);
  }

  Future<List<Map<String, dynamic>>> getAllFoodRegistries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    Database db = await database;
    return await db.query('food_registry', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> deleteFoodRegistry(int id) async {
    Database db = await database;
    return await db.delete('food_registry', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFoodRegistry(Map<String, dynamic> foodRegistry) async {
    Database db = await database;
    return await db.update('food_registry', foodRegistry, where: 'id = ?', whereArgs: [foodRegistry['id']]);
  }
}
