import 'package:flutter/material.dart';
import 'package:prospere_ai/esqueciSenha.dart';
import 'package:prospere_ai/homePage.dart';

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
                  labelText: 'Digite o seu E-mail',
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o seu CPF',
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite a sua Senha',
                  suffixIcon: IconButton(
                    icon: eyeIcon,
                    onPressed: () {
                      setState(() {
                        mostrarSenha = !mostrarSenha;
                        eyeIcon = mostrarSenha
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility);
                      });
                    },
                  ),
                ),
                obscureText: mostrarSenha,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
              
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: Size(150, 50),
              ),
            ),
            SizedBox(height: 68),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage())
                  );
              },
              child: Text('Voltar para Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: Size(150, 50),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ]
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EsqueciSenha())
                );
              },
              child: Text('Esqueci a Senha'),
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
