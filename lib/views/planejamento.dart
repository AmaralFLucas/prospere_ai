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
  List<Map<String, dynamic>> planList = [];
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
            Expanded(child: _buildPlanGrid()), // Plano em GridView
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
    return GestureDetector(
      onTap: _showEditOrDeleteDialog,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                color: Colors.green,
                value: totalPlanejado - totalGasto,
                radius: 60,
              ),
              PieChartSectionData(
                color: Colors.red,
                value: totalGasto,
                radius: 60,
              ),
            ],
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 50,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanGrid() {
    return GridView.builder(
      itemCount: planList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        return _buildPlanCard(planList[index]);
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    return Container(
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
          Text(
            plan['name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: plan['value'] - plan['spent'],
                    radius: 30,
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: plan['spent'],
                    radius: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Valor: R\$: ${plan['value'].toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gasto: R\$: ${plan['spent'].toStringAsFixed(2)}',
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

  void _showEditOrDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar ou Excluir Planejamento'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editPlan();
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  planList.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _editPlan() {
    // Lógica para editar o planejamento
  }
}
