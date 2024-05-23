import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Banco{

  Banco._();

  static final Banco instance = Banco._();
  static Database? _database;

  get database async{
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
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
  await db.execute(_listaTarefa);
  await db.execute(_listaCompra);
  await db.execute(_tarefa);
  await db.execute(_produto);

}

String get _listaTarefa => '''
CREATE TABLE listaTarefas (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    data TEXT NOT NULL
  );
 ''';

 String get _listaCompra => '''
CREATE TABLE listaCompras (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    data TEXT NOT NULL
  );
 ''';
String get _tarefa => ''' 
CREATE TABLE tarefa  (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    lista_id INTEGER,
    FOREIGN KEY (lista_id) REFERENCES listaTarefas(id)
);
''';
String get _produto => ''' 
CREATE TABLE produto  (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    valor REAL NOT NULL,
    quantidade INTEGER,
    lista_id INTEGER,
    FOREIGN KEY (lista_id) REFERENCES listaCompra(id)
);
''';
