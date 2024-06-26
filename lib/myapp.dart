import 'package:flutter/material.dart';
import 'package:minha_lista/pages/lista_compra_salva.dart';
import 'package:minha_lista/pages/lista_salvas.dart';
import 'package:minha_lista/pages/home_page.dart';
import 'package:minha_lista/pages/lista_compra.dart';
import 'package:minha_lista/pages/lista_tarefa.dart';
import 'package:minha_lista/login/cadastro.dart';
import 'package:minha_lista/pages/lista_tarefa_salva.dart';
//import 'package:minha_lista/login/do_login.dart';
import 'package:minha_lista/routes/app_routes.dart';
import 'package:minha_lista/pages/sobre.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  
  

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: AppRoutes.HOME,
      routes: {
        AppRoutes.HOME:(context) =>   const HomePage(),
        AppRoutes.LISTASALVAS:(context) => const ListaSalvas(),
        AppRoutes.SOBRE: (context) => const Sobre(),
        AppRoutes.LISTATAREFA: (context) => const ListaTarefa(),
        AppRoutes.LISTACOMPRAS:(context) => const ListaCompras(),
        AppRoutes.CADASTRO:(context) => const Cadastrar(),
        AppRoutes.LISTATAREFASALVA: (context) => const ListaTarefaSalva(),
        AppRoutes.LISTACOMPRASALVA: (context) =>  const ListaCompraSalva(),
        
      },
    );
  }
}
