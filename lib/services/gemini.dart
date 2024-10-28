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
    var prompt =
        """Considere o texto '${audio}' e interprete as datas que são faladas como 'hoje', 'ontem', ou como uma data específica. 
Retorne a resposta obrigatoria na seguinte estrutura sem exibir a palavra "json":
{
  "data": {
    "tipo": (receita ou despesa), 
    "categoria": ,
    "valor": ,
    "data": (hoje, ontem, ou a data no formato 'dd/MM/yyyy')
    }
  }""";

    var content = [Content.text(prompt)];
    var response = await model.generateContent(content);
    var teste = jsonDecode(response.text.toString());

    var valor = teste['data']['valor'];
    var tipo = teste['data']['tipo'];
    var categoria = teste['data']['categoria'];
    var dataTexto = teste['data']['data']; // data retornada como texto

    print(teste);
    print(tipo);
    print(categoria);
    print(valor);
    print(dataTexto);

    // Converte valor para double
    double valorDouble =
        double.tryParse(valor.toString().replaceAll(',', '.')) ?? 0.0;
    // Formata o valor como String com vírgula
    String valorFormatado = CurrencyTextInputFormatter()
        .formatToCurrency(valorDouble.toString().replaceAll('.', ','));

    DateTime now = DateTime.now();
    String mesAnoAtual = DateFormat('MM/yyyy').format(now);

    // Verifica data e converte para Timestamp
    Timestamp dataSelecionada;
    if (dataTexto.toLowerCase() == 'hoje') {
      dataSelecionada = Timestamp.fromDate(DateTime.now());
    } else if (dataTexto.toLowerCase() == 'ontem') {
      dataSelecionada =
          Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)));
    } else {
      String dataComMesAno =
          "${dataTexto.split('/')[0]}/$mesAnoAtual"; // '20/10/2024'
      DateTime dataConvertida = DateFormat('dd/MM/yyyy').parse(dataComMesAno);
      dataSelecionada = Timestamp.fromDate(dataConvertida);
    }

    // Navega para a tela apropriada com os valores e data processados
    if (tipo == 'despesa') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AdicionarDespesa(
            valorDespesa: valorDouble,
            valorFormatado: valorFormatado,
            data: dataSelecionada,
          ),
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
            data: dataSelecionada,
          ),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

generateResponseDB(String selectedDateLabel) async {
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
      'Data selecionada: $selectedDateLabel. Transforme em um Json: Receitas: ${receitasLista.toString()}, Total Receitas: ${totalReceitas}, Despesas: ${despesasLista.toString()}, Total Despesas: ${totalDespesas}, após transformar em json analise os dados e faça algumas orientações em relação à saúde financeira do usuário.';

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
}
