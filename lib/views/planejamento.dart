import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:intl/intl.dart';

class Planejamento extends StatefulWidget {
  const Planejamento({Key? key, this.title, required this.userId})
      : super(key: key);
  final String? title;
  final String userId;

  @override
  _PlanejamentoState createState() => _PlanejamentoState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color cardColor = const Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _PlanejamentoState extends State<Planejamento> {
  List<Map<String, dynamic>> planList = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  double totalGasto = 0;
  String selectedFilter = 'Todos';
  double totalGastosPlanejado = 0;
  double totalObjetivosPlanejado = 0;
  double totalObjetivo = 0;
  bool showCategoryDropdown = false;
  String? selectedCategory;
  List<String> categorias = [];

  @override
  void initState() {
    super.initState();
    _loadMetas();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('categoriasDespesas')
        .get();

    setState(() {
      categorias = snapshot.docs.map((doc) => doc['nome'] as String).toList();
    });
  }

  Future<void> _loadMetas() async {
    String userId = widget.userId;

    Stream<QuerySnapshot> metasStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('metasFinanceiras')
        .snapshots();

    metasStream.listen((snapshot) {
      setState(() {
        planList = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final value = data['valorMeta'];
          final spent = (data['valorAtual'] > value)
              ? value
              : data['valorAtual']; // Limita o valor máximo
          return {
            'id': doc.id,
            'name': data['descricao'],
            'value': value,
            'spent': spent,
            'category': data['categoria'],
            'isExpense':
                data['tipoMeta'] == 'gastoMensal', // Filtro para gastos mensais
          };
        }).toList();

        // Calcula totais separados
        totalObjetivosPlanejado = planList
            .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
            .fold(
                0,
                (sum, item) =>
                    sum +
                    item['value']); // Soma os valores das metas de objetivo

        totalGastosPlanejado = planList
            .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
            .fold(
                0,
                (sum, item) =>
                    sum + item['value']); // Soma os valores das metas de gasto

        totalGasto = planList
            .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
            .fold(
                0,
                (sum, item) =>
                    sum +
                    item['spent']); // Soma os valores gastos de metas de gasto

        totalObjetivo = planList
            .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
            .fold(
                0,
                (sum, item) =>
                    sum +
                    item[
                        'spent']); // Soma os valores gastos de metas de objetivo
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aplica o filtro selecionado à lista de metas
    List<Map<String, dynamic>> filteredList = planList;
    if (selectedFilter == 'Objetivos') {
      filteredList = planList.where((item) => !item['isExpense']).toList();
    } else if (selectedFilter == 'Gastos') {
      filteredList = planList.where((item) => item['isExpense']).toList();
    }

    // Recalcula os totais baseados na lista filtrada
    double filteredTotalObjetivosPlanejado = filteredList
        .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
        .fold(
            0,
            (sum, item) =>
                sum + item['value']); // Soma os valores das metas de objetivo

    double filteredTotalObjetivo = filteredList
        .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
        .fold(
            0,
            (sum, item) =>
                sum +
                item['spent']); // Soma os valores gastos de metas de objetivo

    double filteredTotalGastosPlanejado = filteredList
        .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
        .fold(
            0,
            (sum, item) =>
                sum + item['value']); // Soma os valores das metas de gasto

    double filteredTotalGasto = filteredList
        .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
        .fold(
            0,
            (sum, item) =>
                sum +
                item['spent']); // Soma os valores gastos de metas de gasto

    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: const Text(
          'Planejamento',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtro de seleção
            Row(
              children: [
                const Text(
                  "Filtrar por:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'Todos',
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem(
                      value: 'Objetivos',
                      child: Text('Objetivos'),
                    ),
                    DropdownMenuItem(
                      value: 'Gastos',
                      child: Text('Gastos Mensais'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Gráficos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (selectedFilter !=
                    'Gastos') // Mostra apenas para "Todos" ou "Objetivos"
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildFilteredObjectiveChart(
                        filteredTotalObjetivo,
                        filteredTotalObjetivosPlanejado,
                      ),
                    ),
                  ),
                if (selectedFilter !=
                    'Objetivos') // Mostra apenas para "Todos" ou "Gastos"
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildFilteredExpenseChart(
                        filteredTotalGasto,
                        filteredTotalGastosPlanejado,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Lista de metas filtradas
            Expanded(
              child: _buildPlanList(filteredList),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPlanDialog(context);
        },
        backgroundColor: myColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilteredObjectiveChart(double totalSpent, double totalPlanned) {
  double spentPercentage =
      totalPlanned > 0 ? (totalSpent / totalPlanned) * 100 : 0;
  double remainingPercentage = 100 - spentPercentage;

  return Center(
    child: Column(
      children: [
        const Text(
          'Planejamento de Objetivos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: 150,
          height: 150,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: spentPercentage,
                  title: '${spentPercentage.toStringAsFixed(2)}%',
                ),
                PieChartSectionData(
                  color: Colors.grey,
                  value: remainingPercentage,
                  title: '${remainingPercentage.toStringAsFixed(2)}%',
                ),
              ],
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildFilteredExpenseChart(double totalSpent, double totalPlanned) {
  double spentPercentage =
      totalPlanned > 0 ? (totalSpent / totalPlanned) * 100 : 0;
  double remainingPercentage = 100 - spentPercentage;

  return Center(
    child: Column(
      children: [
        const Text(
          'Planejamento de Gastos Mensais',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: 150,
          height: 150,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.red,
                  value: spentPercentage,
                  title: '${spentPercentage.toStringAsFixed(2)}%',
                ),
                PieChartSectionData(
                  color: Colors.green,
                  value: remainingPercentage,
                  title: '${remainingPercentage.toStringAsFixed(2)}%',
                ),
              ],
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildPlanList(List<Map<String, dynamic>> metas) {
    return ListView.builder(
      itemCount:
          metas.length, // Corrigir para usar o comprimento da lista filtrada
      itemBuilder: (context, index) {
        final meta = metas[index];
        return _buildPlanCard(meta, index);
      },
    );
  }

// Função para formatar valores monetários
String formatCurrency(double value) {
  final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return format.format(value);
}

Widget _buildPlanCard(Map<String, dynamic> plan, int index) {
  final isObjective = !plan['isExpense'];
  final backgroundColor = isObjective ? Colors.grey : Colors.green;
  final progressColor = isObjective ? Colors.green : Colors.red;

  double percentage =
      plan['value'] > 0 ? (plan['spent'] / plan['value']) * 100 : 0;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              plan['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Botões de edição e exclusão
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: progressColor,
                    value: percentage,
                    title: '${percentage.toStringAsFixed(2)}%',
                    radius: 40,
                  ),
                  PieChartSectionData(
                    color: backgroundColor,
                    value: 100 - percentage,
                    title: '${(100 - percentage).toStringAsFixed(2)}%',
                    radius: 40,
                  ),
                ],
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        // Exibe os valores formatados
        Text(
          'Valor Planejado: ${formatCurrency(plan['value'])}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          isObjective
              ? 'Valor Atingido: ${formatCurrency(plan['spent'])}'
              : 'Gasto Atual: ${formatCurrency(plan['spent'])}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

  void _confirmDeleteMeta(String metaId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir esta meta?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Excluir',
                style: TextStyle(color: myColor),
              ),
              onPressed: () async {
                await deletarMeta(widget.userId, metaId);
                // setState(() {
                //   planList.removeAt(index);
                // });
                _loadMetas();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    String planName = '';
    String planValue = '';
    bool isExpense = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Planejamento'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome do Planejamento',
                      labelStyle: TextStyle(color: textColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: myColor),
                      ),
                    ),
                    onChanged: (value) {
                      planName = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Valor Planejado',
                      labelStyle: TextStyle(color: textColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: myColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      planValue = value;
                    },
                  ),
                  if (showCategoryDropdown)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: 'Selecionar Categoria'),
                      items: categorias.isNotEmpty
                          ? categorias.map((String categoria) {
                              return DropdownMenuItem<String>(
                                value: categoria,
                                child: Text(categoria),
                              );
                            }).toList()
                          : [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Nenhuma categoria disponível'),
                              ),
                            ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      value: selectedCategory,
                    ),
                  Row(
                    children: [
                      Checkbox(
                        value: isExpense,
                        onChanged: (bool? value) {
                          setState(() {
                            isExpense = value!;
                            showCategoryDropdown = isExpense;
                          });
                        },
                      ),
                      const Text('Meta de Gastos'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Adicionar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () async {
                if (planName.isNotEmpty && planValue.isNotEmpty) {
                  double valorMeta = double.parse(planValue);
                  double valorAtual = 0.0;
                  if (isExpense && selectedCategory != null) {
                    QuerySnapshot despesasSnapshot = await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(widget.userId)
                        .collection('despesas')
                        .where('categoria', isEqualTo: selectedCategory)
                        .get();

                    valorAtual = despesasSnapshot.docs
                        .fold(0, (sum, doc) => sum + (doc['valor'] as double));
                  }
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('metasFinanceiras')
                      .add({
                    'descricao': planName,
                    'valorMeta': valorMeta,
                    'valorAtual': valorAtual,
                    'categoria': selectedCategory,
                    'tipoMeta': isExpense ? 'gastoMensal' : 'objetivo',
                  });
                  _loadMetas();
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  void _editPlan(int index) {
    String updatedPlanName = planList[index]['name'];
    String updatedPlanValue = planList[index]['value'].toString();
    String? selectedCategory = planList[index]['category'];
    bool isExpense = planList[index]['isExpense'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Planejamento'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome do Planejamento',
                      labelStyle: TextStyle(color: textColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: myColor),
                      ),
                    ),
                    controller: TextEditingController(text: updatedPlanName),
                    onChanged: (value) {
                      updatedPlanName = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Valor Planejado',
                      labelStyle: TextStyle(color: textColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: myColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: updatedPlanValue),
                    onChanged: (value) {
                      updatedPlanValue = value;
                    },
                  ),
                  if (isExpense)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: 'Selecionar Categoria'),
                      items: categorias.isNotEmpty
                          ? categorias.map((String categoria) {
                              return DropdownMenuItem<String>(
                                value: categoria,
                                child: Text(categoria),
                              );
                            }).toList()
                          : [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Nenhuma categoria disponível'),
                              ),
                            ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      value: selectedCategory,
                    ),
                  Checkbox(
                    value: isExpense,
                    onChanged: (bool? value) {
                      setState(() {
                        isExpense = value!;
                        showCategoryDropdown = isExpense;
                      });
                    },
                  ),
                  const Text('Meta de Gastos'),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Salvar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                if (updatedPlanName.isNotEmpty && updatedPlanValue.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('metasFinanceiras')
                      .doc(planList[index]['id'])
                      .update({
                    'descricao': updatedPlanName,
                    'valorMeta': double.parse(updatedPlanValue),
                    'categoria': selectedCategory,
                    'tipoMeta': isExpense ? 'gastoMensal' : 'objetivo',
                  });
                  _loadMetas();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addValueToPlan(int index) {
    String additionalValue = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Valor à Meta'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Valor Adicional',
              labelStyle: TextStyle(color: textColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: myColor),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              additionalValue = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Adicionar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                if (additionalValue.isNotEmpty) {
                  final double addValue = double.parse(additionalValue);
                  final String planId = planList[index]['id'];
                  final double currentSpent = planList[index]['spent'];

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('metasFinanceiras')
                      .doc(planId)
                      .update({'valorAtual': currentSpent + addValue}).then(
                          (_) {
                    _loadMetas();
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
