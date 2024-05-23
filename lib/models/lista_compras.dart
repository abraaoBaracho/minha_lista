

import 'produto.dart';

class ListaDeCompras {
  int id;
  String nome;
  String data;
 List<Map<String, dynamic>> compras = [];
  double precoLista;

  ListaDeCompras({required this.nome, required this.data, this.precoLista = 0, this.id = 0});

  void addProduto(Produto p) {
    compras.add({
      'nome' : p.nome,
      'preco' : p.preco,
      'quantidade' : p.quant,
      'precoTotal' : p.precoTotal
    });
   precoLista += p.precoTotal;
  }

  

  factory ListaDeCompras.fromMap(Map<String, dynamic> map) {
    return ListaDeCompras(
      id: map['id'],
      nome: map['nome'],
      data: map['data'],
      
      
    );
  }

}