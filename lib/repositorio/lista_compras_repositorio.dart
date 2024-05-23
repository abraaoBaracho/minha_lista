import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minha_lista/banco/banco.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:sqflite/sqflite.dart';

class ListaComprasRepositorio extends ChangeNotifier {
  late Database db;
  List<ListaDeCompras> _listas = [];

  List<ListaDeCompras> get lista => _listas;

  ListaComprasRepositorio() {
    _initRepository();
  }

  Future<void> _initRepository() async {
    await _getLista();
  }

  Future<void> _getLista() async {
    db = await Banco.instance.database;
    List<Map<String, dynamic>> prov = await db.query('listaCompras');
    _listas = prov.map((map) => ListaDeCompras.fromMap(map)).toList();

    notifyListeners();
  }

  Future<int> addLista(ListaDeCompras lista) async {
    db = await Banco.instance.database;
    int resultado = await db.insert('listaCompras', {
      'nome': lista.nome,
      'data': lista.data,
    });

    await _getLista();
    return resultado;
  }

  Future<int> deleteLista(ListaDeCompras lista) async{
    db = await Banco.instance.database;
    int resultado = await db.delete('listaCompras', where:'id=?', whereArgs: [lista.id]);

    await _getLista();
    return resultado;
  }

  Future<int> editarLista(ListaDeCompras lista) async{
    db = await Banco.instance.database;
    int resultado = await db.update('listaCompras', {
      'nome' : lista.nome,
      'data' : lista.data
    }, where: 'id=?', whereArgs: [lista.id]);

    await _getLista();
    return resultado;
  }
}
