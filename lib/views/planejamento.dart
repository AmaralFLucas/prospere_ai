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
      print(planList);
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
                            color: Color.fromARGB(31, 32, 32, 32),
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
                    color: Color.fromARGB(255, 30, 163, 132),
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
                    color: Color.fromARGB(255, 30, 163, 132),
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

  String formatCurrency(dynamic value) {
    // Tenta converter o valor para double, suportando diferentes formatos
    try {
      double parsedValue;

      if (value is String) {
        // Substitui separadores de milhar/decimal se necessário
        String normalizedValue = value.replaceAll('.', '').replaceAll(',', '.');
        parsedValue = double.parse(normalizedValue);
      } else if (value is num) {
        parsedValue = value.toDouble();
      } else {
        throw FormatException("Formato inválido: $value");
      }

      // Formata para o padrão brasileiro de moeda
      final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
      return format.format(parsedValue);
    } catch (e) {
      // Retorna um valor padrão ou mensagem de erro em caso de falha
      return 'Valor inválido';
    }
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, int index) {
    final isObjective = !plan['isExpense'];
    final backgroundColor =
        isObjective ? Colors.grey : const Color.fromARGB(255, 30, 163, 132);
    final progressColor =
        isObjective ? const Color.fromARGB(255, 30, 163, 132) : Colors.red;

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
                  if (!plan['isExpense'])
                    IconButton(
                      icon: const Icon(Icons.add,
                          color: const Color.fromARGB(255, 30, 163, 132)),
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
    bool isExpense = false; // Inicialmente definido como objetivo
    String descricao = "";
    double valorMeta = 0.0;
    String? selectedCategory; // Categoria selecionada
    bool showCategoryDropdown = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isExpense ? 'Nova Meta de Gastos' : 'Novo Objetivo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    onChanged: (value) => descricao = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Valor Meta'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        valorMeta = double.tryParse(value) ?? 0.0,
                  ),
                  if (showCategoryDropdown)
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('Selecione uma categoria'),
                      items: categorias
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  SwitchListTile(
                    title: const Text('É meta de gasto?'),
                    value: isExpense,
                    onChanged: (value) {
                      setState(() {
                        isExpense = value;
                        showCategoryDropdown =
                            value; // Exibir dropdown apenas para metas de gastos
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isExpense = false;
                    showCategoryDropdown = false;
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (descricao.isEmpty || valorMeta <= 0) {
                      print('Descrição ou valor inválido');
                      return;
                    }
                    if (isExpense && selectedCategory == null) {
                      print('Categoria não selecionada para meta de gasto');
                      return;
                    }
                    try {
                      if (isExpense) {
                        // Adicionando argumentos faltantes: valorAtual e tipo
                        await criarMetaGastoMensal(
                          widget.userId,
                          descricao,
                          valorMeta,
                          selectedCategory!,
                          0.0, // valorAtual inicial como 0.0
                          'gastoMesal', // Tipo definido como 'gasto'
                        );
                      } else {
                        await criarMeta(
                          widget.userId,
                          'objetivo',
                          descricao,
                          valorMeta,
                          null,
                        );
                      }
                      Navigator.pop(context);
                      _loadMetas(); // Atualizar a lista de metas
                    } catch (e) {
                      print('Erro ao criar meta: $e');
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
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
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('Selecione uma categoria'),
                      items: categorias
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  SwitchListTile(
                    title: const Text('É meta de gasto?'),
                    value: isExpense,
                    onChanged: (value) {
                      setState(() {
                        isExpense = value;
                        showCategoryDropdown =
                            value; // Exibir dropdown apenas para metas de gastos
                      });
                    },
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
                isExpense = false;
                showCategoryDropdown = false;
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
    print(selectedCategory);
    print(showCategoryDropdown);
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
              labelText: 'Valor Atingido',
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
