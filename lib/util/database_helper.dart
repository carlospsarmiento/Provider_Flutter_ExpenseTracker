import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finanzas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crea todas las tablas necesarias aquí
    await db.execute('''
        CREATE TABLE movimientos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL,
        cantidad REAL NOT NULL,
        fecha TEXT NOT NULL,
        tipo TEXT NOT NULL  -- Puede ser 'ingreso' o 'gasto'
      )
    ''');
  }

  // Insertar un registro en cualquier tabla
  Future<int> insert(String table, Map<String, dynamic> values) async {
    Database? db = await database;
    return await db!.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Obtener todos los registros de una tabla con opción de aplicar filtros
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    Database? db = await database;
    return await db!.query(table, where: where, whereArgs: whereArgs);
  }

  // Actualizar un registro en cualquier tabla
  Future<int> update(String table, Map<String, dynamic> values, String whereClause, List<dynamic> whereArgs) async {
    Database? db = await database;
    return await db!.update(table, values, where: whereClause, whereArgs: whereArgs);
  }

  // Eliminar un registro de cualquier tabla
  Future<int> delete(String table, String whereClause, List<dynamic> whereArgs) async {
    Database? db = await database;
    return await db!.delete(table, where: whereClause, whereArgs: whereArgs);
  }
}