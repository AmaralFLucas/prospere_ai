import 'package:flutter/material.dart';

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class Preferencias extends StatelessWidget {
  const Preferencias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Preferências'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Idioma'),
            subtitle: Text('Escolha o idioma'),
          ),
          ListTile(
            title: Text('Tema'),
            subtitle: Text('Claro'),
          ),
          ListTile(
            title: Text('Moeda'),
            subtitle: Text('Escolha a moeda'),
          ),
        ],
      ),
    );
  }
}
