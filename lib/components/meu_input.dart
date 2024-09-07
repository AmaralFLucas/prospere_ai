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
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        // validator: (value) {
        //   if (value!.length > 6) {
        //     return 'Limite de caracteres ultrapassado';
        //   }
        // },
        controller: controller,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          // errorText: "Email está incorreto."
        ),
      ),
    );
  }
}
