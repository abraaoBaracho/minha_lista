import 'package:flutter/material.dart';
import 'package:minha_lista/repositorio/lista_tarefas_repositorio.dart';
import 'package:provider/provider.dart';
import '../models/lista_tarefas.dart';

class ListaTarefa extends StatefulWidget {
  const ListaTarefa({super.key});

  @override
  State<ListaTarefa> createState() => _ListaTarefaState();
}

class _ListaTarefaState extends State<ListaTarefa> {
  late String tarefa;
  String nomeLista = 'Lista';
  ListaDeTarefas listaDeTarefas =
      ListaDeTarefas(nome: '', data:'');
  List<String> selecionada = [];

  @override
  Widget build(BuildContext context) {
    //final listaTarefaRepositorio = context.watch<ListaRepositorio>();

    return Scaffold(
      appBar: AppBar(
          title: Text(nomeLista),
          backgroundColor: Colors.deepOrange[300],
          actions: <Widget>[
            Visibility(
                visible: listaDeTarefas.tarefas.isNotEmpty,
                child: IconButton(
                    onPressed: () async {
                      nomeLista = (await addNome(context))!;
                      DateTime data =  DateTime.now();

                      setState(() {
                        listaDeTarefas.nome = nomeLista;
                        listaDeTarefas.data = '${data.day}/${data.month}/${data.year}';
                      });

                      bool salvar = await salvarBanco(listaDeTarefas);

                      if (salvar) {
                        const snackBar = SnackBar(
                          content: Text('Dados salvos com sucesso!'),
                          duration: Durations.long4,
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Os dados não foram salvos'),
                          duration: Durations.long4,
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    tooltip: 'Salvar',
                    icon: const Icon(Icons.save)))
          ]),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                      List<String> lista = listaDeTarefas.tarefas;
                      final linha = lista[index];
                      var estiloTexto = TextStyle(
                        decoration: selecionada.contains(linha)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: Colors.black,
                      );

                      return ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        title: Text(linha, style: estiloTexto),
                        selected: selecionada.contains(linha),
                        selectedTileColor:
                            const Color.fromARGB(255, 99, 247, 104),
                        onTap: () {
                          setState(() {
                            selecionada.contains(linha)
                                ? selecionada.remove(linha)
                                : selecionada.add(linha);
                          });
                        },
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    String? textoEditado =
                                        await editarItem(context, linha);
                                    if (textoEditado != null) {
                                      setState(() {
                                        lista[index] = textoEditado;
                                      });
                                    }
                                  },
                                  tooltip: 'Editar',
                                  icon: const Icon(Icons.edit),
                                  color:
                                      const Color.fromARGB(255, 187, 174, 56)),
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
      floatingActionButton: FloatingActionButton(
          tooltip: 'Adicionar Produto',
          onPressed: () async {
            String? texto = await addItem(context);
            if (texto != null) {
              setState(() {
                listaDeTarefas.addTarefa(texto);
              });
            }
          },
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<bool> salvarBanco(ListaDeTarefas lista) async {
    final listaTarefaRepositorio = context.read<ListaTarefasRepositorio>();
    int resultado = await listaTarefaRepositorio.addLista(lista);

    if (resultado >= 0) {
      return true;
    }

    return false;
  }
}

Future<String?> editarItem(BuildContext context, String l) {
  TextEditingController texto = TextEditingController(text: l);

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l),
        content: TextField(
          controller: texto,
          decoration:
              const InputDecoration(hintText: 'Digite o nome da tarefa'),
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

Future<String?> addItem(BuildContext context) {
  TextEditingController texto = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Adicionar Tarefa'),
        content: TextField(
          controller: texto,
          decoration:
              const InputDecoration(hintText: 'Digite o nome da tarefa'),
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

Future<String?> addNome(BuildContext context) {
  TextEditingController texto = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Digite o nome da Lista'),
        content: TextField(
          controller: texto,
          decoration: const InputDecoration(hintText: 'Digite o nome da Lista'),
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
                  content: Text('Digite o nome da lista'),
                  duration: Durations.long4,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
