class Produto {
  int id;
  String nome;
  double preco;
  int quant;
  double precoTotal;

  Produto({
    required this.nome,
    required this.preco,
    required this.quant,
    this.precoTotal = 0,
    this.id =0
  });

  void calcularTotal() {
    precoTotal = preco * quant;
  }

  @override
  String toString() {
    return "$nome     $preco      $quant    $precoTotal";
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      preco: map['preco'],
      quant: map['quant'],
    );
  }
}
