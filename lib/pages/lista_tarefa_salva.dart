import 'package:flutter/material.dart';
import 'package:minha_lista/models/tarefa.dart';
import 'package:minha_lista/repositorio/lista_tarefas_repositorio.dart';
import 'package:minha_lista/repositorio/tarefas_repositrio.dart';
import 'package:provider/provider.dart';
import '../models/lista_tarefas.dart';

class ListaTarefaSalva extends StatefulWidget {
  const ListaTarefaSalva({
    super.key,
  });

  @override
  State<ListaTarefaSalva> createState() => _ListaTarefaSalvaState();
}

class _ListaTarefaSalvaState extends State<ListaTarefaSalva> {
  late String tarefa;
  List<Tarefa> deletadas = [];

  @override
  Widget build(BuildContext context) {
    final tarefaRepositorio = context.read<TarefaRepositorio>();
    ListaDeTarefas? listaDeTarefas =
        ModalRoute.of(context)!.settings.arguments as ListaDeTarefas;
    return Scaffold(
      appBar: AppBar(
          title: Text(listaDeTarefas.nome,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF2E7CDB),
          actions: <Widget>[
            Visibility(
                visible: listaDeTarefas.tarefas.isNotEmpty,
                child: IconButton(
                    onPressed: () async {
                       bool salvar;
                      var nomeLista =
                          await addNome(context, listaDeTarefas.nome);
                      DateTime data = DateTime.now();

                      setState(() {
                        if (nomeLista != null) {
                          listaDeTarefas.nome = nomeLista;
                        }

                        listaDeTarefas.data =
                            '${data.day}/${data.month}/${data.year}';
                      });

                      salvar = await editarBanco(listaDeTarefas);

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
                      final linha = listaDeTarefas.tarefas[index];
                      var estiloTexto = TextStyle(
                        decoration: linha.concluida
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: Colors.black,
                      );

                      return ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        title: Text(linha.nome, style: estiloTexto),
                        selected: linha.concluida,
                        selectedTileColor:
                            const Color.fromARGB(127, 1, 219, 117),
                        onTap: () {
                          setState(() {
                            linha.concluida
                                ? linha.concluida = false
                                : linha.concluida = true;
                          });
                        },
                        onLongPress: () {
                          var snackBar = SnackBar(
                            content: Text(linha.id.toString()),
                            duration: Durations.long4,
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    String? textoEditado =
                                        await editarTarefa(context, linha.nome);
                                    if (textoEditado != null) {
                                      setState(() {
                                        linha.nome = textoEditado;
                                        listaDeTarefas.tarefas[index] = linha;
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
                                   deletadas.add(linha);
                                      listaDeTarefas.tarefas.remove(linha);
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
                Tarefa tarefa = Tarefa(nome: texto);
                tarefaRepositorio.addTarefa(tarefa, listaDeTarefas.id);
                listaDeTarefas.addTarefa(tarefa);
              });
            }
          },
          backgroundColor: const Color(0xFF74A3DB),
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

   Future<bool> editarBanco(ListaDeTarefas lista) async {
    final listaTarefaRepositorio = context.read<ListaTarefasRepositorio>();
    final tarefaRepositorio = context.read<TarefaRepositorio>();

    int resultado = await listaTarefaRepositorio.editarLista(lista);

    for (var element in lista.tarefas) {
      if (element.id == 0) {
        resultado =
            await tarefaRepositorio.addTarefa(element, lista.id);
      } else {
        resultado = await tarefaRepositorio.editarTarefa(element);
      }
    }
    for (var element in deletadas) {
      resultado = await tarefaRepositorio.deleteTarefa(element);
    }

    if (resultado > 0) {
      return true;
    }
    return false;
  }

  Future<String?> editarTarefa(BuildContext context, String l) {
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

  Future<String?> addNome(BuildContext context, String nome) {
    TextEditingController texto = TextEditingController(text: nome);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Digite o nome da Lista'),
          content: TextField(
            controller: texto,
            decoration:
                const InputDecoration(hintText: 'Digite o nome da Lista'),
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
}
