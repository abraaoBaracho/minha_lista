import 'package:flutter/material.dart';


class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text(
          "Minha Lista",
          style: TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.shopping_cart),
        backgroundColor: const Color(0xFF2E7CDB),
      ),
      body:  const Stack(
        children: [
          Text("A ideia do app surgiu na disciplina de Desenvolvimento Mobile do curso de Analise e Desenvolvimento de Sistemas"),
          
        ],
      ) ,
    );
  }
}