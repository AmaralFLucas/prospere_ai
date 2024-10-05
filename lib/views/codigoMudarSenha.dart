import 'package:flutter/material.dart';
import 'package:prospere_ai/views/login.dart';

class CodigoMudarSenha extends StatefulWidget {
  const CodigoMudarSenha({super.key});

  @override
  State<CodigoMudarSenha> createState() => _CodigoMudarSenhaState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class _CodigoMudarSenhaState extends State<CodigoMudarSenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/novalogo_porco2.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Um e-mail foi enviado para o endereço informado com as instruções para reset de senha. Por favor, verifique sua caixa de entrada.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: const Size(150, 50),
              ),
              child: const Text('Voltar para Login'),
            ),
          ],
        ),
      ),
    );
  }
}
