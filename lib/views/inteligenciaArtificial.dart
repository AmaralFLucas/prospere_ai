import 'package:flutter/material.dart';

class InteligenciaArtificial extends StatelessWidget {
  const InteligenciaArtificial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 163, 132),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
        title: const Text(
          'ProspereIA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Aqui você vai ver alguns insights para melhorar sua vida financeira",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Assim que você registrar seus lançamentos, a Inteligência Artificial analisará seus dados e apresentará feedbacks personalizados",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'powered by',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                    height: 0), // Ajuste a altura conforme necessário
                Image.asset(
                  'assets/images/gemini.png',
                  width: 80,
                  height: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
