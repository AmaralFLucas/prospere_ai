import 'package:flutter/material.dart';

class PoliticaDePrivacidade extends StatelessWidget {
  const PoliticaDePrivacidade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Aqui está a política de privacidade...',
                style: TextStyle(fontSize: 16),
              ),
              // Adicione mais texto conforme necessário
            ],
          ),
        ),
      ),
    );
  }
}
