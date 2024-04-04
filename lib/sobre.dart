import 'package:flutter/material.dart';


class Sobre extends StatelessWidget {
  const Sobre({super.key});

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
      body:  const Stack(
        children: [
          Text("A ideia do app surgiu na disciplina de Desenvolvimento Mobile do curso de Analise e Desenvolvimento de Sistemas"),
          
        ],
      ) ,
    );
  }
}