import 'package:flutter/material.dart';

class TermosDeUso extends StatelessWidget {
  const TermosDeUso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Aqui estão os termos de uso...',
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
