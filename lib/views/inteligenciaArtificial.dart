import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prospere_ai/services/gemini.dart';

class InteligenciaArtificial extends StatefulWidget {
  const InteligenciaArtificial({Key? key}) : super(key: key);

  @override
  _InteligenciaArtificialState createState() => _InteligenciaArtificialState();
}

class _InteligenciaArtificialState extends State<InteligenciaArtificial> {
  String? aiAnalysis; // Variável para armazenar a resposta da IA
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataAndAnalyze(); // Chama a função para buscar e analisar dados ao entrar na tela
  }

  Future<void> fetchDataAndAnalyze() async {
    String selectedDateLabel = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String? analysis = await generateResponseDB(selectedDateLabel);
    setState(() {
      aiAnalysis = analysis; // Atualiza a análise recebida da IA
      isLoading = false; // Finaliza o carregamento
    });
  }

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
          'ProspereAI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Mostra carregamento
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Aqui você vai ver alguns insights para melhorar sua vida financeira",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  aiAnalysis != null
                      ? Text(
                          aiAnalysis!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        )
                      : const Text(
                          "Sem dados para análise.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                  const SizedBox(height: 20),
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
                      const SizedBox(height: 0),
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
