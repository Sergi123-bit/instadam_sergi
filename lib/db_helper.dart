// db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'instadam.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)",
        );
      },
    );
  }

  // Login
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
      'users',
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    return res.isNotEmpty;
  }

  // Registre
  Future<int> registerUser(String email, String password) async {
    final db = await database;
    return await db.insert('users', {'email': email, 'password': password});
  }

  // Canviar contrasenya — retorna true si l'email existia i s'ha actualitzat
  Future<bool> updatePassword(String email, String newPassword) async {
    final db = await database;
    final count = await db.update(
      'users',
      {'password': newPassword},
      where: "email = ?",
      whereArgs: [email],
    );
    return count > 0;
  }
}
