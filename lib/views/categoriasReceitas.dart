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
  List<Map<String, dynamic>> categorias = [];
  IconData? selectedIcon;
  List<Map<String, dynamic>> categoriasReceitas = [];
  List<Map<String, dynamic>> categoriasDespesas = [];

  @override
  @override
  void initState() {
    super.initState();
    loadCategorias();
  }

  void mudarCategoria(String novaCategoria) {
    setState(() {
      categoriaAtual = novaCategoria;
      loadCategorias();
    });
  }

  Future<void> _showAddCategoriaDialog() async {
    String? nomeCategoria;
    IconData? iconeCategoria;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Categoria'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nome da Categoria',
                    ),
                    onChanged: (String value) {
                      nomeCategoria = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Selecione um Ícone",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...[
                        Icons.home,
                        Icons.shopping_cart,
                        Icons.computer,
                        Icons.menu_book_sharp,
                        Icons.auto_awesome,
                        Icons.card_giftcard,
                        Icons.monetization_on_outlined,
                        Icons.bar_chart,
                        Icons.workspace_premium,
                        Icons.fastfood,
                        Icons.directions_car,
                        Icons.local_activity,
                        Icons.school,
                        Icons.more_horiz,
                      ].map((icon) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              iconeCategoria = icon;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: iconeCategoria == icon
                                    ? const Color.fromARGB(255, 30, 163, 132)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                icon,
                                size: 30,
                                color: iconeCategoria == icon
                                    ? const Color.fromARGB(255, 30, 163, 132)
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
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
                      await addCategoria(widget.userId, nomeCategoria!,
                          iconeCategoria!, categoriaAtual);
                      await loadCategorias(); // Recarregar ambas as listas
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha todos os campos!'),
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> loadCategorias() async {
    categoriasReceitas = await getCategorias(widget.userId, 'receita');
    categoriasDespesas = await getCategorias(widget.userId, 'despesa');
    setState(() {}); // Atualiza a interface após carregar as categorias
  }

  @override
  Widget build(BuildContext context) {
    final categoriasExibidas =
        categoriaAtual == 'receita' ? categoriasReceitas : categoriasDespesas;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            categoriaAtual == 'receita' ? receitaColor : despesaColor,
        title: Text(
          'Categorias de ${categoriaAtual == 'receita' ? 'Receitas' : 'Despesas'}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: categoriasExibidas.isEmpty
          ? Center(child: Text('Nenhuma categoria disponível.'))
          : ListView(
              padding:
                  const EdgeInsets.only(bottom: 80),
              children: [
                const SizedBox(height: 20),
                Container(
                  // height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => mudarCategoria('receita'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoriaAtual == 'receita'
                                ? receitaColor
                                : Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13)
                          ),
                          child: Text(
                            'Receitas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: categoriaAtual == 'receita'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: categoriaAtual == 'receita'
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => mudarCategoria('despesa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoriaAtual == 'despesa'
                                ? despesaColor
                                : Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13)
                          ),
                          child: Text(
                            'Despesas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: categoriaAtual == 'despesa'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: categoriaAtual == 'despesa'
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                ...categoriasExibidas.map((categoria) {
                  final String categoriaId = categoria['id'] ?? '';
                  final String categoriaNome = categoria['nome'] ?? '';

                  if (categoriaId.isEmpty || categoriaNome.isEmpty) {
                    return SizedBox.shrink();
                  }

                  return _buildCategoryItem(
                    IconData(categoria['icone'] ?? Icons.help_outline.codePoint,
                        fontFamily: 'MaterialIcons'),
                    categoriaNome,
                    categoriaId,
                  );
                }).toList(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoriaDialog,
        child: const Icon(Icons.add),
        backgroundColor:
            categoriaAtual == 'receita' ? receitaColor : despesaColor,
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String categoriaId) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon,
              color: categoriaAtual == 'receita' ? receitaColor : despesaColor,
              size: 30),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              _showEditCategoriaDialog(categoriaId, title, icon.codePoint);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              // Adicionando um dialog de confirmação antes de deletar
              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmação'),
                    content:
                        const Text('Deseja realmente excluir esta categoria?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Excluir'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete) {
                // Chama a função de deletar categoria passando os parâmetros corretos
                await deletarCategoria(
                    widget.userId, // userId
                    categoriaId, // categoriaId
                    categoriaAtual // tipo (receita ou despesa)
                    );
                setState(() {
                  loadCategorias();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditCategoriaDialog(String categoriaId,
      String nomeCategoriaInicial, int iconCodeInicial) async {
    // Inicializar as variáveis com os valores recebidos
    String? nomeCategoria = nomeCategoriaInicial;
    IconData? iconeCategoria =
        IconData(iconCodeInicial, fontFamily: 'MaterialIcons');
    // Atualize a lista após as alterações

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Categoria'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo de texto para o nome da categoria
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nome da Categoria',
                    ),
                    controller: TextEditingController(text: nomeCategoria)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: nomeCategoria!.length),
                      ),
                    onChanged: (String value) {
                      nomeCategoria = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Selecione um Ícone",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...[
                        Icons.home,
                        Icons.shopping_cart,
                        Icons.computer,
                        Icons.menu_book_sharp,
                        Icons.auto_awesome,
                        Icons.card_giftcard,
                        Icons.monetization_on_outlined,
                        Icons.bar_chart,
                        Icons.workspace_premium,
                        Icons.fastfood,
                        Icons.directions_car,
                        Icons.local_activity,
                        Icons.school,
                        Icons.more_horiz,
                      ].map((icon) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              iconeCategoria = icon;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: iconeCategoria == icon
                                    ? const Color.fromARGB(255, 30, 163, 132)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                icon,
                                size: 30,
                                color: iconeCategoria == icon
                                    ? const Color.fromARGB(255, 30, 163, 132)
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
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
                  child: const Text('Salvar'),
                  onPressed: () async {
                    if (nomeCategoria != null && iconeCategoria != null) {
                      await editarCategoria(
                        widget.userId,
                        categoriaId,
                        nomeCategoria!,
                        iconeCategoria!,
                        categoriaAtual,
                      );
                      setState(() async {
                        await loadCategorias();
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
