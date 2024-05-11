

import 'produto.dart';

class ListaDeCompras {
  String nome;
  String data;
  List<Produto> compras = [];

  ListaDeCompras({required this.nome, required this.data});

  void addProduto(Produto p) {
    p.calcularTotal();
    compras.add(p);
  }

  List<Produto> getListaDeCompras() {
    return compras;
  }

  factory ListaDeCompras.fromMap(Map<String, dynamic> map) {
    return ListaDeCompras(
      nome: map['nome'],
      data: map['data'],
      
      
    );
  }

}