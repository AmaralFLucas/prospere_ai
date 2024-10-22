import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para usar TextInputFormatter

class MeuInput extends StatelessWidget {
  final String labelText;
  final bool obscure;
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType; // Adicionado para tipo de teclado
  final List<TextInputFormatter>?
      inputFormatters; // Adicionado para formatadores de entrada

  const MeuInput({
    Key? key,
    required this.labelText,
    this.obscure = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType, // Adiciona tipo de teclado
        inputFormatters: inputFormatters, // Adiciona formatadores de entrada
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color.fromARGB(166, 0, 0, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(190, 255, 255, 255),
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
      prefixIcon: const Icon(
        Icons.email,
        color: Color.fromARGB(255, 30, 163, 132),
      ),
      keyboardType:
          TextInputType.emailAddress, // Define o tipo de teclado para e-mail
    );
  }
}

class Senha extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;

  const Senha({Key? key, required this.labelText, this.controller})
      : super(key: key);

  @override
  _SenhaState createState() => _SenhaState();
}

class _SenhaState extends State<Senha> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MeuInput(
      labelText: widget.labelText,
      controller: widget.controller,
      obscure: _obscureText,
      prefixIcon: const Icon(
        Icons.lock,
        color: Color.fromARGB(255, 30, 163, 132),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.white,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}
