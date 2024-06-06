import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minha_lista/banco/banco.dart';
import 'package:minha_lista/models/tarefa.dart';
import 'package:sqflite/sqflite.dart';

class TarefaRepositorio extends ChangeNotifier {
  late Database db;
  List<Tarefa> _listas = [];

  List<Tarefa> get lista => _listas;

  TarefaRepositorio() {
    _initRepository();
  }

  Future<void> _initRepository() async {
    await _getLista();
  }

  Future<void> _getLista() async {
    db = await Banco.instance.database;
    List<Map<String, dynamic>> prov = await db.query('tarefa');
    _listas = prov.map((map) => Tarefa.fromMap(map)).toList();

    notifyListeners();
  }

  Future<List<Tarefa>> getTarefas(int listaId) async {
    db = await Banco.instance.database;
    List<Map<String, dynamic>> prov = await db.query('tarefa', where: 'lista_id = ?', whereArgs: [listaId]);
    List<Tarefa> listaProduto = prov.map((map) => Tarefa.fromMap(map)).toList();

    notifyListeners();

    return listaProduto;
  }

  Future<int> addTarefa(Tarefa tarefa, int listaId) async {
    db = await Banco.instance.database;
    int pegarInt;
     tarefa.concluida
     ? pegarInt = 1
     : pegarInt = 0;

    int resultado = await db.insert('tarefa', {
      'nome': tarefa.nome,
      'lista_id': listaId,
      'concluida': pegarInt
    });

    await _getLista();
    return resultado;
  }

  Future<int> deleteTarefa(Tarefa tarefa) async{
    db = await Banco.instance.database;
    int resultado = await db.delete('tarefa', where:'id=?', whereArgs: [tarefa.id]);

    await _getLista();
    return resultado;
  }

  Future<int> editarTarefa(Tarefa tarefa) async{
    db = await Banco.instance.database;
    int resultado = await db.update('tarefa', {
       'nome': tarefa.nome,
    }, where: 'id=?', whereArgs: [tarefa.id]);

    await _getLista();
    return resultado;
  }
}
