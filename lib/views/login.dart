import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importando o pacote de máscara
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/components/meu_snackbar.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/views/homePage.dart';
import 'package:prospere_ai/views/inicioCadastro.dart';

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

  // Máscara de email (não convencional, mas pode ser aplicada se necessário)
  final MaskTextInputFormatter emailMaskFormatter = MaskTextInputFormatter(
    mask: '############################', // Limite de caracteres para e-mail
    filter: {"#": RegExp(r'[a-zA-Z0-9@.]')},
  );

  bool validateEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  bool validateInputs() {
    if (emailController.text.isEmpty) {
      mostrarSnackBar(context: context, texto: "O E-mail é obrigatório.");
      return false;
    }
    if (!validateEmail(emailController.text)) {
      mostrarSnackBar(context: context, texto: "Informe um e-mail válido.");
      return false;
    }
    if (passwordController.text.isEmpty) {
      mostrarSnackBar(context: context, texto: "A senha é obrigatória.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 163, 132),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Image.asset(
                'assets/images/novalogo_porco2.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'Prospere.AI',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Faça login para acessar seu painel financeiro personalizado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: MeuInput(
                        labelText: 'Email',
                        controller: emailController,
                        inputFormatters: [
                          emailMaskFormatter
                        ], // Aplicando máscara de e-mail
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: MeuInput(
                        labelText: 'Senha',
                        controller: passwordController,
                        obscure: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (validateInputs()) {
                    try {
                      bool loginValido = await _autenServico.logarUsuarios(
                        email: emailController.text,
                        senha: passwordController.text,
                      );

                      if (loginValido) {
                        mostrarSnackBar(
                          context: context,
                          texto: "Login realizado com sucesso",
                          isErro: false,
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        mostrarSnackBar(
                          context: context,
                          texto: "Falha no login. Verifique suas credenciais.",
                        );
                      }
                    } catch (erro) {
                      mostrarSnackBar(
                        context: context,
                        texto: "Erro ao realizar login: $erro",
                      );
                    }
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
              TextButton(
                onPressed: () {
                  // Implementação para esqueci senha
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não tem uma conta? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const InicioCadastro()),
                      );
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
