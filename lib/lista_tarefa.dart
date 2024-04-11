import 'package:flutter/material.dart';
import 'package:minha_lista/models/tarefas.dart';

class ListaTarefa extends StatefulWidget {
  const ListaTarefa({super.key});

  @override
  State<ListaTarefa> createState() => _ListaTarefaState();
}

class _ListaTarefaState extends State<ListaTarefa> {
  bool textoInput = true;
  bool addItens = false;
  late String tarefa;
  Tarefas listaDeTarefas = Tarefas(nome: '01', data: '11/04/2024');
  List<String> selecionada = [];
  final GlobalKey<FormState> formChave = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Minha Lista"),
          backgroundColor: Colors.deepOrange[300],
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Dados salvos com sucesso!'),
                    duration: Durations.long4,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: const Icon(Icons.save))
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
                    labelText: "Digite o nome do produto.",
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
                          setState(() {
                            listaDeTarefas.addTarefa(tarefa);
                          });

                          formChave.currentState!.reset();
                          textoInput = false;
                          addItens = true;
                        }
                      },
                      child: const Text("Salvar"),
                    ),
                  )),
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
                              const Color.fromARGB(255, 10, 236, 59),
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

                                      if (textoEditado != null &&
                                          textoEditado.isNotEmpty) {
                                        setState(() {
                                          lista[index] = textoEditado;
                                        });
                                      } else {
                                        const snackBar = SnackBar(
                                          content: Text(
                                              'A tarefa não pode estar vazia'),
                                              duration: Durations.long4,
                                        );
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
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
              Navigator.of(context).pop(enteredText);
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
