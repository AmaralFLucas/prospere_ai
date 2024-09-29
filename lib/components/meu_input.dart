import 'package:flutter/material.dart';

class MeuInput extends StatelessWidget {
  String labelText;
  bool? obscure;
  TextEditingController? controller;

  MeuInput({super.key, required this.labelText, this.obscure, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  String labelText;
  TextEditingController? controller;

  Email({super.key, required this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "O e-mail não pode ser vazio";
          } else if (value.length < 5) {
            return "O e-mail é muito curto";
          } else if (!value.contains("@")) {
            return "O e-mail não é valido";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Senha extends StatelessWidget {
  String labelText;
  bool? obscure;
  TextEditingController? controller;

  Senha({super.key, required this.labelText, this.controller, this.obscure});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "A senha não pode ser vazia";
          } else if (value.length < 6) {
            return "A senha é muito curta";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
