import 'package:flutter/material.dart';
import 'package:minha_lista/historico.dart';
import 'package:minha_lista/home_page.dart';
import 'package:minha_lista/lista_tarefa.dart';
import 'package:minha_lista/lista_compra.dart';
import 'package:minha_lista/login/cadastro.dart';
import 'package:minha_lista/login/do_login.dart';
import 'package:minha_lista/routes/app_routes.dart';
import 'package:minha_lista/sobre.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: AppRoutes.HOME,
      routes: {
        AppRoutes.HOME:(context) =>   const HomePage(),
        AppRoutes.HISTORICO:(context) => const Historico(),
        AppRoutes.SOBRE: (context) => const Sobre(),
        AppRoutes.LISTATAREFA: (context) => const ListaTarefa(),
        AppRoutes.LISTACOMPRAS:(context) => const ListaCompras(),
        AppRoutes.CADASTRO:(context) => const Cadastrar(),
        AppRoutes.LOGIN: (context) => const DoLogin(),
        
      },
    );
  }
}