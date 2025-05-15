import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/gasto.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final String nombreTabla = 'gastos';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'gastos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gastos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL,
        monto REAL NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertGasto(Gasto gasto) async {
    Database db = await database;
    return await db.insert(nombreTabla, gasto.toMap());
  }

  Future<List<Gasto>> getGastos() async {
    Database db = await database;
    var gastos = await db.query(nombreTabla, orderBy: 'fecha DESC');
    return gastos.isNotEmpty
      ? gastos.map((gasto) => Gasto.fromMap(gasto)).toList()
      : [];
  }

  Future<int> updateGasto(Gasto gasto) async {
    Database db = await database;
    return await db.update(nombreTabla, gasto.toMap(), where: 'id = ?', whereArgs: [gasto.id]);
  }

  Future<int> deleteGasto(int id) async {
    Database db = await database;
    return await db.delete(nombreTabla, where: 'id = ?', whereArgs: [id]);
  }
}