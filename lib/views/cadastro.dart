import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/components/meu_snackbar.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/views/homePage.dart';
import 'package:prospere_ai/views/login.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Icon eyeIcon = Icon(Icons.visibility_off);

class _CadastroState extends State<Cadastro> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_porco.png',
                width: 200,
                height: 200,
              ),
              SizedBox(
                  width: 300,
                  child: MeuInput(
                    labelText: 'Digite o seu nome',
                    controller: nomeController,
                  )),
              SizedBox(
                  width: 300,
                  child: MeuInput(
                    labelText: 'Digite o seu E-mail',
                    controller: emailController,
                  )),
              SizedBox(
                  width: 300,
                  child: MeuInput(
                    labelText: 'Digite o seu CPF',
                    controller: cpfController,
                  )),
              SizedBox(
                  width: 300,
                  child: MeuInput(
                    labelText: 'Digite a sua Senha',
                    obscure: true,
                    controller: passwordController,
                  )),
              SizedBox(
                  width: 300,
                  child: MeuInput(
                    labelText: 'Confirme a sua Senha',
                    obscure: true,
                  )),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  print(
                      "${emailController.text}, ${cpfController.text}, ${passwordController.text},");
                  await _autenServico
                      .cadastrarUsuario(
                          email: emailController.text,
                          senha: passwordController.text,
                          cpf: cpfController.text,
                          nome: nomeController.text)
                      .then((String? erro) {
                    if (erro != null) {
                      mostrarSnackBar(context: context, texto: erro);
                    } else {
                      mostrarSnackBar(
                          context: context,
                          texto: "Cadastro efetuado com sucesso",
                          isErro: false);
                    }
                  });
                  _autenServico.deslogarUsuario();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Login(),
                  ));
                },
                child: Text('Enviar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColor,
                  minimumSize: Size(150, 50),
                ),
              ),
              SizedBox(height: 68),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: Text('Voltar para Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColor,
                  minimumSize: Size(150, 50),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        )
      ]),
    );
  }
}
