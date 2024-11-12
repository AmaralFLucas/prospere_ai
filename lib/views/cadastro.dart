import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importando o pacote de máscara
import 'package:prospere_ai/components/meu_input.dart';
import 'package:prospere_ai/components/meu_snackbar.dart';
import 'package:prospere_ai/services/autenticacao.dart';
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
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  final AutenticacaoServico _autenServico = AutenticacaoServico();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final MaskTextInputFormatter cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
    });
  }

  bool validateEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  bool validateCPF(String cpf) {
    // Remove caracteres não numéricos
    String numericCpf = cpf.replaceAll(RegExp(r'\D'), '');

    // Verifica se tem 11 dígitos
    return numericCpf.length == 11 && RegExp(r'^\d{11}$').hasMatch(numericCpf);
  }

  bool validateInputs() {
    if (nomeController.text.isEmpty) {
      mostrarSnackBar(context: context, texto: "O nome é obrigatório.");
      return false;
    }
    if (emailController.text.isEmpty) {
      mostrarSnackBar(context: context, texto: "O E-mail é obrigatório.");
      return false;
    }
    if (!validateEmail(emailController.text)) {
      mostrarSnackBar(context: context, texto: "Informe um e-mail válido.");
      return false;
    }
    if (cpfController.text.isEmpty) {
      mostrarSnackBar(context: context, texto: "O CPF é obrigatório.");
      return false;
    }
    if (!validateCPF(cpfController.text)) {
      mostrarSnackBar(
          context: context,
          texto:
              "O CPF deve estar no formato xxx.xxx.xxx-xx e conter 11 dígitos.");
      return false;
    }
    if (passwordController.text.isEmpty) {
      mostrarSnackBar(context: context, texto: "A senha é obrigatória.");
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      mostrarSnackBar(
          context: context, texto: "A confirmação da senha é obrigatória.");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      mostrarSnackBar(context: context, texto: "As senhas não correspondem.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/novalogo_porco2.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
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
              Text(
                'Crie sua conta para começar a gerenciar suas finanças',
                style: TextStyle(
                  fontSize: 18,
                  color: accentColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfMaskFormatter], // Aplica a máscara
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Digite a sua Senha',
                  obscure: obscurePassword,
                  controller: passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: accentColor,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: MeuInput(
                  labelText: 'Confirme a sua Senha',
                  obscure: obscureConfirmPassword,
                  controller: confirmPasswordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: accentColor,
                    ),
                    onPressed: toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (validateInputs()) {
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
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Cadastrar'),
              ),
              const SizedBox(height: 20),
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
                    color: accentColor,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
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
