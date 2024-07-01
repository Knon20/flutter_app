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
}
