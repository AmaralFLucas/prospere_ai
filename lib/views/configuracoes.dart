import 'package:flutter/material.dart';

Color myColor = Color.fromARGB(255, 30, 163, 132);

class Configuracoes extends StatelessWidget {
  const Configuracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop();
          },
        ),
        title: Text('Configurações'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline), 
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: myColor),
            title: Text('Preferências'),
            subtitle:
                Text('Moeda, idioma, opções de visualização, começar do zero'),
            onTap: () {
              
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: myColor),
            title: Text('Alertas e Notificações'),
            subtitle: Text('Pendências e alertas'),
            onTap: () {
              
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: myColor),
            title: Text('Segurança'),
            subtitle: Text('Bloqueio por digital, senha'),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}
