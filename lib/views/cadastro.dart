import 'package:flutter/material.dart';
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/services/firebase_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  'assets/images/logo_porco.png',
                  width: 200,
                  height: 200,
                ),
            SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: MeuInput(
                labelText: 'Digite o seu E-mail',
                controller: emailController,
              )
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: MeuInput(labelText: 'Digite o seu CPF')
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: MeuInput(
                labelText: 'Digite a sua Senha',
                obscure: true,
                controller: passwordController,
                )
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                createUser(emailController, passwordController);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login())
                  );
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
                    MaterialPageRoute(builder: (context) => const Login())
                  );
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
      ]),
    );
  }
}
