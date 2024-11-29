import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:prospere_ai/components/textFormatter.dart';
import 'package:prospere_ai/views/adicionarDespesa.dart';
import 'package:prospere_ai/views/adicionarReceita.dart';

const apiKey = 'AIzaSyB8HK_uUf5m2FJWyY_otyk7_SAZAGRjjWY';

generateResponse(BuildContext context, audio) async {
  var model = GenerativeModel(
    model: 'gemini-1.5-flash-8b',
    apiKey: apiKey,
  );
  try {
    var prompt =
        """Considere o texto '${audio}' e interprete as datas que são faladas como 'hoje', 'ontem', ou como uma data específica. 
Retorne uma análise concisa em formato JSON puro e sem formatação adicional. 
Não use formatação de código, como \`json\` ou backticks. Somente o JSON puro.

Estrutura esperada:
{
  "data": {
    "tipo": "(receita ou despesa)",
    "categoria": "",
    "valor": "",
    "data": "(hoje, ontem, ou a data no formato 'dd/MM/yyyy')",
    "descricao": ""
  }
}""";

    var content = [Content.text(prompt)];
    var response = await model.generateContent(content);
    var teste = jsonDecode(response.text.toString());

    var valor = teste['data']['valor'];
    var tipo = teste['data']['tipo'];
    var categoria = teste['data']['categoria'];
    var dataTexto = teste['data']['data'];
    var descricao = teste['data']['descricao'];

    print(teste);
    print(tipo);
    print(categoria);
    print(valor);
    print(dataTexto);

    // double valorDouble =
    //     double.tryParse(valor.toString().replaceAll(',', '.')) ?? 0.0;

    // Remove caracteres que não sejam números ou ponto decimal, preservando apenas o primeiro ponto.
    String valorSanitizado = valor
        .toString()
        .replaceAll(RegExp(r'[^\d.,]'), '')
        .replaceAll(',', '.');

// Garante que só haverá um ponto decimal no valor.
    if (valorSanitizado.contains('.')) {
      valorSanitizado = valorSanitizado.split('.').first +
          '.' +
          valorSanitizado.split('.').skip(1).join('');
    }

// Converte para double, garantindo que a formatação seja consistente.
    double valorDouble = double.tryParse(valorSanitizado) ?? 0.0;

// Formata o valor como string no padrão monetário.
    String valorFormatado = CurrencyTextInputFormatter()
        .formatToCurrency(valorDouble.toStringAsFixed(2).replaceAll('.', ','));

    print(valorFormatado);

    DateTime now = DateTime.now();
    String mesAtual = DateFormat('MM').format(now);
    String anoAtual = DateFormat('yyyy').format(now);

    Timestamp dataSelecionada;
    if (dataTexto.toLowerCase() == 'hoje') {
      dataSelecionada = Timestamp.fromDate(DateTime.now());
    } else if (dataTexto.toLowerCase() == 'ontem') {
      dataSelecionada =
          Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)));
    } else {
      List<String> partesData = dataTexto.split('/');
      String dataComMesAno;

      if (partesData.length == 3) {
        String dia = partesData[0].padLeft(2, '0');
        String mes = partesData[1];
        String ano = partesData[2];

        if (mes == 'MM') {
          mes = mesAtual;
        } else {
          mes = mes.padLeft(2, '0');
        }

        if (ano == 'yyyy') {
          ano = anoAtual;
        }
        dataComMesAno = "$dia/$mes/$ano";
      } else {
        dataComMesAno = dataTexto.replaceAll('yyyy', anoAtual);
      }

      try {
        DateTime dataConvertida = DateFormat('dd/MM/yyyy').parse(dataComMesAno);
        dataSelecionada = Timestamp.fromDate(dataConvertida);
      } catch (e) {
        print("Erro ao converter a data: ${e.toString()}");
        dataSelecionada = Timestamp.fromDate(DateTime.now());
      }
    }

    if (tipo == 'despesa') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AdicionarDespesa(
            // valorDespesa: valorDouble,
            categoriaAudio: categoria,
            valorFormatado: valorFormatado,
            data: dataSelecionada,
            descricao: descricao,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AdicionarReceita(
            // valorReceita: valorDouble,
            valorFormatado: valorFormatado,
            categoriaAudio: categoria,
            data: dataSelecionada,
            descricao: descricao,
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
  CollectionReference metas =
      firestore.collection('users').doc(userId).collection('metasFinanceiras');

  var querySnapshot = await receitas.get();
  var querySnapshot2 = await despesas.get();
  var querySnapshot3 = await metas.get();
  List<Map<String, dynamic>> receitasLista = [];
  List<Map<String, dynamic>> despesasLista = [];
  List<Map<String, dynamic>> metasLista = [];

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

  querySnapshot3.docs.forEach((doc) {
    Map<String, dynamic> metaData = doc.data() as Map<String, dynamic>;

    if (metaData.containsKey('data') && metaData['data'] is Timestamp) {
      Timestamp timestamp = metaData['data'];
      DateTime dateTime = timestamp.toDate();
      String formattedDate = dateFormat.format(dateTime);
      metaData['data'] = formattedDate;
    }

    metasLista.add(metaData);
  });

  final prompt =
      '''Você está fazendo parte de um aplicativo de controle financeiro que se chama Prospere.AI você precisa fazer o que se pede abaixo para o usuário:\n
      Analise os seguites dados ${receitasLista.toString()}, Total Receitas: ${totalReceitas}, Despesas: ${despesasLista.toString()}, Total Despesas: ${totalDespesas}, Metas: ${metasLista.toString()}, 
      com base nesses dados eu preciso que você gere uma análise preditiva, analise os hábitos de consumo do usuário e gere previsões de despesas, receitas do usuário para o próximo mês e não esqueça de considerar as metas do usuário.''';

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
  print(metasLista);
  return response.text;
}
