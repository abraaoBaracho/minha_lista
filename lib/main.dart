import 'package:flutter/material.dart';
import 'package:minha_lista/myapp.dart';
import 'package:minha_lista/repositorio/lista_compras_repositorio.dart';
import 'package:minha_lista/repositorio/lista_tarefas_repositorio.dart';
import 'package:provider/provider.dart';


void main() {
 
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ListaTarefasRepositorio()),
           ChangeNotifierProvider(create: (context) => ListaComprasRepositorio()),
          
        ],
    child:const MyApp() ,
    )
    );
}
