import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minha_lista/banco/banco.dart';
import 'package:minha_lista/models/produto.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoRepositorio extends ChangeNotifier {
  late Database db;
  List<Produto> _listas = [];

  List<Produto> get lista => _listas;

  ProdutoRepositorio() {
    _initRepository();
  }

  Future<void> _initRepository() async {
    await _getLista();
  }

  Future<void> _getLista() async {
    db = await Banco.instance.database;
    List<Map<String, dynamic>> prov = await db.query('produto');
    _listas = prov.map((map) => Produto.fromMap(map)).toList();

    notifyListeners();
  }

    Future<List<Produto>> getProdutos(int listaId) async {
    db = await Banco.instance.database;
    List<Map<String, dynamic>> prov = await db.query('produto', where: 'lista_id = ?', whereArgs: [listaId]);
     List<Produto> listaProduto = prov.map((map) => Produto.fromMap(map)).toList();

    notifyListeners();

    return listaProduto;
  }

  Future<int> addProduto(Produto produto, int listaId) async {
    db = await Banco.instance.database;
    int resultado = await db.insert('produto', {
      'nome': produto.nome,
      'valor': produto.preco,
      'quantidade': produto.quant,
      'lista_id': listaId
    });

    await _getLista();
    return resultado;
  }

  Future<int> deleteProduto(Produto produto) async{
    db = await Banco.instance.database;
    int resultado = await db.delete('produto', where:'id=?', whereArgs: [produto.id]);

    await _getLista();
    return resultado;
  }

  Future<int> editarProduto(Produto produto) async{
    db = await Banco.instance.database;
    int resultado = await db.update('produto', {
      'nome': produto.nome,
      'valor': produto.preco,
      'quantidade': produto.quant,
    }, where: 'id=?', whereArgs: [produto.id]);

    await _getLista();
    return resultado;
  }
}
