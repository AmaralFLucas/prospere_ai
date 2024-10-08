import 'package:flutter/material.dart';
import 'package:prospere_ai/views/preferencias.dart';
import 'package:prospere_ai/views/alertaNotificacao.dart';
import 'package:prospere_ai/views/seguranca.dart';

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class Configuracoes extends StatelessWidget {
  const Configuracoes({super.key});

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
        title: const Text('Configurações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: myColor),
            title: const Text('Preferências'),
            subtitle:
                const Text('Moeda, idioma, opções de visualização, começar do zero'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Preferencias()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: myColor),
            title: const Text('Alertas e Notificações'),
            subtitle: const Text('Pendências e alertas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Alertanotificacao()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: myColor),
            title: const Text('Segurança'),
            subtitle: const Text('Bloqueio por digital, senha'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Seguranca()),
              );
            },
          ),
        ],
      ),
    );
  }
}
