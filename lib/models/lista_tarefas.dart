
class ListaDeTarefas {
  
  int id;
  String nome;
  String data;
  List<String> tarefas = [];
  bool sort = false;
 

  ListaDeTarefas({required this.nome, required this.data, this.id = 0});

  void addTarefa(String tarefa){
    tarefas.add(tarefa);

    }

  void tarefasSort(){
    if (!sort) {
      tarefas.sort((a, b) => a.compareTo(b));
      sort = true;
    } else {
      tarefas = tarefas.reversed.toList();
      sort = false;
    }

  }

  factory ListaDeTarefas.fromMap(Map<String, dynamic> map) {
    return ListaDeTarefas(
      id: map['id'],
      nome: map['nome'],
      data: map['data'],

    );
  }

 

}