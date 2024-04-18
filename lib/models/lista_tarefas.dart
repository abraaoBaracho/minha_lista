import 'package:flutter/material.dart';
import 'package:minha_lista/models/tarefa.dart';

class ListaDeTarefas extends ChangeNotifier{
  
  String nome;
  String data;
  List<Tarefa> tarefas = [];
  bool sort = false;
 

  ListaDeTarefas({required this.nome, required this.data});

  void addTarefas(Tarefa tarefa){
    tarefas.add(tarefa);
    }

  void tarefasSort(){
    if (!sort) {
      tarefas.sort((a, b) => a.tarefa.compareTo(b.tarefa));
      sort = true;
    } else {
      tarefas = tarefas.reversed.toList();
    }
    notifyListeners();
  }

}