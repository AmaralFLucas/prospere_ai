import 'package:flutter/material.dart';

class MeuInput extends StatelessWidget {
  final String labelText;
  final bool obscure;
  final TextEditingController? controller;
  final Icon? prefixIcon;

  const MeuInput({
    Key? key,
    required this.labelText,
    this.obscure = false,
    this.controller,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: const Color.fromARGB(166, 0, 0, 0),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Bordas arredondadas
            borderSide: BorderSide.none, // Remove a borda padrão
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color:
                  Color.fromARGB(190, 255, 255, 255), // Cor da borda ao focar
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;

  const Email({Key? key, required this.labelText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MeuInput(
      labelText: labelText,
      controller: controller,
      prefixIcon: const Icon(Icons.email,
          color: Color.fromARGB(255, 30, 163, 132)), // Ícone de e-mail
    );
  }
}

class Senha extends StatelessWidget {
  final String labelText;
  final bool? obscure;
  final TextEditingController? controller;

  const Senha(
      {Key? key, required this.labelText, this.controller, this.obscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MeuInput(
      labelText: labelText,
      controller: controller,
      obscure: obscure ?? true,
      prefixIcon: const Icon(Icons.lock,
          color: Color.fromARGB(255, 30, 163, 132)), // Ícone de senha
    );
  }
}
