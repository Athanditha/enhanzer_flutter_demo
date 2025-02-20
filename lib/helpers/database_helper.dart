import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userCode TEXT,
        displayName TEXT,
        email TEXT,
        employeeCode TEXT,
        companyCode TEXT
      )
    ''');
  }

  Future<void> insertUser(User user) async {
    final db = await instance.database;
    
    // Clear existing users first
    await db.delete('users');
    
    // Insert new user
    await db.insert('users', user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    
    print("User inserted into database: ${user.toString()}");
  }

  Future<User?> getUser() async {
    try {
      final db = await instance.database;
      print("Querying database for user");
      final result = await db.query('users', limit: 1);
      print("Database query result: $result");

      if (result.isNotEmpty) {
        final user = User.fromJson(result.first);
        print("Retrieved user from database: $user");
        return user;
      }
      print("No user found in database");
      return null;
    } catch (e) {
      print("Error getting user from database: $e");
      return null;
    }
  }
}
