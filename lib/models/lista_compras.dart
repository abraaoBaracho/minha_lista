

import 'produto.dart';

class ListaDeCompras {
  String nome;
  String data;
  String tipo;
  List<Produto> compras = [];

  ListaDeCompras({required this.nome, required this.data, required this.tipo});

  void addProduto(Produto p) {
    compras.add(p);
  }

  List<Produto> getListaDeCompras() {
    return compras;
  }

  factory ListaDeCompras.fromMap(Map<String, dynamic> map) {
    return ListaDeCompras(
      nome: map['nome'],
      data: map['data'],
      tipo: map['tipo']
      
    );
  }

}