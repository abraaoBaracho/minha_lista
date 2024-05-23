import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:minha_lista/models/produto.dart';
import 'package:intl/intl.dart';

class ListaCompras extends StatefulWidget {
  const ListaCompras({super.key});

  @override
  State<ListaCompras> createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_br', name: 'R\$');
  late String nome;
  late double preco;
  late int quant;
  String nomeLista = 'Lista';
  ListaDeCompras lista = ListaDeCompras(nome: '', data: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(nomeLista),
          backgroundColor: Colors.deepOrange[300],
          actions: <Widget>[
            Visibility(
              visible: lista.compras.isNotEmpty,
              child: IconButton(
                  onPressed: () async {
                    nomeLista = (await addNome(context))!;

                    setState(() {
                      lista.nome = nomeLista;
                    });
                    //listaRepositorio.addLista(listaDeTarefas.nome, 'data');
                    const snackBar = SnackBar(
                      content: Text('Dados salvos com sucesso!'),
                      duration: Durations.long4,
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: const Icon(Icons.save)),
            )
          ]),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Produto')),
                  DataColumn(label: Text('Preço')),
                  DataColumn(label: Text('Quantidade')),
                  DataColumn(label: Text('Preço total')),
                  DataColumn(label: Text('Contole')),
                ],
                rows: lista.compras.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item['nome'].toString())),
                    DataCell(Text(item['preco'].toString())),
                    DataCell(Text(item['quantidade'].toString())),
                    DataCell(Text(item['precoTotal'].toString()),),
                    DataCell(Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              Map<String, dynamic>? itemEditado = await editarItem(context, item);
                              if (itemEditado != null){
                                setState(() {
                                   
                                  item['nome'] = itemEditado['nome'];
                                  item['preco']= itemEditado['preco'];
                                  item['quantidade'] = itemEditado['quantidade'];
                                  item['precoTotal']= itemEditado['precoTotal'];
                                
                                });
                              }
                            }, 
                            icon: const Icon(Icons.edit),
                            color: const Color.fromARGB(
                                      255, 187, 174, 56)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              lista.compras.remove(item);
                              
                              const snackBar = SnackBar(
                                content: Text('A tarefa foi removida'),
                                duration: Durations.long4,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        )
                      ],
                    ))
                  ]);
                }).toList(),
              ),
            ),
            Expanded(child: Text('Valor Total:${lista.precoLista}'))
          ]),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Adicionar Produto',
          onPressed: () async {
            Map<String, dynamic>? resultado = await addItem(context);
            if (resultado != null) {
              setState(() {
                nome = resultado['nome'];
                preco = resultado['preco'];
                quant = resultado['quantidade'];
                Produto p = Produto(nome: nome, preco: preco, quant: quant);
                p.calcularTotal();

                lista.addProduto(p);
              });
            }
          },
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Future<Map<String, dynamic>?> addItem(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? nome;
  int? quantidade;
  double? preco;

  return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Produto'),
          content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome do produto',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira o nome do produto.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      nome = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Valor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira o valor do produto.';
                      } else if (double.tryParse(value) == null) {
                        return 'Por favor, insira apenas números.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      preco = double.tryParse(value);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.add_shopping_cart_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira a quantidade.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      quantidade = int.tryParse(value);
                    },
                  ),
                ],
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'nome': nome,
                    'preco': preco,
                    'quantidade': quantidade,
                  });
                }
              },
              child: const Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      });
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

Future<Map<String, dynamic>?> editarItem(BuildContext context, Map<String, dynamic> item) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController(text: item['nome']);
  TextEditingController precoController = TextEditingController(text: item['preco'].toString());
  TextEditingController quantidadeController = TextEditingController(text: item['quantidade'].toString());

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar ${item['nome']}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome do produto.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o valor do produto.';
                  } else if (double.tryParse(value) == null) {
                    return 'Por favor, insira apenas números.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add_shopping_cart_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a quantidade.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop({
                  'nome': nomeController.text,
                  'preco': double.parse(precoController.text),
                  'quantidade': int.parse(quantidadeController.text),
                  'precoTotal': double.parse(precoController.text) * int.parse(quantidadeController.text),
                });
              }
            },
            child: const Text('Salvar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}