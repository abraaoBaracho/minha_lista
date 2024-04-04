

import 'package:flutter/material.dart';
import 'package:minha_lista/models/usuario.dart';

class DoLogin extends StatefulWidget {
  const DoLogin({super.key});

  @override
  State<DoLogin> createState() => _DoLoginState();
}

class _DoLoginState extends State<DoLogin> {

  final GlobalKey<FormState> formChave = GlobalKey<FormState>();
  late String usuario;
  late String senha;
  String linha = '';
  bool botaoOcultar = true;

  @override
  Widget build(BuildContext context) {
    final u = ModalRoute.of(context)!.settings.arguments as Usuario;
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
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Digite seu Email ou seu Usuario",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Este campo é obrigatório.';
                }
              },
              onSaved: (value) {
                usuario = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Digite sua Senha",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          botaoOcultar = !botaoOcultar;
                        });
                      },
                      icon: Icon(botaoOcultar
                          ? Icons.visibility_off
                          : Icons.visibility))),
              obscureText: botaoOcultar,
              obscuringCharacter: '*',
              validator: (value) {
                if (value == null || value.isEmpty && value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
              onSaved: (value) {
                senha = value!;
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formChave.currentState!.validate()) {
                      formChave.currentState!.save();
                      setState(() {
                         if (validarCadastro(usuario: usuario,senha: senha, u: u)) {
                           linha = "Funcionou";
                         }else{
                          linha = "Erro";
                         }
                      });

                      formChave.currentState!.reset();
                    }
                  },
                  child: const Text(
                    "Salvar",
                  ),
                )),
            Text(linha),
          ],
        ),
      ),
    );
  }
}

bool validarCadastro({String? usuario, String? senha, Usuario? u}) {
  if (usuario!.contains('@')) {
    if (u?.email == usuario && u?.senha == senha) {
      return true;
    }
    return false;
  }else{
    if (u?.nome == usuario && u?.senha == senha) {
      return true;
    }
    return false;
  }
}