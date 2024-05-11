import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minha_lista/models/lista_compras.dart';
import 'package:minha_lista/models/produto.dart';
import 'package:intl/intl.dart';
import 'package:minha_lista/routes/app_routes.dart';

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
  String nomeLista = '';
  ListaDeCompras lista = ListaDeCompras(nome: '', data: '');
  List<Produto> item = [];

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nome da Lista'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome da lista';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            nomeLista = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                
                setState(() {
                  nomeLista;
                });
                Navigator.of(context).pop(nomeLista);
              },
              child: const Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                 Navigator.of(context)
                        .popAndPushNamed(AppRoutes.HOME);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(nomeLista),
          backgroundColor: Colors.deepOrange[300],
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Dados salvos com sucesso!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: const Icon(Icons.save))
          ]),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(lista.compras.toString()),
            ),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final linha = lista.compras[index];
                      return ListTile(
                        leading: Text(linha.nome),
                        title: Text(real.format(linha.preco)),
                        onTap: () {},
                        trailing: Text(real.format(linha.precoTotal)),
                      );
                    },
                    padding: const EdgeInsets.all(18),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: item.length)

                ),
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
                      border: OutlineInputBorder(),
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
