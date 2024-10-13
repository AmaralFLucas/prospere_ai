import 'package:flutter/material.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';

class Categoria extends StatefulWidget {
  final String userId;
  const Categoria({super.key, required this.userId});

  @override
  State<Categoria> createState() => _CategoriaState();
}

Color receitaColor = const Color.fromARGB(255, 30, 163, 132);
Color despesaColor = const Color.fromARGB(255, 178, 0, 0);

class _CategoriaState extends State<Categoria> {
  String categoriaAtual = 'receita';
  late Future<List<Map<String, dynamic>>> categorias;
  IconData? selectedIcon;

  @override
  void initState() {
    super.initState();
    categorias = getCategorias(widget.userId, categoriaAtual);
  }

  void mudarCategoria(String novaCategoria) {
    setState(() {
      categoriaAtual = novaCategoria;
      categorias = getCategorias(widget.userId, categoriaAtual);
    });
  }

  Future<void> _showAddCategoriaDialog() async {
    String? nomeCategoria;
    IconData? iconeCategoria;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Categoria'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<IconData>(
                decoration: const InputDecoration(labelText: 'Selecionar Ícone'),
                items: [
                  Icons.home,
                  Icons.shopping_cart,
                  Icons.computer,
                  Icons.menu_book_sharp,
                  Icons.more_horiz,
                ].map((IconData icon) {
                  return DropdownMenuItem<IconData>(
                    value: icon,
                    child: Row(
                      children: [
                        Icon(icon),
                        const SizedBox(width: 10),
                        Text(icon.toString()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (IconData? newIcon) {
                  iconeCategoria = newIcon;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Nome da Categoria'),
                onChanged: (String value) {
                  nomeCategoria = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                if (iconeCategoria != null && nomeCategoria != null) {
                  await addCategoria(widget.userId, nomeCategoria!, iconeCategoria!, categoriaAtual);

                  setState(() {
                    categorias = getCategorias(widget.userId, categoriaAtual);
                  });
                }
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: categoriaAtual == 'receita' ? receitaColor : despesaColor,
        title: Text(
          'Categorias de ${categoriaAtual == 'receita' ? 'Receitas' : 'Despesas'}',
          style: const TextStyle(
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
                          onPressed: () {
                            mudarCategoria('receita');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoriaAtual == 'receita'
                                ? receitaColor
                                : const Color.fromARGB(255, 197, 197, 197),
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                          child: Text('Receitas',
                              style: TextStyle(
                                  color: categoriaAtual == 'receita'
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            mudarCategoria('despesa');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoriaAtual == 'despesa'
                                ? despesaColor
                                : const Color.fromARGB(255, 197, 197, 197),
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                          child: Text('Despesas',
                              style: TextStyle(
                                  color: categoriaAtual == 'despesa'
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ...categorias.map((categoria) {
                  return _buildCategoryItem(IconData(categoria['icone'], fontFamily: 'MaterialIcons'), categoria['nome']);
                }).toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoriaDialog,
        child: const Icon(Icons.add),
        backgroundColor: categoriaAtual == 'receita' ? receitaColor : despesaColor,
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
