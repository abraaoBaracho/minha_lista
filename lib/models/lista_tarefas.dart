import 'package:flutter/material.dart';

class ListaDeTarefas extends ChangeNotifier{
  
  String nome;
  String data;
  List<String> tarefas = [];
  bool sort = false;
 

  ListaDeTarefas({required this.nome, required this.data});

  void addTarefas(String tarefa){
    tarefas.add(tarefa);
    }

  void tarefasSort(){
    if (!sort) {
      tarefas.sort((a, b) => a.compareTo(b));
      sort = true;
    } else {
      tarefas = tarefas.reversed.toList();
    }
    notifyListeners();
  }

}