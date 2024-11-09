import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';

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
  double totalGastosPlanejado = 0;
  double totalObjetivosPlanejado = 0;
  double totalObjetivo = 0; // Para os objetivos que serão subtraídos do total
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
          'isExpense': data['tipoMeta'] == 'gastoMensal', // Filtro para gastos mensais
        };
      }).toList();

      // Calcula totais separados
      totalObjetivosPlanejado = planList
          .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
          .fold(0, (sum, item) => sum + item['value']); // Soma os valores das metas de objetivo

      totalGastosPlanejado = planList
          .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
          .fold(0, (sum, item) => sum + item['value']); // Soma os valores das metas de gasto

      totalGasto = planList
          .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
          .fold(0, (sum, item) => sum + item['spent']); // Soma os valores gastos de metas de gasto

      totalObjetivo = planList
          .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
          .fold(0, (sum, item) => sum + item['spent']); // Soma os valores gastos de metas de objetivo
    });
  });
}


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: myColor,
      automaticallyImplyLeading: false,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                  child: _buildObjectiveChart(),
                ),
              ),
              const SizedBox(width: 16),
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
                  child: _buildExpenseChart(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24), // Espaço entre gráficos e a lista
          Expanded(child: _buildPlanList()),
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
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}

  Widget _buildObjectiveChart() {
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
                  value: totalObjetivo, // Total de objetivos
                  radius: 50,
                ),
                PieChartSectionData(
                  color: Colors.grey,
                  value: totalObjetivosPlanejado - totalObjetivo, // Parte não concluída dos objetivos
                  radius: 50,
                ),
              ],
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

Widget _buildExpenseChart() {
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
                  color: Colors.green,
                  value: totalGastosPlanejado, // Valor total de metas planejadas
                  radius: 50,
                ),
                PieChartSectionData(
                  color: Colors.red,
                  value: totalGasto, // Total de gastos
                  radius: 50,
                ),
              ],
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

  Widget _buildPlanList() {
    return ListView.builder(
      itemCount: planList.length,
      itemBuilder: (context, index) {
        return _buildPlanCard(planList[index], index);
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, int index) {
    final isObjective = !plan['isExpense'];
    final backgroundColor = isObjective ? Colors.grey : Colors.green;
    final progressColor = isObjective ? Colors.green : Colors.red;

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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editPlan(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDeleteMeta(plan['id'], index);
                    },
                  ),
                  if (isObjective)
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () {
                        _addValueToPlan(index);
                      },
                    ),
                ],
              ),
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
                      value: plan['spent'],
                      radius: 40,
                    ),
                    PieChartSectionData(
                      color: backgroundColor,
                      value: plan['value'] - plan['spent'],
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
          const SizedBox(height: 8),
          Text(
            'Valor Planejado: R\$: ${plan['value'].toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            isObjective
                ? 'Valor Atingido: R\$: ${plan['spent'].toStringAsFixed(2)}'
                : 'Gasto Atual: R\$: ${plan['spent'].toStringAsFixed(2)}',
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
                setState(() {
                  planList.removeAt(index);
                });
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
