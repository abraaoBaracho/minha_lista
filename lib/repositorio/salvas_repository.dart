import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minha_lista/banco/banco.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:sqflite/sqflite.dart';

class ListasSalvasRepository extends ChangeNotifier {
  
  late Database db;
  List<ListaDeCompras> _listas = [];

  List<ListaDeCompras> get lista => _listas;

  ListasSalvasRepository(){
    _initRepository();
  }


Future<void> _initRepository() async {
  await _getLista();
}

Future<void> _getLista() async{
  db = await Banco.instance.database;
  List<Map<String, dynamic>> prov = await db.query('lista');
  _listas = prov.map((map) => ListaDeCompras.fromMap(map)).toList();

  notifyListeners();
  
}
}