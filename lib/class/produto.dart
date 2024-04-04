class Produto {
  String nome;
  double preco;
  int quant;
  double precoTotal = 0;

  Produto(
    this.nome,
    this.preco,
    this.quant,
  );

  void calcularTotal() {
    precoTotal = preco * quant;
  }

  @override
  String toString() {
    return "$nome     $preco      $quant    $precoTotal";
  }
}
