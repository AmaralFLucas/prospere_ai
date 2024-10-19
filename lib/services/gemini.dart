import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:prospere_ai/components/textFormatter.dart';
import 'package:prospere_ai/views/adicionarDespesa.dart';
import 'package:prospere_ai/views/adicionarReceita.dart';

const apiKey = 'AIzaSyBW_T2tYv3iuhAWylGervuMqjfMPQ1NiQ4';

generateResponse(BuildContext context, audio) async {
  var model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );
  try {
    var prompt = """Considere o texto ${audio}, 
  Retorne a resposta obrigatoria na seguinte estrutura sem exibir a palavra "json"
  {
  "data": {
    "tipo": (receita ou despesa), 
    "categoria": ,
    "valor": 
    }
  }""";

    var content = [Content.text(prompt)];
    var response = await model.generateContent(content);
    var teste = jsonDecode(response.text.toString());
    var valor = teste['data']['valor'];
    var tipo = teste['data']['tipo'];
    var categoria = teste['data']['categoria'];

    print(teste);
    print(tipo);
    print(categoria);
    print(valor);
    double valorDouble =
        double.tryParse(valor.toString().replaceAll(',', '.')) ??
            0.0; // Converte para double

    // Formata o valor como String com vírgula como separador decimal
    String valorFormatado = CurrencyTextInputFormatter()
        .formatToCurrency(valorDouble.toString().replaceAll('.', ','));
    print(valorFormatado); // Formata o valor
    if (tipo == 'despesa') {
      // Passa o valor formatado para a tela
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AdicionarDespesa(
              valorDespesa: valorDouble,
              valorFormatado:
                  valorFormatado), // Passa o valor como double e formatado
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AdicionarReceita(
            valorReceita: valorDouble,
            valorFormatado: valorFormatado,
            categoriaAudio: categoria,
          ),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

generateResponseDB() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var userId = uid;
  CollectionReference receitas =
      firestore.collection('users').doc(userId).collection('receitas');
  CollectionReference despesas =
      firestore.collection('users').doc(userId).collection('despesas');

  var querySnapshot = await receitas.get();
  var querySnapshot2 = await despesas.get();
  List<Map<String, dynamic>> receitasLista = [];
  List<Map<String, dynamic>> despesasLista = [];

  double totalReceitas = 0.0;
  double totalDespesas = 0.0;

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> receitaData = doc.data() as Map<String, dynamic>;

    if (receitaData.containsKey('data') && receitaData['data'] is Timestamp) {
      Timestamp timestamp = receitaData['data'];
      DateTime dateTime = timestamp.toDate();
      String formattedDate = dateFormat.format(dateTime);
      receitaData['data'] = formattedDate;
    }

    if (receitaData.containsKey('valor')) {
      totalReceitas += receitaData['valor'];
    }

    receitasLista.add(receitaData);
  });

  querySnapshot2.docs.forEach((doc) {
    Map<String, dynamic> despesaData = doc.data() as Map<String, dynamic>;

    if (despesaData.containsKey('data') && despesaData['data'] is Timestamp) {
      Timestamp timestamp = despesaData['data'];
      DateTime dateTime = timestamp.toDate();
      String formattedDate = dateFormat.format(dateTime);
      despesaData['data'] = formattedDate;
    }

    if (despesaData.containsKey('valor')) {
      totalDespesas += despesaData['valor'];
    }

    despesasLista.add(despesaData);
  });

  final prompt =
      'Transforme em um Json: Receitas: ${receitasLista.toString()}, Total Receitas: ${totalReceitas}, Despesas: ${despesasLista.toString()}, Total Despesas: ${totalDespesas}, após transformar em json analise os dados e faça algumas orientações em relação a saúde financeira do usuário.';

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
}
