class Tarefa {
  int id;
  String nome;
  bool concluida;

  Tarefa({required this.nome, this.id = 0, this.concluida = false});

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
        id: map['id'], nome: map['nome'], concluida: map['concluida'] == 1);
  }
}
