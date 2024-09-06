import 'package:flutter/material.dart';

Color myColor = Color.fromARGB(255, 30, 163, 132);

class Alertanotificacao extends StatelessWidget {
  const Alertanotificacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Alertas e notificações'),
      ),
      body: ListView(
        children: [
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
