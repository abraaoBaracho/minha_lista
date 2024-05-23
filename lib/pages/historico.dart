import 'package:flutter/material.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:minha_lista/models/lista_tarefas.dart';
import 'package:minha_lista/repositorio/lista_compras_repositorio.dart';
import 'package:provider/provider.dart';
import 'package:minha_lista/repositorio/lista_tarefas_repositorio.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  bool mostrarListaTarefas = true;
  bool mostrarListaCompras = true;
  @override
  Widget build(BuildContext context) {
    final listaTarefasRepositrio = context.watch<ListaTarefasRepositorio>();
    List<ListaDeTarefas> listaDeTarefas = listaTarefasRepositrio.lista;
    final listaComprasRepositrio = context.watch<ListaComprasRepositorio>();
    List<ListaDeCompras> listaDeCompras = listaComprasRepositrio.lista;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Lista"),
        backgroundColor: Colors.deepOrange[300],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //lista tarefas
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    mostrarListaTarefas
                        ? mostrarListaTarefas = false
                        : mostrarListaTarefas = true;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
                label: const Text('Lista de Tarefas:')),
            Visibility(
              visible: mostrarListaTarefas,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  ListaDeTarefas tarefa = listaDeTarefas[index];
                  return ListTile(
                    leading: Text(tarefa.nome),
                    title: Text(tarefa.data),
                    subtitle: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            bool editado = await editarListaTarefa(tarefa);
                            if (editado) {
                              const snackBar = SnackBar(
                                content: Text('Editado com sucesso!'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('A lista não foi deletada'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: const Icon(Icons.edit),
                          color: const Color.fromARGB(255, 187, 174, 56),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool deletado = await deletarListaTarefa(tarefa);
                            if (deletado) {
                              const snackBar = SnackBar(
                                content: Text('Lista deletada com sucesso!'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('A lista não foi deletada'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        )
                      ],
                    ),
                    onTap: () {
                      var snackBar = SnackBar(
                                content: Text(tarefa.id.toString()),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                    },
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: listaDeTarefas.length,
              ),
            ),
            //lista de compras
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    mostrarListaCompras
                        ? mostrarListaCompras = false
                        : mostrarListaCompras = true;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
                label: const Text('Lista de Compras:')),
            Visibility(
              visible: mostrarListaCompras,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  ListaDeCompras compras = listaDeCompras[index];
                  return ListTile(
                    title: Text('${compras.nome}     ${compras.data}'),
                    subtitle: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            bool editado = await editarListaCompra(compras);
                            if (editado) {
                              const snackBar = SnackBar(
                                content: Text('Editado com sucesso!'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('A lista não foi deletada'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: const Icon(Icons.edit),
                          color: const Color.fromARGB(255, 187, 174, 56),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool deletado = await deletarListaCompra(compras);
                            if (deletado) {
                              const snackBar = SnackBar(
                                content: Text('Lista deletada com sucesso!'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('A lista não foi deletada'),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        )
                      ],
                    ),
                    onTap: () {
                      var snackBar = SnackBar(
                                content: Text(compras.id.toString()),
                                duration: Durations.long4,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                    },
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: listaDeCompras.length,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<bool> deletarListaTarefa(ListaDeTarefas tarefa) async {
    final listaRepositorio = context.read<ListaTarefasRepositorio>();

    int? resultado = await listaRepositorio.deleteLista(tarefa);

    if (resultado >= 0) {
      return true;
    }

    return false;
  }

  Future<bool> deletarListaCompra(ListaDeCompras tarefa) async {
    final listaRepositorio = context.read<ListaComprasRepositorio>();

    int? resultado = await listaRepositorio.deleteLista(tarefa);

    if (resultado >= 0) {
      return true;
    }

    return false;
  }

  Future<bool> editarListaTarefa(ListaDeTarefas listaDeTarefas) async {
    final listaRepositorio = context.read<ListaTarefasRepositorio>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController texto =
        TextEditingController(text: listaDeTarefas.nome);
    int? resultado;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(listaDeTarefas.nome),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: texto,
                  decoration: const InputDecoration(
                      labelText: 'Digite o nome da tarefa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome do produto.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  listaDeTarefas.nome = texto.text;

                  resultado =
                      await listaRepositorio.editarLista(listaDeTarefas);
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
    if (resultado! >= 0) {
      return true;
    }
    return false;
  }

  Future<bool> editarListaCompra(ListaDeCompras compras) async {
    final listaRepositorio = context.read<ListaComprasRepositorio>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController texto = TextEditingController(text: compras.nome);
    int? resultado;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(compras.nome),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: texto,
                  decoration: const InputDecoration(
                      labelText: 'Digite o nome da tarefa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome do produto.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  compras.nome = texto.text;

                  resultado = await listaRepositorio.editarLista(compras);
                  // ignore: use_build_context_synchronously
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
    if (resultado! >= 0) {
      return true;
    }
    
    return false;
    
  }
}
