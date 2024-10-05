import 'package:flutter/material.dart';
import 'package:prospere_ai/views/cadastro.dart';
import 'package:prospere_ai/views/inicioCadastro.dart'; 
import 'package:prospere_ai/views/login.dart';
import 'package:prospere_ai/views/termos_de_uso.dart'; 
import 'package:prospere_ai/views/politica_de_privacidade.dart';

class InicioLogin extends StatelessWidget {
  const InicioLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 163, 132), // Cor de fundo
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mensagem de boas-vindas
              const Text(
                'Bem-vindo de volta!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Opção para logar com Google
              ElevatedButton.icon(
                onPressed: (){},

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 30, 163, 132),
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: Image.asset(
                  'assets/images/google_logo.png', // A logo do Google
                  width: 24,
                  height: 24,
                ),
                label: const Text('Continuar com Google'),
              ),
              const SizedBox(height: 20),
              // Opção para continuar com e-mail e senha
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 30, 163, 132),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continuar com E-mail e Senha'),
              ),
              const SizedBox(height: 30),
              // Opção para se cadastrar
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const InicioCadastro()),
                  );
                },
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Termos de uso e política de privacidade
              const Text(
                'Ao continuar, estou de acordo com os termos de uso e política de privacidade do Prospere.AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const TermosDeUso()),
                      );
                    },
                    child: const Text(
                      'Termos de Uso',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                const PoliticaDePrivacidade()),
                      );
                    },
                    child: const Text(
                      'Política de Privacidade',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
