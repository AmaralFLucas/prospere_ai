import 'package:flutter/material.dart';

Color myColor = Color.fromARGB(255, 30, 163, 132);

class Seguranca extends StatelessWidget {
  const Seguranca({super.key});

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
        title: Text('Segurança'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Senha'),
            subtitle: Text('Configure sua senha para entrar no aplicativo'),
          ),
          ListTile(
            title: Text('BLoqueio por impressão digital'),
            subtitle: Text('Desbloqueio o aplicativo usando suas digitais'),
          ),
          ListTile(
            title: Text('Dispositivos conectados'),
            subtitle: Text('Gerencie os seus dispositivos'),
          ),
        ],
      ),
    );
  }
}
