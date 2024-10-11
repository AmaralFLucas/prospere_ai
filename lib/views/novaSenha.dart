import 'package:flutter/material.dart';
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/views/cadastro.dart';
import 'package:prospere_ai/views/login.dart';

class NovaSenha extends StatefulWidget {
  const NovaSenha({super.key});

  @override
  State<NovaSenha> createState() => _NovaSenhaState();
}

PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = const Color.fromARGB(255, 30, 163, 132);
Icon eyeIcon = const Icon(Icons.visibility_off);

class _NovaSenhaState extends State<NovaSenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/novalogo_porco2.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const SizedBox(
                width: 300,
                child: MeuInput(labelText: 'Digite uma nova senha')),
            const SizedBox(height: 16),
            const SizedBox(
                width: 300,
                child: MeuInput(labelText: 'Digite a senha novamente')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: const Size(150, 50),
              ),
              child: Text('Enviar'),
            ),
            const SizedBox(height: 68),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: const Size(150, 50),
              ),
              child: Text('Voltar para Login'),
            ),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 125,
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(width: 15),
              const Text('OU'),
              const SizedBox(width: 15),
              Container(
                width: 125,
                height: 2,
                color: Colors.black,
              ),
            ]),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Cadastro()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: const Size(150, 50),
              ),
              child: Text('Criar Conta'),
            )
          ],
        ),
      ]),
    );
  }
}
