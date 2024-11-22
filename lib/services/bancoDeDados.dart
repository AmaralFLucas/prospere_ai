import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

Future<void> updateProfileImage(String userId, String imageUrl) async {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);
  await userRef.update({
    'profileImageUrl': imageUrl, // Atualiza a URL da imagem do perfil
  });
}

Future<void> addReceita(String userId, double valor, String categoria,
    Timestamp data, String descricao) async {
  CollectionReference receitas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('receitas');
  await receitas.add({
    'valor': valor,
    'categoria': categoria,
    'data': data,
    'descricao': descricao,
  });
}

Future<void> addDespesa(String userId, double valor, String categoria,
    Timestamp data, String descricao) async {
  CollectionReference despesas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('despesas');

  await despesas.add({
    'valor': valor,
    'categoria': categoria,
    'data': data,
    'descricao': descricao,
  });

  QuerySnapshot metasSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .where('tipoMeta', isEqualTo: 'gastoMensal')
      .where('categoria', isEqualTo: categoria)
      .get();

  if (metasSnapshot.docs.isNotEmpty) {
    for (var metaDoc in metasSnapshot.docs) {
      double valorAtual = metaDoc['valorAtual'];
      double novoValorAtual = valorAtual + valor;

      await metaDoc.reference.update({'valorAtual': novoValorAtual});
    }
  }
}

Future<void> addCategoriasPadrao(String userId) async {
  CollectionReference categoriasReceitas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('categoriasReceitas');
  CollectionReference categoriasDespesas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('categoriasDespesas');

  // Categorias padrão de receitas
  List<Map<String, dynamic>> categoriasReceitasPadrao = [
    {'nome': 'Salário', 'icone': Icons.monetization_on_outlined.codePoint},
    {'nome': 'Investimento', 'icone': Icons.bar_chart.codePoint},
    {'nome': 'Prêmio', 'icone': Icons.workspace_premium.codePoint},
    {'nome': 'Presentes', 'icone': Icons.card_giftcard.codePoint},
    {'nome': 'Outros', 'icone': Icons.more_horiz.codePoint},
  ];

  // Categorias padrão de despesas
  List<Map<String, dynamic>> categoriasDespesasPadrao = [
    {'nome': 'Alimentação', 'icone': Icons.fastfood.codePoint},
    {'nome': 'Transporte', 'icone': Icons.directions_car.codePoint},
    {'nome': 'Lazer', 'icone': Icons.local_activity.codePoint},
    {'nome': 'Educação', 'icone': Icons.school.codePoint},
    {'nome': 'Outros', 'icone': Icons.more_horiz.codePoint},
    {'nome': 'Supermercado', 'icone': Icons.shopping_cart.codePoint},
  ];

  // Adiciona as categorias de receitas
  for (var categoria in categoriasReceitasPadrao) {
    await categoriasReceitas.add(categoria);
  }

  // Adiciona as categorias de despesas
  for (var categoria in categoriasDespesasPadrao) {
    await categoriasDespesas.add(categoria);
  }
}

Future<void> addCategoria(
    String userId, String nomeCategoria, IconData icone, String tipo) async {
  CollectionReference categorias;

  if (tipo == 'receita') {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasReceitas');
  } else {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasDespesas');
  }

  await categorias.add({
    'nome': nomeCategoria,
    'icone': icone.codePoint, // Armazena o código do ícone
  });
}

Future<void> criarMeta(String userId, String tipoMeta, String descricao,
    double valorMeta, DateTime? dataLimite) async {
  CollectionReference metas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras');

  await metas.add({
    'tipoMeta': tipoMeta,
    'descricao': descricao,
    'valorMeta': valorMeta,
    'valorAtual': 0.0,
    'dataCriacao': DateTime.now(),
    'dataLimite': dataLimite ?? null,
  });
}

Future<void> criarMetaGastoMensal(String userId, String descricao,
    double valorMeta, String categoria, valorAtual, tipo) async {
  CollectionReference metas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras');

  // Buscar todas as despesas já registradas na categoria
  QuerySnapshot despesasSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('despesas')
      .where('categoria', isEqualTo: categoria)
      .get();

  // Calcular o valor total das despesas anteriores
  double totalDespesasAnteriores = 0.0;
  for (var doc in despesasSnapshot.docs) {
    var despesaData = doc.data() as Map<String, dynamic>;
    totalDespesasAnteriores += despesaData['valor'];
  }

  // Criar a meta já considerando as movimentações anteriores
  await metas.add({
    'descricao': descricao,
    'valorMeta': valorMeta,
    'valorAtual': totalDespesasAnteriores,
    'categoria': categoria,
    'tipoMeta': tipo,
  });
}

Future<void> atualizarMeta(
    String userId, String metaId, double valorAtualizado) async {
  DocumentReference meta = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .doc(metaId);

  await meta.update({'valorAtual': valorAtualizado});
}

Future<void> editarMeta(String userId, String metaId, String descricao,
    double valorMeta, DateTime? dataLimite) async {
  DocumentReference meta = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .doc(metaId);

  await meta.update({
    'descricao': descricao,
    'valorMeta': valorMeta,
    'dataLimite': dataLimite ?? null,
  });
}

Stream<QuerySnapshot> getMetas(String userId, String tipoMeta) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .where('tipoMeta', isEqualTo: tipoMeta)
      .snapshots();
}

Future<List<Map<String, dynamic>>> getCategorias(
    String userId, String tipo) async {
  CollectionReference categorias;

  if (tipo == 'receita') {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasReceitas');
  } else {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasDespesas');
  }

  QuerySnapshot snapshot = await categorias.get();

  // Debug: Verifique se as categorias foram recuperadas corretamente
  print("Número de categorias recuperadas: ${snapshot.docs.length}");

  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return {
      'id': doc.id, // Armazena o ID do documento
      'nome': data['nome'],
      'icone': data['icone'],
      // Converte codePoint para IconData
    };
  }).toList();
}

Future<List<Map<String, dynamic>>> getReceitas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('receitas')
      .get();

  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

Future<List<Map<String, dynamic>>> getDespesas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('despesas')
      .get();

  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

Future<void> updateMeta(String userId, String metaId, double valorAtual) async {
  DocumentReference meta = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .doc(metaId);

  await meta.update({'valorAtual': valorAtual});
}

Future<void> addFluxoDeCaixa(
    String userId,
    double receitaPrevista,
    double despesaPrevista,
    double receitaRealizada,
    double despesaRealizada) async {
  CollectionReference fluxoDeCaixa = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('fluxoDeCaixa');

  await fluxoDeCaixa.add({
    'receitaPrevista': receitaPrevista,
    'despesaPrevista': despesaPrevista,
    'receitaRealizada': receitaRealizada,
    'despesaRealizada': despesaRealizada,
  });
}

Future<void> editarCategoria(String userId, String categoriaId, String novoNome,
    IconData novoIcone, String tipo) async {
  CollectionReference categorias;

  if (tipo == 'receita') {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasReceitas');
  } else {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasDespesas');
  }

  await categorias.doc(categoriaId).update({
    'nome': novoNome,
    'icone': novoIcone.codePoint,
  });
}

Future<void> deletarCategoria(
    String userId, String categoriaId, String tipo) async {
  CollectionReference categorias;

  if (tipo == 'receita') {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasReceitas');
  } else {
    categorias = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categoriasDespesas');
  }

  await categorias.doc(categoriaId).delete();
}

Future<void> deletarMeta(String userId, String metaId) async {
  CollectionReference metas = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras');

  await metas.doc(metaId).delete();
}
