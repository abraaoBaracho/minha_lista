class Produto {
  int id;
  String nome;
  double preco;
  int quant;
  double precoTotal;

  Produto({
    this.id = 0,
    required this.nome,
    required this.preco,
    required this.quant,
    double? precoTotal,
  }) : precoTotal = precoTotal ?? preco * quant;

  void calcularTotal() {
    precoTotal = preco * quant;
  }

  @override
  String toString() {
    return "$nome     $preco      $quant    $precoTotal";
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'] ?? 0,
      nome: map['nome'] ?? '',
      preco: map['valor']?.toDouble() ?? 0.0,
      quant: map['quantidade'] ?? 0,
      precoTotal: (map['valor']?.toDouble() ?? 0.0) * (map['quantidade'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'valor': preco,
      'quantidade': quant,
      'precoTotal': precoTotal,
    };
  }
}
