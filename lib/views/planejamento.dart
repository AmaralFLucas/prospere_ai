import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Planejamento extends StatefulWidget {
  const Planejamento({super.key});

  @override
  _PlanejamentoState createState() => _PlanejamentoState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color cardColor = const Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _PlanejamentoState extends State<Planejamento> {
  List<Map<String, dynamic>> planList = [
    {'name': 'Celular Novo', 'value': 100.0, 'spent': 100.0},
    {'name': 'PC Novo', 'value': 100.0, 'spent': 60.0},
    {'name': 'Geladeira Nova', 'value': 100.0, 'spent': 60.0},
  ];
  double totalGasto = 0;
  double totalPlanejado = 0;

  @override
  Widget build(BuildContext context) {
    totalPlanejado = planList.fold(0, (sum, item) => sum + item['value']);
    totalGasto = planList.fold(0, (sum, item) => sum + item['spent']);

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
            _buildTotalChart(),
            const SizedBox(height: 16),
            Expanded(child: _buildPlanList()), // Lista de planos com layout de lista
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

  Widget _buildTotalChart() {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                color: Colors.green,
                value: totalPlanejado - totalGasto,
                radius: 50,
              ),
              PieChartSectionData(
                color: Colors.red,
                value: totalGasto,
                radius: 50,
              ),
            ],
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
          ),
        ),
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
                      // Função para editar
                      _editPlan(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Função para excluir
                      setState(() {
                        planList.removeAt(index);
                      });
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
                      color: Colors.green,
                      value: plan['value'] - plan['spent'],
                      radius: 40,
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: plan['spent'],
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
            'Gasto Atual: R\$: ${plan['spent'].toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    String planName = '';
    String planValue = '';
    String selectedCategory = 'Casa';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Planejamento'),
          content: Column(
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
              DropdownButton<String>(
                value: selectedCategory,
                items: <String>[
                  'Casa',
                  'Educação',
                  'Outros',
                  'Eletrônicos',
                  'Supermercado',
                  'Transporte',
                  'Viagem'
                ].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ],
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
                setState(() {
                  planList.add({
                    'name': planName,
                    'value': double.parse(planValue),
                    'spent': 0,
                    'category': selectedCategory
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editPlan(int index) {
    // Função para editar o planejamento
  }
}
