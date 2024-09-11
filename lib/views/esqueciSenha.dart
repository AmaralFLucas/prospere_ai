import 'package:flutter/material.dart';
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/views/cadastro.dart';
import 'package:prospere_ai/views/codigoMudarSenha.dart';
import 'package:prospere_ai/views/login.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Icon eyeIcon = Icon(Icons.visibility_off);

class _EsqueciSenhaState extends State<EsqueciSenha> {
  AutenticacaoServico _autenServico = AutenticacaoServico();
  TextEditingController emailController = TextEditingController();

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
                  labelText: 'Digite seu e-mail',
                  controller: emailController,
                )),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _autenServico.redefinirSenha(email: emailController.text);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CodigoMudarSenha()));
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 125,
                height: 2,
                color: Colors.black,
              ),
              SizedBox(width: 15),
              Text('OU'),
              SizedBox(width: 15),
              Container(
                width: 125,
                height: 2,
                color: Colors.black,
              ),
            ]),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Cadastro()));
              },
              child: Text('Criar Conta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: Size(150, 50),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
