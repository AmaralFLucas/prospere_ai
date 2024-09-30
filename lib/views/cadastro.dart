import 'package:flutter/material.dart';
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/components/meu_snackbar.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/views/homePage.dart';
import 'package:prospere_ai/views/inicioLogin.dart';
import 'package:prospere_ai/views/login.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

Color primaryColor = const Color.fromARGB(255, 30, 163, 132);
Color accentColor = Colors.white;

class _CadastroState extends State<Cadastro> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  final AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Fundo do aplicativo
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo do app
              Image.asset(
                'assets/images/logo_porco.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),

              // Nome do App em destaque
              Text(
                'Prospere.AI',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              // Slogan ou frase promocional
              Text(
                'Crie sua conta para começar a gerenciar suas finanças',
                style: TextStyle(
                  fontSize: 18,
                  color: accentColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Campos de entrada
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Digite o seu nome',
                  controller: nomeController,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Digite o seu E-mail',
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Digite o seu CPF',
                  controller: cpfController,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Digite a sua Senha',
                  obscure: true,
                  controller: passwordController,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Confirme a sua Senha',
                  obscure: true,
                ),
              ),
              const SizedBox(height: 32),

              // Botão "Cadastrar"
              ElevatedButton(
                onPressed: () async {
                  await _autenServico
                      .cadastrarUsuario(
                    email: emailController.text,
                    senha: passwordController.text,
                    cpf: cpfController.text,
                    nome: nomeController.text,
                  )
                      .then((String? erro) {
                    if (erro != null) {
                      mostrarSnackBar(context: context, texto: erro);
                    } else {
                      mostrarSnackBar(
                        context: context,
                        texto: "Cadastro efetuado com sucesso",
                        isErro: false,
                      );
                      _autenServico.deslogarUsuario();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor, // Fundo branco
                  foregroundColor: primaryColor, // Texto verde
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Cadastrar'),
              ),
              const SizedBox(height: 20),

              // Link "Já tenho cadastro!"
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const InicioLogin()),
                  );
                },
                child: Text(
                  'Já tenho cadastro!',
                  style: TextStyle(
                    color: accentColor, // Cor do texto
                    fontSize: 16,
                    decoration: TextDecoration.underline, // Sublinhado
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
