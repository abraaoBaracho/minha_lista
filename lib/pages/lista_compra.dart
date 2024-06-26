import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:minha_lista/models/produto.dart';
import 'package:intl/intl.dart';
import 'package:minha_lista/repositorio/lista_compras_repositorio.dart';
import 'package:minha_lista/repositorio/produto_repositorio.dart';
import 'package:provider/provider.dart';

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
  ListaDeCompras listaCompras = ListaDeCompras(nome: 'Lista', data: '');
  bool estaSalva = false;

  @override
  Widget build(BuildContext context) {
     final produtoRepositorio = context.read<ProdutoRepositorio>();
    return Scaffold(
      appBar: AppBar(
          title: Text(listaCompras.nome, style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF2E7CDB),
          actions: <Widget>[
            Visibility(
              visible: listaCompras.compras.isNotEmpty,
              child: IconButton(
                  onPressed: () async {
                    bool salvar;

                      if (!estaSalva) {
                        var nomeLista = await addNome(context);
                        DateTime data = DateTime.now();

                        setState(() {
                          if (nomeLista != null) {
                            listaCompras.nome = nomeLista;
                          }

                          listaCompras.data =
                              '${data.day}/${data.month}/${data.year}';
                        });

                        salvar = await salvarBanco(listaCompras);
                        estaSalva = salvar;
                        
                      } else {
                        var nomeLista = await addNome(context);
                        DateTime data = DateTime.now();

                        setState(() {
                          if (nomeLista != null) {
                            listaCompras.nome = nomeLista;
                          }

                          listaCompras.data =
                              '${data.day}/${data.month}/${data.year}';
                        });

                        salvar = await editaBanco(listaCompras);
                      }

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
                  DataColumn(label: Text('Quant')),
                  DataColumn(label: Text('Preço total')),
                  
                ],
                rows: listaCompras.compras.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.nome)),
                    DataCell(Text(real.format(item.preco))),
                    DataCell(Text(item.quant.toString())),
                    DataCell(
                      Text(real.format(item.precoTotal)),
                    ),
                  ],
                  onLongPress: () async{
                    int? escolha = await mostarOpcoes(item);

                    if (escolha == 1 ) {
                      // ignore: use_build_context_synchronously
                      Produto? produto = await editarItem(context, item);
                      listaCompras.compras.add(produto!);
                    }else if(escolha == 2){
                      deletaItem(item);
                    }
                  },);
                }).toList(),
              ),
            ),
            Expanded(child: Text('Valor Total:${real.format(listaCompras.precoLista)}'))
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
                
                if (estaSalva) {
                  produtoRepositorio.addProduto(p, listaCompras.id);
                   listaCompras.addProduto(p);
                }else{
                   listaCompras.addProduto(p);
                }
               
              });
            }
          },
          backgroundColor: const Color(0xFF74A3DB),
          child: const Icon(Icons.add),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<bool> salvarBanco(ListaDeCompras lista) async {
    final listaComprasRepositorio = context.read<ListaComprasRepositorio>();
    final produtoRepositorio = context.read<ProdutoRepositorio>();
    int resultado = await listaComprasRepositorio.addLista(lista);

     if (resultado > 0) {

     listaCompras = listaComprasRepositorio.lista.last;
      for (var element in lista.compras) {
        
       resultado = await produtoRepositorio.addProduto(element, listaCompras.id);
      }
      listaCompras.compras = await produtoRepositorio.getProdutos(listaCompras.id);
    }

    if (resultado > 0) {
      return true;
    }
    return false;
  }

  Future<bool> editaBanco(ListaDeCompras lista) async {
    final listaComprasRepositorio = context.read<ListaComprasRepositorio>();
   

    int resultado = await listaComprasRepositorio.editarLista(lista);


    if (resultado > 0) {
      return true;
    }
    return false;
  }
  
  Future<int?> mostarOpcoes(Produto produto) {
    int escola;
    return showDialog<int>(
        context: context,
        builder: ((BuildContext context) {
          return SimpleDialog(
              title: const Text('Escolha uma opção'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    escola = 1;
                   Navigator.of(context).pop(escola);
                  },
                  child: const Text('Editar'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    escola = 2;
                   Navigator.of(context).pop(escola);
                  },
                  child: const Text('Deletar'),
                ),
                SimpleDialogOption(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                )
              ]);
        }));
  }
  
  void deletaItem(Produto produto) async {
    
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

Future<Produto?> editarItem(
    BuildContext context, Produto item) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nomeController =
      TextEditingController(text: item.nome);
  TextEditingController precoController =
      TextEditingController(text: item.preco.toString());
  TextEditingController quantidadeController =
      TextEditingController(text: item.quant.toString());

  return showDialog<Produto>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar ${item.nome}'),
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
                  'precoTotal': double.parse(precoController.text) *
                      int.parse(quantidadeController.text),
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
