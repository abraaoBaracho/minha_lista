import 'package:flutter/material.dart';
import 'package:minha_lista/routes/app_routes.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Minha Lista"),
        leading: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepOrange[300],
      ) ,
      body: Stack(
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: (){
                  mostrarDialogo(context);
                  
                  }, 
                child: const Row(
                  children: [
                    Icon(Icons.format_list_bulleted_add),
                    Text("Nova Lista"),
                  ],
                )),
                ElevatedButton(
                onPressed: (){
                   Navigator.of(context).pushNamed(AppRoutes.HISTORICO);
                }, 
                child: const Row(
                  children: [
                    Icon(Icons.history),
                    Text("Historico")
                  ],
                )),
                ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(AppRoutes.SOBRE);
                }, 
                child: const Row(
                  children: [
                    Icon(Icons.info),
                    Text("Sobre")
                  ],
                )),/*
                 ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(AppRoutes.CADASTRO);
                }, 
                child: const Row(
                  children: [
                    Icon(Icons.info),
                    Text("cadastro")
                  ],
                )),
                 ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                }, 
                child: const Row(
                  children: [
                    Icon(Icons.info),
                    Text("login")
                  ],
                )),*/
            ],
          )
        ],
      ),
    );
  }
  void mostrarDialogo(BuildContext context){
    showDialog(
      context: context, 
      builder: ((BuildContext context) {
        return SimpleDialog(
          title: const Text('Escolha uma opção'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(AppRoutes.LISTATAREFA);
              },
              child: const Text('Lista de Tarefa'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(AppRoutes.LISTACOMPRAS);
              },
              child: const Text('Lista de Compra'),
            )
      ]);
      }));
  }
}
