import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minha_lista/banco/banco.dart';
import 'package:minha_lista/models/lista_tarefas.dart';
import 'package:sqflite/sqflite.dart';

class ListaTarefasRepositorio extends ChangeNotifier {
  late Database db;
  List<ListaDeTarefas> _listas = [];

  List<ListaDeTarefas> get lista => _listas;

  ListaTarefasRepositorio() {
    _initRepository();
  }

  Future<void> _initRepository() async {
    await _getLista();
  }

  Future<void> _getLista() async {
    db = await Banco.instance.database;
    List<Map<String, dynamic>> prov = await db.query('listaTarefas');
    _listas = prov.map((map) => ListaDeTarefas.fromMap(map)).toList();

    notifyListeners();
  }

  Future<int> addLista(ListaDeTarefas lista) async {
    db = await Banco.instance.database;
    int resultado = await db.insert('lista', {
      'nome': lista.nome,
      'data': lista.data,
    });

    await _getLista();
    return resultado;
  }

  Future<int> deleteLista(ListaDeTarefas lista) async{
    db = await Banco.instance.database;
    int resultado = await db.delete('lista', where:'id=?', whereArgs: [lista.id]);

    await _getLista();
    return resultado;
  }

  Future<int> editarLista(ListaDeTarefas lista) async{
    db = await Banco.instance.database;
    int resultado = await db.update('lista', {
      'nome' : lista.nome,
      'data' : lista.data
    }, where: 'id=?', whereArgs: [lista.id]);

    await _getLista();
    return resultado;
  }
}
