import 'package:flutter/material.dart';
import 'package:prospere_ai/views/cadastro.dart';
import 'package:prospere_ai/views/inicioLogin.dart';

class TelaBoasVindas extends StatefulWidget {
  const TelaBoasVindas({super.key});

  @override
  State<TelaBoasVindas> createState() => _TelaBoasVindasState();
}

Color primaryColor = const Color.fromARGB(255, 30, 163, 132);
Color accentColor = Colors.white;
Color textColor = Colors.black87;

class _TelaBoasVindasState extends State<TelaBoasVindas> {
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
              Text(
                'Prospere.AI',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Sua jornada financeira começa aqui',
                style: TextStyle(
                  fontSize: 18,
                  color: accentColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Logo centralizada
              Image.asset(
                'assets/images/novalogo_porco2.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 30),
              // Frase promocional sobre o app de finanças
              Text(
                'Gerencie suas finanças de maneira inteligente e alcance suas metas. Acompanhe seus gastos, crie metas e tenha controle total sobre o seu dinheiro.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: accentColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 50),
              // Botão "Cadastrar" com destaque
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Cadastro()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: primaryColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Label "Já sou cadastrado" sem fundo
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const InicioLogin()),
                  );
                },
                child: const Text(
                  'Já sou cadastrado',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
