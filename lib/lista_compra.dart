import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> formChave = GlobalKey<FormState>();
  late String nome;
  late double preco;
  late int quant;
  String tipo = 'preco';
  ListaDeCompras lista = ListaDeCompras(nome: '', data: '', tipo: '');
  List <Produto> item = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Minha Lista"),
          backgroundColor: Colors.deepOrange[300],
          actions: <Widget>[
          IconButton(onPressed: (){
            const snackBar = SnackBar(
                content: Text('Dados salvos com sucesso!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }, icon: const Icon(Icons.save))
        ]
        ),
        body:
            Form(
          key: formChave,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
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
                    nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Digite o preço do produto.",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo é obrigatório.';
                    } else if (double.parse(value) <= 0) {
                      return 'Infome um valor maior que zero';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    preco = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Digite a quantidade do produto.",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo é obrigatório.';
                    } else if (int.parse(value) < 1) {
                      return 'Quantidade minima "1"';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    quant = int.parse(value!);
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formChave.currentState!.validate()) {
                          formChave.currentState!.save();
                          Produto p = Produto(nome: nome, preco: preco, quant: quant);
                          p.calcularTotal();

                          setState(() {
                            lista.addProduto(p);
                             item = lista.compras;//lista.getLista();
                          });

                          formChave.currentState!.reset();
                        }
                      },
                      child: const Text("Salvar"),
                    )),
                    
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index){
                      final linha = item[index];
                      return ListTile(
                        leading: Text(linha.nome),
                        title: Text(real.format(linha.preco)),
                        onTap: (){
                          
                        },
                        trailing: Text(real.format(linha.precoTotal)) ,
                      );
                    }, 
                    padding: const EdgeInsets.all(18),
                    separatorBuilder: (_, __) => const Divider(), 
                    itemCount: item.length)
                  
                  
                  
                  
                  /* ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      final linha = item[index];
                      return 
                      ListTile(
                        title: Text(linha.nome),

                        
                      );
                    },
                  ),*/
                ),
              ]),
        ));
  }
}
