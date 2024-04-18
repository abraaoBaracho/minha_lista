import 'package:flutter/material.dart';
import 'package:minha_lista/models/tarefa.dart';
import 'models/lista_tarefas.dart';

class ListaTarefa extends StatefulWidget {
  const ListaTarefa({super.key});

  @override
  State<ListaTarefa> createState() => _ListaTarefaState();
}

class _ListaTarefaState extends State<ListaTarefa> {
  bool textoInput = false;
  bool addItens = true;
  late String tarefa;
  ListaDeTarefas listaDeTarefas =
      ListaDeTarefas(nome: '01', data: '11/04/2024');
  List<String> selecionada = [];
  final GlobalKey<FormState> formChave = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Minha Lista"),
          backgroundColor: Colors.deepOrange[300],
          actions: <Widget>[
            Visibility(
              visible: listaDeTarefas.tarefas.isNotEmpty,
                child: IconButton(
                    onPressed: () {
                      const snackBar = SnackBar(
                        content: Text('Dados salvos com sucesso!'),
                        duration: Durations.long4,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    tooltip: 'Salvar',
                    icon: const Icon(Icons.save)))
          ]),
      body: Form(
        key: formChave,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: textoInput,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Digite o nome da tarefa.",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo é obrigatório.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    tarefa = value!;
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Visibility(
                    visible: textoInput,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formChave.currentState!.validate()) {
                          formChave.currentState!.save();
                          Tarefa t = Tarefa(tarefa: tarefa);
                          setState(() {
                            listaDeTarefas.addTarefas(t);
                          });

                          formChave.currentState!.reset();
                          textoInput = false;
                          addItens = true;
                        }
                      },
                      child: const Text("Adicionar"),
                    ),
                  )),
              Visibility(
                visible: listaDeTarefas.tarefas.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      listaDeTarefas.tarefasSort();
                    });
                  },
                  tooltip: 'Ordenar',
                  icon: const Icon(Icons.swap_vert),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        List<Tarefa> lista = listaDeTarefas.tarefas;
                        final linha = lista[index];
                        var estiloTexto = TextStyle(
                          decoration: selecionada.contains(linha.tarefa)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: Colors.black,
                        );

                        return ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          title: Text(linha.tarefa, style: estiloTexto),
                          selected: selecionada.contains(linha.tarefa),
                          selectedTileColor:
                              const Color.fromARGB(255, 99, 247, 104),
                          onTap: () {
                            setState(() {
                              selecionada.contains(linha.tarefa)
                                  ? selecionada.remove(linha.tarefa)
                                  : selecionada.add(linha.tarefa);
                            });
                          },
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      String? textoEditado = await editarItem(
                                          context, linha.tarefa);
                                      if (textoEditado != null) {
                                        Tarefa t = Tarefa(
                                            tarefa: textoEditado.toString());

                                        setState(() {
                                          lista[index] = t;
                                        });
                                      }
                                    },
                                    tooltip: 'Editar',
                                    icon: const Icon(Icons.edit),
                                    color: const Color.fromARGB(
                                        255, 187, 174, 56)),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      lista.remove(linha);
                                    });
                                    const snackBar = SnackBar(
                                      content: Text('A tarefa foi removida'),
                                      duration: Durations.long4,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Remover',
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(18),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: listaDeTarefas.tarefas.length)),
            ]),
      ),
      floatingActionButton: Visibility(
        visible: addItens,
        child: FloatingActionButton(
            tooltip: 'Adicionar Produto',
            onPressed: () {
              setState(() {
                textoInput = true;
                addItens = false;
              });
            },
            child: const Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Future<String?> editarItem(BuildContext context, String l) {
  TextEditingController texto = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l),
        content: TextField(
          controller: texto,
          decoration:
              const InputDecoration(hintText: 'Digite o nome do produto'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Salvar'),
            onPressed: () {
              String enteredText = texto.text;
              if (enteredText.isNotEmpty) {
                Navigator.of(context).pop(enteredText);
              } else {
                const snackBar = SnackBar(
                  content: Text('A tarefa não pode estar vazia'),
                  duration: Durations.long4,
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
