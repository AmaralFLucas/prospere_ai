import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

const apiKey = 'AIzaSyBW_T2tYv3iuhAWylGervuMqjfMPQ1NiQ4';

generateResponse(audio) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final prompt =
      'Com base nas informações a seguir gere um json organizando os elementos destacados: ${audio}';
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
}

generateResponseDB() async {
  // Referência à coleção de dados no Firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Supondo que você está buscando dados da coleção 'users' e 'metasFinanceiras'
  var userId = uid;
  CollectionReference receitas =
      firestore.collection('users').doc(userId).collection('receitas');
  CollectionReference despesas =
      firestore.collection('users').doc(userId).collection('despesas');

  // Recuperar os dados
  var querySnapshot = await receitas.get();
  var querySnapshot2 = await despesas.get();
  List<Map<String, dynamic>> receitasLista = [];
  List<Map<String, dynamic>> despesasLista = [];

  // Variáveis para armazenar o total de receitas e despesas
  double totalReceitas = 0.0;
  double totalDespesas = 0.0;

  // Formatar as datas
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> receitaData = doc.data() as Map<String, dynamic>;

    // Verifica se há um campo de data no documento e se ele é um Timestamp
    if (receitaData.containsKey('data') && receitaData['data'] is Timestamp) {
      Timestamp timestamp = receitaData['data'];
      DateTime dateTime = timestamp.toDate();
      // Formatar a data
      String formattedDate = dateFormat.format(dateTime);
      // Substituir o campo de data formatado
      receitaData['data'] = formattedDate;
    }

    // Adiciona o valor ao total de receitas
    if (receitaData.containsKey('valor')) {
      totalReceitas += receitaData['valor'];
    }

    receitasLista.add(receitaData);
  });

  querySnapshot2.docs.forEach((doc) {
    Map<String, dynamic> despesaData = doc.data() as Map<String, dynamic>;

    // Verifica se há um campo de data no documento e se ele é um Timestamp
    if (despesaData.containsKey('data') && despesaData['data'] is Timestamp) {
      Timestamp timestamp = despesaData['data'];
      DateTime dateTime = timestamp.toDate();
      // Formatar a data
      String formattedDate = dateFormat.format(dateTime);
      // Substituir o campo de data formatado
      despesaData['data'] = formattedDate;
    }

    // Adiciona o valor ao total de despesas
    if (despesaData.containsKey('valor')) {
      totalDespesas += despesaData['valor'];
    }

    despesasLista.add(despesaData);
  });

  // Construa o prompt para a IA usando os dados obtidos do Firebase
  final prompt =
      'Transforme em um Json: Receitas: ${receitasLista.toString()}, Total Receitas: ${totalReceitas}, Despesas: ${despesasLista.toString()}, Total Despesas: ${totalDespesas}, após transformar em json analise os dados e faça algumas orientações em relação a saúde financeira do usuário.';

  // Modelo da IA Gemini
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  // Printar a resposta da IA
  print(response.text);
}

