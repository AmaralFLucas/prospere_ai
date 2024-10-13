import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasDespesas.dart';

class CategoriaReceita extends StatefulWidget {
  final String userId; // Receber o userId para buscar as categorias
  const CategoriaReceita({super.key, required this.userId});

  @override
  State<CategoriaReceita> createState() => _CategoriaReceitaState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class _CategoriaReceitaState extends State<CategoriaReceita> {
  late Future<List<Map<String, dynamic>>> categorias;

  @override
  void initState() {
    super.initState();
    categorias = getCategorias(widget.userId, 'receita'); // Carregar categorias ao iniciar
  }

  Future<List<Map<String, dynamic>>> getCategorias(String userId, String tipo) async {
    CollectionReference categorias = FirebaseFirestore.instance.collection('users').doc(userId).collection('categoriasReceitas');

    QuerySnapshot snapshot = await categorias.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Categorias de Receitas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: categorias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final categorias = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 221, 221),
                    borderRadius: BorderRadius.circular(55),
                  ),
                  height: 60,
                  width: 310,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {}, // Ação para adicionar nova categoria
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColor,
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                          child: const Text('Receitas', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const categoriaDespesas(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                          child: const Text('Despesas', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Exibe as categorias carregadas do banco de dados
                ...categorias.map((categoria) {
                  return _buildCategoryItem(IconData(categoria['icone'], fontFamily: 'MaterialIcons'), categoria['nome']);
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 60),
        const SizedBox(width: 50),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
