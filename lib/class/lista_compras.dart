

import 'produto.dart';

class Lista {
  List<Produto> compras = [];

  void addProduto(Produto p) {
    compras.add(p);
  }

  List<Produto> getLista() {
    return compras;
  }
}