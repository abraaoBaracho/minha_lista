import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Banco{

  Banco._();

  static final Banco instance = Banco._();
  static Database? _database;

  get database async{
    if (_database != null) {
      return _database;
    }
    return await _initDatabase();
  }
}

Future<Database> _initDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), 'minha_lista.db'),
    version: 1,
    onCreate: _onCreate,
    
  );
}
Future<void> _onCreate(Database db, int version) async {
  await db.execute(_lista);
  await db.execute(_produto);
}

String get _lista => '''
CREATE TABLE lista (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    data TEXT NOT NULL,
  );
 ''';
String get _produto => ''' 
CREATE TABLE produto  (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    valor REAL,
    quantidade TEXT,
    lista_id INTEGER,
    FOREIGN KEY (lista_id) REFERENCES lista(id)
);
''';
