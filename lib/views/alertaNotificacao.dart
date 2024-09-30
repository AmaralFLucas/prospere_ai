import 'package:flutter/material.dart';

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class Alertanotificacao extends StatelessWidget {
  const Alertanotificacao({super.key});

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
        title: const Text('Alertas e notificações'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Configuração de e-mail'),
            subtitle: Text('Gerencie e-mail'),
          ),
          ListTile(
            title: Text('Leitura notificação'),
            subtitle: Text('Claro'),
          ),
          ListTile(
            title: Text('Alerta pendencias'),
            subtitle: Text('Escolha a moeda'),
          ),
        ],
      ),
    );
  }
}
