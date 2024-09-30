import 'package:flutter/material.dart';
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/views/cadastro.dart';
import 'package:prospere_ai/views/esqueciSenha.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AutenticacaoServico _autenServico = AutenticacaoServico();
  final _formKey = GlobalKey<FormState>();

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
              // Formulário de login
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: MeuInput(
                        labelText: 'Email',
                        controller: emailController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: MeuInput(
                        labelText: 'Senha',
                        obscure: true,
                        controller: passwordController,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Botão para entrar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _autenServico.logarUsuarios(
                      email: emailController.text,
                      senha: passwordController.text,
                    );
                    // Redirecionar para a página inicial após login bem-sucedido
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                  } else {
                    print("Invalido");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 30, 163, 132),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 20),
              // Botão "Esqueci a senha"
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EsqueciSenha()));
                },
                child: const Text(
                  'Esqueci minha senha',
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
