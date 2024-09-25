import 'package:cloud_firestore/cloud_firestore.dart';

// class conexaoBanco {
//   criarDespesa(uid) async {
//     FirebaseFirestore db = await FirebaseFirestore.instance;
//     try {
//       await db.collection('receitas').doc(uid).set({
//       'Nome': 'teste'
//     });
//     } catch (e) {
//       print(e);
//     }
//   }
// }

Future<void> addReceita(String userId, double valor, String categoria, Timestamp data, String tipo) async {
  CollectionReference receitas = FirebaseFirestore.instance.collection('users').doc(userId).collection('receitas');
  
  await receitas.add({
    'valor': valor,
    'categoria': categoria,
    'data': data,
    'tipo': tipo,
  });
}

Future<void> addDespesa(String userId, double valor, String categoria, Timestamp data, String tipo) async {
  CollectionReference despesas = FirebaseFirestore.instance.collection('users').doc(userId).collection('despesas');
  
  await despesas.add({
    'valor': valor,
    'categoria': categoria,
    'data': data,
    'tipo': tipo,
  });
}

Future<List<Map<String, dynamic>>> getReceitas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('receitas')
      .get();
  
  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

Future<List<Map<String, dynamic>>> getDespesas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('despesas')
      .get();
  
  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

Future<void> updateMeta(String userId, String metaId, double valorAtual) async {
  DocumentReference meta = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .doc(metaId);
  
  await meta.update({'valorAtual': valorAtual});
}

Future<void> addFluxoDeCaixa(String userId, double receitaPrevista, double despesaPrevista, double receitaRealizada, double despesaRealizada) async {
  CollectionReference fluxoDeCaixa = FirebaseFirestore.instance.collection('users').doc(userId).collection('fluxoDeCaixa');
  
  await fluxoDeCaixa.add({
    'receitaPrevista': receitaPrevista,
    'despesaPrevista': despesaPrevista,
    'receitaRealizada': receitaRealizada,
    'despesaRealizada': despesaRealizada,
  });
}
