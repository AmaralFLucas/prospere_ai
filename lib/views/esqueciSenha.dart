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

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final AutenticacaoServico _autenServico = AutenticacaoServico();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 163, 132), // Cor de fundo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botão de voltar
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Voltar para a tela anterior
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Logo
              Image.asset(
                'assets/images/logo_porco.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16),
              // Campo de entrada de email
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Digite seu e-mail',
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 32),
              // Botão para continuar
              ElevatedButton(
                onPressed: () async {
                  await _autenServico.redefinirSenha(
                      email: emailController.text);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CodigoMudarSenha()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 30, 163, 132),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continuar'),
              ),
              const SizedBox(height: 20),
              // Botão para voltar para login
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text(
                  'Voltar para Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Opção para criar uma nova conta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não tem uma conta? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Cadastro()));
                    },
                    child: const Text(
                      'Criar Conta',
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
