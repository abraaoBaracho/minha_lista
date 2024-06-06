import 'package:flutter/material.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:minha_lista/models/lista_tarefas.dart';
import 'package:minha_lista/repositorio/lista_compras_repositorio.dart';
import 'package:minha_lista/repositorio/produto_repositorio.dart';
import 'package:minha_lista/repositorio/tarefas_repositrio.dart';
import 'package:minha_lista/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:minha_lista/repositorio/lista_tarefas_repositorio.dart';

class ListaSalvas extends StatefulWidget {
  const ListaSalvas({super.key});

  @override
  State<ListaSalvas> createState() => _ListaSalvasState();
}

class _ListaSalvasState extends State<ListaSalvas> {
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
        backgroundColor: const Color(0xFF2E7CDB)
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
                    leading: Text(tarefa.id.toString()),
                    title: Text('${tarefa.nome}     ${tarefa.data}'),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () async {
                              String? nomeEditado = await editarListaTarefa(tarefa);
                              tarefa.nome =  nomeEditado ?? tarefa.nome;
                              int editado = await editarListaTarefaBanco(tarefa);
                      
                              if (editado > 0) {
                                const snackBar = SnackBar(
                                  content: Text('Editado com sucesso!'),
                                  duration: Durations.long4,
                                );
                                
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('A lista não foi editada'),
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
                    ),
                    onTap: () {
                      montaListaTarefa(tarefa);
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
              label: const Text('Lista de Compras:'),
            ),
            Visibility(
              visible: mostrarListaCompras,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  ListaDeCompras compras = listaDeCompras[index];
                  return ListTile(
                    leading: Text(compras.id.toString()),
                    title: Text('${compras.nome}     ${compras.data}'),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async{
                              String? novoNome = await editarListaCompra(compras);
                              compras.nome = novoNome ?? compras.nome;
                              int editado = await editarListaCompraBanco(compras);
                      
                              if (editado > 0) {
                                const snackBar = SnackBar(
                                  content: Text('Editado com sucesso!'),
                                  duration: Durations.long4,
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('A lista não foi editada'),
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
                    ),
                    onTap: () {
                      montaListaCompra(compras);
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

    if (resultado > 0) {
      return true;
    }

    return false;
  }

  Future<bool> deletarListaCompra(ListaDeCompras tarefa) async {
    final listaRepositorio = context.read<ListaComprasRepositorio>();

    int? resultado = await listaRepositorio.deleteLista(tarefa);

    if (resultado > 0) {
      return true;
    }

    return false;
  }

 Future<String?>  editarListaTarefa(ListaDeTarefas listaDeTarefas) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController texto =
        TextEditingController(text: listaDeTarefas.nome);

   return showDialog<String>(
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(texto.text);
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

  Future<String?> editarListaCompra(ListaDeCompras compras) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController texto = TextEditingController(text: compras.nome);

  return showDialog<String>(
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
              onPressed: ()  {
                if (formKey.currentState!.validate()) {
                                   
                  Navigator.of(context).pop(texto.text);
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

  Future<void> montaListaTarefa(ListaDeTarefas listaTarefas) async {
    final tarefaRepositorio = context.read<TarefaRepositorio>();
    listaTarefas.tarefas = await tarefaRepositorio.getTarefas(listaTarefas.id);
    
    redirecionarListaTarefa(listaTarefas);
  }

  void redirecionarListaTarefa(ListaDeTarefas listaTarefas) {
    Navigator.of(context)
        .pushNamed(AppRoutes.LISTATAREFASALVA, arguments: listaTarefas);
  }

  Future<void> montaListaCompra(ListaDeCompras listaDeCompras) async {
    final produtoRepositorio = context.read<ProdutoRepositorio>();
    listaDeCompras.compras =
        await produtoRepositorio.getProdutos(listaDeCompras.id);
    redirecionarListaCompra(listaDeCompras);
  }

  void redirecionarListaCompra(ListaDeCompras listaDeCompras) {
    Navigator.of(context)
        .pushNamed(AppRoutes.LISTACOMPRASALVA, arguments: listaDeCompras);
  }

  Future<int> editarListaTarefaBanco(ListaDeTarefas listaDeTarefas) async {
    final listaRepositorio = context.read<ListaTarefasRepositorio>();
    return await listaRepositorio.editarLista(listaDeTarefas);
  }

  Future<int> editarListaCompraBanco(ListaDeCompras compras) async {
    final listaRepositorio = context.read<ListaComprasRepositorio>();
    return await listaRepositorio.editarLista(compras);
  }
}
