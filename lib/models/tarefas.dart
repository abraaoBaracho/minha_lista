class Tarefas {

  String nome;
  String data;
  List<String> tarefas = [];

  Tarefas({required this.nome, required this.data});

  void addTarefa(String tarefa){
    tarefas.add(tarefa);
  }

}