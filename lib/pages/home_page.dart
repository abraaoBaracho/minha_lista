import 'package:flutter/material.dart';
import 'package:minha_lista/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minha Lista",
          style: TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.shopping_cart),
        backgroundColor: const Color(0xFF2E7CDB),
      ),
      body: Stack(
        children: [
          Column(
           
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  mostrarDialogo(context);
                },
                icon: const Icon(Icons.format_list_bulleted_add),
                label: const Text(
                  "Nova Lista",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF74A3DB)),
                ),
              ),

              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.LISTASALVAS);
                  },
                  icon: const Icon(Icons.save_sharp),
                  label: const Text(
                    "Listas salvas",
                    style: TextStyle(color:Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all<Color>(const Color(0xFF74A3DB)),

                  ),),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.SOBRE);
                },
                icon: const Icon(Icons.info),
                label: const Text(
                  "Sobre",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF74A3DB)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void mostrarDialogo(BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return SimpleDialog(
              title: const Text('Escolha uma opção'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(AppRoutes.LISTATAREFA);
                  },
                  child: const Text('Lista de Tarefa'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(AppRoutes.LISTACOMPRAS);
                  },
                  child: const Text('Lista de Compra'),
                )
              ]);
        }));
  }
}
