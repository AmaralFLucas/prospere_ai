import 'package:flutter/material.dart';
import 'package:prospere_ai/views/Login.dart';
import 'package:prospere_ai/views/cadastro.dart';
import 'package:prospere_ai/views/novaSenha.dart';


class CodigoMudarSenha extends StatefulWidget {
  const CodigoMudarSenha({super.key});

  @override
  State<CodigoMudarSenha> createState() => _CodigoMudarSenhaState();
}

PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Icon eyeIcon = Icon(Icons.visibility_off);

class _CodigoMudarSenhaState extends State<CodigoMudarSenha> {
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
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o Código enviado para o seu e-mail',
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('Botao enviar clicado');
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NovaSenha())
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
              onPressed: () {Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login())
                  );},
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
                      MaterialPageRoute(builder: (context) => const Cadastro())
                    );},
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
