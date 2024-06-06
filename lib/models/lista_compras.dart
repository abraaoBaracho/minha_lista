import 'produto.dart';

class ListaDeCompras {
  int id;
  String nome;
  String data;
  List<Produto> compras = [];
  double precoLista;

  ListaDeCompras(
      {required this.nome,
      required this.data,
      this.precoLista = 0,
      this.id = 0}) {
    calcularPrecoTotal();
  }

  void addProduto(Produto p) {
    compras.add(p);
    calcularPrecoTotal();
  }

  void calcularPrecoTotal() {
    for (var element in compras) {
      precoLista += element.precoTotal;
    }
  }

  factory ListaDeCompras.fromMap(Map<String, dynamic> map) {
    return ListaDeCompras(
      id: map['id'],
      nome: map['nome'],
      data: map['data'],
    );
  }
}
