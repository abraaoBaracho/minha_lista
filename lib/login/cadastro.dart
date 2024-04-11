
import 'package:flutter/material.dart';
import 'package:minha_lista/models/usuario.dart';
import 'package:minha_lista/routes/app_routes.dart';

class Cadastrar extends StatefulWidget {
  const Cadastrar({super.key});

  @override
  State<Cadastrar> createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  final GlobalKey<FormState> formChave = GlobalKey<FormState>();
  late String email;
  late String user;
  late String senha;
  String linha = '';
  bool botaoOcultar = true;

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
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Digite seu Email",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.contains("@") && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Este campo é obrigatório.';
                }
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Digite seu Usuario",
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo é obrigatório.';
                }
                return null;
              },
              onSaved: (value) {
                user = value!;
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
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
              onSaved: (value) {
                senha = value!;
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, ),
                  onPressed: () {
                    if (formChave.currentState!.validate()) {
                      formChave.currentState!.save();
                      setState(() {
                        
                       Usuario u = validarCadastro(
                            email: email, user: user, senha: senha);
                        Navigator.of(context).popAndPushNamed(AppRoutes.LOGIN, arguments: u);
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

Usuario validarCadastro({String? email, String? user, String? senha}) {
  Usuario u = Usuario(user!, email!, senha!, 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');
   return u;
}
