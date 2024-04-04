import 'package:flutter/material.dart';

class ListaN extends StatefulWidget {
  const ListaN({super.key});

  @override
  State<ListaN> createState() => _ListaNState();
}

class _ListaNState extends State<ListaN> {
  bool textoInput = true;
  bool addItens = false;
  late String nome;
  List<String> lista = ["Feijao", "Arroz", "Macarrão", "Fubá"];
  List<String> selecionada = [];
  final GlobalKey<FormState> formChave = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text("Minha Lista"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.deepOrange[300],
      ),
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
                    nome = value!;
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
                            lista.add(nome);
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
                        final linha = lista[index];
                        var estiloTexto = TextDecoration.none;
                        if (selecionada.contains(linha)) {
                          estiloTexto = TextDecoration.lineThrough;
                        } else {
                          estiloTexto = TextDecoration.none;
                        }

                        return ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          title: Text(linha,
                              style: TextStyle(
                                  decoration: estiloTexto,
                                  color: Colors.black)),
                          selected: selecionada.contains(linha),
                          selectedTileColor:
                              const Color.fromARGB(255, 10, 236, 59),
                          onTap: () {
                            setState(() {
                              if (selecionada.contains(linha)) {
                                selecionada.remove(linha);
                              } else {
                                selecionada.add(linha);
                              }
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
                                    icon: const Icon(Icons.edit),
                                    color: const Color.fromARGB(
                                        255, 187, 174, 56)),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      lista.remove(linha);
                                    });
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
                      itemCount: lista.length)),
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
